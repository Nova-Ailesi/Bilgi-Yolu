#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Bilgi Yolu - JSON Dönüştürücü ve Delta Birleştirici (converter.py)
Ayrıştırılan soruları standart mobil 'delta.json' şemasına dönüştürür,
SHA-256 hash ile soru tekrarını %100 engeller ve mevcut public/data/delta.json
ile birleştirerek GitHub Pages için yayınlar.
"""

import os
import json
import hashlib
import datetime
import logging
from typing import List, Dict, Any

logging.basicConfig(level=logging.INFO, format='%(asctime)s [%(levelname)s] %(message)s')

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
OUTPUT_FILE = os.path.join(PROJECT_ROOT, 'public', 'data', 'delta.json')

def compute_sha256(source: str, sub_category: str, subject: str, question_text: str) -> str:
    """Soru metni ve kaynağı üzerinden deterministik SHA-256 hash üretir."""
    raw = f"{source.strip().lower()}_{sub_category.strip().lower()}_{subject.strip().lower()}_{question_text.strip()}".encode('utf-8')
    return hashlib.sha256(raw).hexdigest()

def load_existing_delta() -> Dict[str, Any]:
    """Mevcut delta.json dosyasını yükler, yoksa boş şablon döndürür."""
    if os.path.exists(OUTPUT_FILE):
        try:
            with open(OUTPUT_FILE, 'r', encoding='utf-8') as f:
                return json.load(f)
        except Exception as e:
            logging.warning(f"Mevcut delta.json okunamadı, yeniden oluşturuluyor: {e}")

    return {
        'version': 1,
        'last_updated': datetime.datetime.utcnow().isoformat() + 'Z',
        'total_questions': 0,
        'categories': ['ortaokul', 'lise', 'universite', 'ehliyet', 'acikogretim'],
        'questions': []
    }

def merge_and_save_delta(new_questions: List[Dict[str, Any]]) -> str:
    """
    Yeni soruları eskilerle birleştirir, SHA-256 hash ID kontrolü ile
    tekrarları kesin olarak önler ve delta.json'a kaydeder.
    """
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    delta_data = load_existing_delta()

    existing_ids = {q['id'] for q in delta_data.get('questions', [])}
    added_count = 0

    for q in new_questions:
        q_text = q.get('questionText', '').strip()
        source = q.get('source', 'MEB/ÖSYM').strip()
        sub_cat = q.get('subCategory', 'Genel').strip()
        subject = q.get('subject', 'Genel').strip()

        # Eğer soru ID'si 64 karakterli SHA-256 değilse veya boşsa hesapla
        if 'id' not in q or len(q['id']) != 64:
            q['id'] = compute_sha256(source, sub_cat, subject, q_text)

        # Soru tekrarı engelleme: ID kümede varsa kesinlikle ekleme
        if q['id'] not in existing_ids:
            # SM-2 aralıklı tekrar varsayılan alanlarını hazırla
            q.setdefault('repetitions', 0)
            q.setdefault('easeFactor', 2.5)
            q.setdefault('intervalDays', 1)
            q.setdefault('nextReviewDate', None)
            q.setdefault('isWrongBookmarked', False)
            q.setdefault('isFavorite', False)
            q.setdefault('difficulty', 'orta')
            q.setdefault('correctOptionIndex', q.get('correctIndex', 0))

            delta_data['questions'].append(q)
            existing_ids.add(q['id'])
            added_count += 1

    delta_data['total_questions'] = len(delta_data['questions'])
    delta_data['last_updated'] = datetime.datetime.utcnow().isoformat() + 'Z'
    delta_data['version'] = delta_data.get('version', 1) + (1 if added_count > 0 else 0)

    with open(OUTPUT_FILE, 'w', encoding='utf-8') as f:
        json.dump(delta_data, f, ensure_ascii=False, indent=2)

    logging.info(f"delta.json güncellendi: {added_count} yeni benzersiz soru eklendi (SHA-256 doğrulandı). Toplam: {delta_data['total_questions']}")
    return OUTPUT_FILE

if __name__ == '__main__':
    # Örnek başlangıç sorularını SHA-256 ile delta.json'a kaydet
    test_questions = [
        {
            'category': 'lise',
            'subCategory': 'TYT',
            'subject': 'Fizik',
            'topic': 'Elektrik',
            'questionText': 'Bir iletkenin direncini artırmak için aşağıdakilerden hangisi yapılmalıdır?',
            'options': [
                'A) Boyunu uzatmak',
                'B) Kesit alanını büyütmek',
                'C) Özdirencini küçültmek',
                'D) Sıcaklığını mutlak sıfıra indirmek',
                'E) İletkeni ikiye katlamak'
            ],
            'correctOptionIndex': 0,
            'explanation': 'R = ρ * (L / A) formülüne göre iletkenin boyu (L) arttıkça direnç (R) doğru orantılı olarak artar.',
            'difficulty': 'kolay',
            'year': 2024,
            'source': 'ÖSYM TYT'
        },
        {
            'category': 'ortaokul',
            'subCategory': 'LGS',
            'subject': 'Fen Bilimleri',
            'topic': 'Mevsimler ve İklim',
            'questionText': '21 Haziran tarihinde Kuzey Yarım Küre\'de hangi mevsim başlar?',
            'options': [
                'A) Kış',
                'B) Sonbahar',
                'C) Yaz',
                'D) İlkbahar'
            ],
            'correctOptionIndex': 2,
            'explanation': '21 Haziran yaz gündönümüdür. Güneş ışınları Yengeç Dönencesi\'ne dik gelir ve Kuzey Yarım Küre\'de yaz mevsimi başlar.',
            'difficulty': 'kolay',
            'year': 2024,
            'source': 'MEB LGS'
        }
    ]
    merge_and_save_delta(test_questions)
