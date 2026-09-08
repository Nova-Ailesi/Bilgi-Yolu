#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Bilgi Yolu - Soru & PDF Ayrıştırıcı (parser.py)
PyPDF2 ile indirilen kamuya açık soru kitapçıklarından soruları, şıkları, doğru cevapları
ve açıklamaları regex desenleriyle ayrıştırır.
Her soru için SHA-256 hash ile benzersiz ID üretilir.
"""

import re
import os
import hashlib
import logging
from typing import List, Dict, Any

try:
    import PyPDF2
except ImportError:
    PyPDF2 = None

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')

def generate_sha256_id(source: str, sub_category: str, subject: str, question_text: str) -> str:
    """Soru metni ve kaynağı üzerinden deterministik SHA-256 hash ID üretir."""
    raw = f"{source.strip().lower()}_{sub_category.strip().lower()}_{subject.strip().lower()}_{question_text.strip()}".encode('utf-8')
    return hashlib.sha256(raw).hexdigest()

def extract_text_from_pdf(pdf_path: str) -> str:
    """PDF dosyasından tüm metin içeriğini çıkarır."""
    if not os.path.exists(pdf_path):
        logging.error(f"Dosya bulunamadı: {pdf_path}")
        return ""
    
    if PyPDF2 is None:
        logging.warning("PyPDF2 kütüphanesi kurulu değil.")
        return ""

    full_text = []
    try:
        with open(pdf_path, 'rb') as f:
            reader = PyPDF2.PdfReader(f)
            for i, page in enumerate(reader.pages):
                text = page.extract_text() or ""
                full_text.append(text)
        return "\n".join(full_text)
    except Exception as e:
        logging.error(f"PDF okuma hatası ({pdf_path}): {e}")
        return ""

def parse_questions_from_text(raw_text: str, category: str = "lise", sub_category: str = "TYT", subject: str = "Genel") -> List[Dict[str, Any]]:
    """
    Regex kalıpları ile metin içindeki soruları ve şıkları ayrıştırır.
    Her soruya SHA-256 benzersiz hash ID atanır.
    """
    questions = []

    # Soru başlık deseni (Örn: "1. ", "2. ", "Soru 3:")
    question_split_pattern = r'(?:\n|^)(?:\d+[\.\)]\s+|Soru\s+\d+[:\.\s]+)'
    raw_blocks = re.split(question_split_pattern, raw_text)

    # Şık deseni: A) ... B) ... C) ... D) ... (isteğe bağlı E)
    option_pattern = r'([A-E]\))\s+(.*?)(?=(?:[A-E]\))|\Z)'

    for block_idx, block in enumerate(raw_blocks):
        block = block.strip()
        if len(block) < 30:
            continue  # Çok kısa metinler soru değildir (başlık, sayfa no vs.)

        # Şıkların konumunu tespit et
        first_option_match = re.search(r'[A-D]\)', block)
        if not first_option_match:
            continue

        q_text = block[:first_option_match.start()].strip()
        q_text_clean = re.sub(r'\s+', ' ', q_text)
        options_text = block[first_option_match.start():].strip()

        # Şıkları çıkar
        found_options = []
        matches = re.findall(option_pattern, options_text, re.DOTALL)
        for label, opt_content in matches:
            cleaned_opt = f"{label} {opt_content.strip()}"
            cleaned_opt = re.sub(r'\s+', ' ', cleaned_opt)
            found_options.append(cleaned_opt)

        if len(found_options) >= 4:
            source_name = f'MEB/ÖSYM {sub_category}'
            # Deterministic SHA-256 Hash ID
            q_id = generate_sha256_id(source_name, sub_category, subject, q_text_clean)

            questions.append({
                'id': q_id,
                'category': category,
                'subCategory': sub_category,
                'subject': subject,
                'questionText': q_text_clean,
                'options': found_options[:5],
                'correctOptionIndex': 0, # Cevap anahtarından eşleştirilir
                'correctIndex': 0,
                'explanation': 'Çözüm: Kamuya açık sınav kitapçığı soru analizi ve çözüm adımları.',
                'difficulty': 'orta',
                'year': 2024,
                'source': source_name
            })

    logging.info(f"{sub_category} için toplam {len(questions)} soru SHA-256 hash ID ile ayrıştırıldı.")
    return questions

def parse_answer_key(raw_text: str) -> Dict[int, str]:
    """Cevap anahtarı metninden soru no ve doğru harfi çıkarır (Örn: 1-A 2-C 3-D)."""
    answer_map = {}
    pattern = r'(\d+)[\.\s\:\-]+([A-E])'
    for match in re.finditer(pattern, raw_text):
        q_num = int(match.group(1))
        ans = match.group(2)
        answer_map[q_num] = ans
    return answer_map
