#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
Bilgi Yolu - Otomatik Soru Scraper (scraper.py)
MEB, ÖSYM, AÖF, AÖL ve Ehliyet sınavlarının kamuya açık, telifsiz çıkmış ve örnek
sorularını/PDF'lerini otomatik olarak indirir.
"""

import os
import sys
import logging
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s',
    datefmt='%H:%M:%S'
)

DOWNLOAD_DIR = os.path.join(os.path.dirname(__file__), 'downloads')
os.makedirs(DOWNLOAD_DIR, exist_ok=True)

HEADERS = {
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36 BilgiYoluBot/1.0'
}

# Kamuya açık resmi örnek soru kaynakları
SOURCES = [
    {
        'category': 'ortaokul',
        'subCategory': 'LGS',
        'name': 'MEB LGS Örnek Sorular',
        'url': 'https://odsgm.meb.gov.tr/www/ornek-sorular/icerik/681',
    },
    {
        'category': 'lise',
        'subCategory': 'TYT',
        'name': 'MEB OGM Materyal Soru Bankası',
        'url': 'https://ogmmateryal.eba.gov.tr/',
    },
    {
        'category': 'ehliyet',
        'subCategory': 'MEB Ehliyet',
        'name': 'MEB E-Sınav Ehliyet Çıkmış Sorular',
        'url': 'https://meb.gov.tr/',
    },
]

def download_file(url, save_name):
    """Verilen URL'den PDF dosyasını indirir."""
    filepath = os.path.join(DOWNLOAD_DIR, save_name)
    try:
        logging.info(f"İndiriliyor: {url} -> {save_name}")
        response = requests.get(url, headers=HEADERS, timeout=30, stream=True)
        if response.status_code == 200:
            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
            logging.info(f"Başarıyla kaydedildi: {filepath}")
            return filepath
        else:
            logging.warning(f"İndirilemedi. HTTP Durum: {response.status_code}")
            return None
    except Exception as e:
        logging.error(f"İndirme hatası ({url}): {e}")
        return None

def fetch_meb_sample_pdfs():
    """MEB ÖDSGM sayfasındaki örnek soru PDF linklerini bulur ve indirir."""
    downloaded_files = []
    logging.info("MEB Örnek Sorular taranıyor...")
    # Güvenli fallback/mock çalıştırma
    try:
        url = SOURCES[0]['url']
        resp = requests.get(url, headers=HEADERS, timeout=15)
        if resp.status_code == 200:
            soup = BeautifulSoup(resp.text, 'html.parser')
            for a_tag in soup.find_all('a', href=True):
                href = a_tag['href']
                if href.lower().endswith('.pdf'):
                    pdf_url = urljoin(url, href)
                    filename = os.path.basename(href)
                    fpath = download_file(pdf_url, filename)
                    if fpath:
                        downloaded_files.append(fpath)
    except Exception as e:
        logging.warning(f"Canlı web scraping esnasında istisna: {e}")
    
    return downloaded_files

def run_scraper():
    """Tüm scraper akışını yönetir."""
    logging.info("=== Bilgi Yolu Scraper Başlatıldı ===")
    downloaded = fetch_meb_sample_pdfs()
    logging.info(f"Toplam indirilen dosya sayısı: {len(downloaded)}")
    return downloaded

if __name__ == '__main__':
    run_scraper()
