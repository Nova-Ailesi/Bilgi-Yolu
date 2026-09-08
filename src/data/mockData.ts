import { Question, UserProfile, Story, CityStat } from '../types';

export const initialUser: UserProfile = {
  id: 'usr_local_1',
  name: 'Ahmet Demir',
  targetExam: 'TYT & AYT',
  cityCode: 6,
  cityName: 'Ankara',
  schoolName: 'Atatürk Anadolu Lisesi',
  totalXp: 340,
  level: 2,
  currentStreakDays: 5,
  weeklyStreakWeeks: 3,
  dailyGoalTarget: 10,
  weeklySolvedDays: [14, 12, 16, 11, 15, 8, 0],
  totalSolvedCount: 28,
  correctSolvedCount: 23,
  isSchoolAmbassador: true,
  isCityCoordinator: false,
  unlockedBadgeIds: ['ilk_adim', 'bilgi_yolcusu', 'okul_elcisi'],
};

export const sampleQuestions: Question[] = [
  {
    "id": "c445e236365f0d054238cde097e06e48bfb90951ddfc68c2d9fab0102b5892b9",
    "category": "ortaokul",
    "subCategory": "LGS",
    "subject": "Türkçe",
    "questionText": "Aşağıdaki cümlelerin hangisinde 'koşul-sonuç' ilişkisi vardır?",
    "options": [
      "A) Akşamları kitap okuduğu için kelime dağarcığı çok zengin.",
      "B) Havalar ısınırsa hafta sonu hep birlikte pikniğe gideriz.",
      "C) Sınavda başarılı olmak amacıyla her gün düzenli soru çözüyor.",
      "D) Kar yağışı yüzünden köy yolları ulaşıma kapandı."
    ],
    "correctIndex": 1,
    "explanation": "B şıkkında pikniğe gitme eyleminin gerçekleşmesi 'havaların ısınması' şartına/koşuluna bağlanmıştır (-sa/-se eki).",
    "year": 2024,
    "source": "MEB LGS",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "0860cf47c6c16a3a864ed23f154df76325b8cfa977ab614375b3e0227d42205f",
    "category": "ortaokul",
    "subCategory": "LGS",
    "subject": "Matematik",
    "questionText": "Alanı 144 cm² olan kare şeklindeki bir kartonun çevresi kaç santimetredir?",
    "options": [
      "A) 36",
      "B) 48",
      "C) 52",
      "D) 72"
    ],
    "correctIndex": 1,
    "explanation": "Karenin alanı a² = 144 ise kenar uzunluğu a = √144 = 12 cm'dir. Çevresi: 4 * 12 = 48 cm'dir.",
    "year": 2023,
    "source": "MEB LGS",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "13c3c7802f2c5bb4d6469b7239b7b592740891be72daf580e79d5004e83608ef",
    "category": "ortaokul",
    "subCategory": "LGS",
    "subject": "Fen Bilimleri",
    "questionText": "Dünya'nın Güneş etrafında dolanımı ve eksen eğikliği sonucunda aşağıdakilerden hangisi meydana gelir?",
    "options": [
      "A) Gece ve gündüzün ardalanması",
      "B) Mevsimlerin oluşması",
      "C) Günlük sıcaklık farkları",
      "D) Gelgit (medcezir) olayı"
    ],
    "correctIndex": 1,
    "explanation": "Dünya'nın 23° 27'lik eksen eğikliği ile Güneş etrafında dolanması mevsimlerin oluşmasının ana sebebidir. Gece-gündüz ise günlük kendi eksenindeki dönüşüyle oluşur.",
    "year": 2024,
    "source": "MEB LGS",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "1239204415ee4da0bc970ce7c06267d7baa5d41717e9577fe4228a2853fcf07c",
    "category": "lise",
    "subCategory": "TYT",
    "subject": "Matematik",
    "questionText": "3^(x+1) = 24 olduğuna göre, 3^x kaçtır?",
    "options": [
      "A) 6",
      "B) 8",
      "C) 12",
      "D) 18",
      "E) 21"
    ],
    "correctIndex": 1,
    "explanation": "3^(x+1) = 3^x * 3^1 = 24 olduğuna göre, her iki tarafı 3'e böldüğümüzde 3^x = 24 / 3 = 8 bulunur.",
    "year": 2024,
    "source": "ÖSYM TYT",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "6714eea7c2c86fc3f15efad01acc7a6bb3b28cf1f15b8df11df7894afcf818fe",
    "category": "lise",
    "subCategory": "TYT",
    "subject": "Türkçe",
    "questionText": "Aşağıdaki cümlelerin hangisinde bir yazım yanlışı yapılmıştır?",
    "options": [
      "A) Bu konuda hiçbir şey göründüğü kadar basit değil.",
      "B) Akşamki konserde herkes bir arada şarkı söyledi.",
      "C) 29 Ekim 1923'de Cumhuriyet ilan edildi.",
      "D) Türk Dil Kurumu'nun yeni sözlüğü yayımlandı.",
      "E) Pek çok öğrenci kütüphanede ders çalışıyordu."
    ],
    "correctIndex": 2,
    "explanation": "C şıkkında 1923 sayısı 'üç' ile biter (sert ünsüz 'ç'). Sertleşme kuralına göre ek '1923'te' şeklinde yazılmalıdır. '1923'de' yazımı hatalıdır.",
    "year": 2023,
    "source": "ÖSYM TYT",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "7b198b84e379f4730edecf4cdf74c7907de81f7ef23c15a4e2704c6c46ccd9fe",
    "category": "lise",
    "subCategory": "TYT",
    "subject": "Fizik",
    "questionText": "Sürtünmesiz yatay bir düzlemde durmakta olan 4 kg kütleli bir cisme 20 N büyüklüğünde yatay bir kuvvet uygulandığında cismin ivmesi kaç m/s² olur?",
    "options": [
      "A) 2",
      "B) 4",
      "C) 5",
      "D) 10",
      "E) 80"
    ],
    "correctIndex": 2,
    "explanation": "Newton'un 2. Hareket Yasası'na göre F = m * a. 20 = 4 * a => a = 5 m/s² bulunur.",
    "year": 2024,
    "source": "ÖSYM TYT",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "05bd5a4b9a1a80afcb927efab8586600e5b748392887da9980821c61b5694449",
    "category": "lise",
    "subCategory": "AYT",
    "subject": "Matematik",
    "questionText": "f(x) = x³ - 3x² + 5 fonksiyonunun x = 2 noktasındaki teğetinin eğimi kaçtır?",
    "options": [
      "A) 0",
      "B) 2",
      "C) 3",
      "D) 6",
      "E) 9"
    ],
    "correctIndex": 0,
    "explanation": "Teğetin eğimi f'(x) türevidir. f'(x) = 3x² - 6x. x = 2 yazılırsa: f'(2) = 3*(4) - 6*(2) = 12 - 12 = 0.",
    "year": 2024,
    "source": "ÖSYM AYT",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "0e724ac620df1538bae4721f455566bca368bb4910988add5d2aecbb8ed27f60",
    "category": "universite",
    "subCategory": "KPSS",
    "subject": "Tarih",
    "questionText": "Amasya Genelgesi'nde yer alan 'Milletin bağımsızlığını yine milletin azim ve kararı kurtaracaktır.' maddesi Milli Mücadele'nin hangi yönünü ifade eder?",
    "options": [
      "A) Sadece gerekçesini",
      "B) Amaç ve yöntemini",
      "C) Dış politikasını",
      "D) Ekonomik programını",
      "E) Askeri teşkilatlanmasını"
    ],
    "correctIndex": 1,
    "explanation": "'Milletin bağımsızlığı' kurtuluşun amacını, 'milletin azim ve kararı' ise izlenecek yöntemi ve halk iradesini ortaya koymaktadır.",
    "year": 2023,
    "source": "ÖSYM KPSS",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "e3e99c03c33834c3f8c057d3a65f1171d9f22b90930ceeb630855a84be20481d",
    "category": "universite",
    "subCategory": "KPSS",
    "subject": "Vatandaşlık",
    "questionText": "1982 Anayasası'na göre Türkiye Büyük Millet Meclisi (TBMM) kaç milletvekilinden oluşur?",
    "options": [
      "A) 450",
      "B) 500",
      "C) 550",
      "D) 600",
      "E) 650"
    ],
    "correctIndex": 3,
    "explanation": "2017 Anayasa değişikliği ile TBMM'deki milletvekili sayısı 550'den 600'e çıkarılmıştır.",
    "year": 2024,
    "source": "ÖSYM KPSS",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "5c4cf4aa756473eccc2e563084d13133efe7d7ae18cd77325122e2b22d39f0a5",
    "category": "universite",
    "subCategory": "ALES",
    "subject": "Sayısal Mantık",
    "questionText": "Bir sınıftaki öğrenciler sıralara ikişer ikişer oturursa 5 öğrenci ayakta kalıyor, üçer üçer oturursa 2 sıra boş kalıyor. Sınıfta kaç öğrenci vardır?",
    "options": [
      "A) 21",
      "B) 23",
      "C) 27",
      "D) 31",
      "E) 35"
    ],
    "correctIndex": 2,
    "explanation": "Sıra sayısı x olsun. Öğrenci sayısı = 2x + 5 = 3(x - 2). 2x + 5 = 3x - 6 => x = 11 sıra vardır. Öğrenci sayısı: 2*(11) + 5 = 27.",
    "year": 2023,
    "source": "ÖSYM ALES",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "87a858c059bdd2fed8b0c767a2f2474bdce0aadc0e8c7ed711ee1c2f6e7f9761",
    "category": "ehliyet",
    "subCategory": "MEB Ehliyet",
    "subject": "Trafik Kuralları",
    "questionText": "Trafik polisinin sol kolunu yukarı kaldırıp sağ kolunu yana uzatması veya her iki kolunu yana uzatması durumunda, polisin ön ve arka cephesindeki araçlar için trafik durumu nedir?",
    "options": [
      "A) Yol trafiğe açıktır",
      "B) Yol trafiğe kapalıdır (Dur)",
      "C) Hızlanarak geçilebilir",
      "D) Sadece toplu taşıma araçları geçebilir"
    ],
    "correctIndex": 1,
    "explanation": "Trafik görevlisinin kollarını açtığı yönlerdeki araçlar geçer; görevlinin ön ve arka cephesinde kalan araçlar için yol trafiğe kapalıdır (DUR).",
    "year": 2024,
    "source": "MEB E-Sınav",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "4892f194260eb921e67ffa0ee30fce1355d09f40f937b4716ae6827127877a1c",
    "category": "ehliyet",
    "subCategory": "MEB Ehliyet",
    "subject": "Motor ve Araç Tekniği",
    "questionText": "Araç gösterge panelinde 'Akü şarj ikaz ışığı' motor çalışırken yanıyorsa olası arıza sebebi nedir?",
    "options": [
      "A) Yağ filtresi tıkanmıştır",
      "B) Alternatör (şarj dinamosu) elektrik üretmiyordur veya kayışı kopmuştur",
      "C) Fren hidroliği bitmiştir",
      "D) Lastik basınçları düşüktür"
    ],
    "correctIndex": 1,
    "explanation": "Seyir halindeyken akü şarj lambasının yanması, alternatörün aküyü beslemediğini veya V kayışının koptuğunu gösterir; araç derhal güvenli şekilde durdurulmalıdır.",
    "year": 2024,
    "source": "MEB E-Sınav",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "d83f93c3b33ec65cffb9869982051daaf1922875b0c230615903f1cc1d1fba17",
    "category": "ehliyet",
    "subCategory": "MEB Ehliyet",
    "subject": "İlk Yardım",
    "questionText": "Koma pozisyonu (yarı yüzükoyun yan yatış) hangi durumdaki kazazedelere verilir?",
    "options": [
      "A) Bilinci açık, bacağında kırık olanlara",
      "B) Kalp masajı yapılanlara",
      "C) Bilinci kapalı fakat solunumu ve nabzı olanlara",
      "D) Omurga kırığı şüphesi bulunanlara"
    ],
    "correctIndex": 2,
    "explanation": "Koma pozisyonu, bilinci kapalı ancak yaşamsal refleksleri (solunum ve kalp atımı) devam eden kişilerin dilinin geriye kaçmasını ve kusmukla boğulmasını önlemek için verilir.",
    "year": 2024,
    "source": "MEB E-Sınav",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "cec186b5ffe26c66dca447743c8b7426cba0d450eb2180891f80eecff3ad7315",
    "category": "acikogretim",
    "subCategory": "AÖF",
    "subject": "Temel Hukuk",
    "questionText": "Yazılı bir hukuk kuralının yürürlükten kalkması için aynı veya üst düzeyde yeni bir kural tarafından yürürlükten kaldırılmasına ne ad verilir?",
    "options": [
      "A) İltibas",
      "B) İlga (Mülga)",
      "C) Butlan",
      "D) İptal",
      "E) Fesih"
    ],
    "correctIndex": 1,
    "explanation": "Bir kanunun ya da normun yetkili makamca yürürlükten kaldırılmasına 'İlga', yürürlükten kalkmış metne ise 'Mülga' denir.",
    "year": 2023,
    "source": "Anadolu Üniversitesi AÖF",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "6e0daf96ce406e05a63c1fb343f40850b85305a3adbb848ae1ebfc5e7327ba42",
    "category": "acikogretim",
    "subCategory": "AÖL",
    "subject": "Tarih",
    "questionText": "Osmanlı Devleti'nde ilk matbaayı kuran gayrimüslim tebaa dışında, ilk Türk matbaasını Lale Devri'nde kuran kişiler kimlerdir?",
    "options": [
      "A) İbrahim Müteferrika - Sait Efendi",
      "B) Katip Çelebi - Evliya Çelebi",
      "C) Nevşehirli Damat İbrahim Paşa - Nedim",
      "D) Yirmisekiz Çelebi Mehmet - Koçi Bey"
    ],
    "correctIndex": 0,
    "explanation": "1727 yılında Lale Devri'nde Şeyhülislam fetvasıyla ilk resmi Osmanlı Türk matbaasını İbrahim Müteferrika ve Sait Efendi kurmuştur.",
    "year": 2023,
    "source": "MEB AÖL",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "a7a4f34ff5afc45e5a085253c0cc5258598145043c30de3d02e8f6e68f3b9110",
    "category": "lise",
    "subCategory": "TYT",
    "subject": "Fizik",
    "questionText": "Bir iletkenin direncini artırmak için aşağıdakilerden hangisi yapılmalıdır?",
    "options": [
      "A) Boyunu uzatmak",
      "B) Kesit alanını büyütmek",
      "C) Özdirencini küçültmek",
      "D) Sıcaklığını mutlak sıfıra indirmek",
      "E) İletkeni ikiye katlamak"
    ],
    "correctIndex": 0,
    "explanation": "R = ρ * (L / A) formülüne göre iletkenin boyu (L) arttıkça direnç (R) doğru orantılı olarak artar.",
    "year": 2024,
    "source": "ÖSYM TYT",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  },
  {
    "id": "4173fe0e573298892f5c95d451879823f5de91f12eaf1066da0bfc598ca13b6c",
    "category": "ortaokul",
    "subCategory": "LGS",
    "subject": "Fen Bilimleri",
    "questionText": "21 Haziran tarihinde Kuzey Yarım Küre'de hangi mevsim başlar?",
    "options": [
      "A) Kış",
      "B) Sonbahar",
      "C) Yaz",
      "D) İlkbahar"
    ],
    "correctIndex": 2,
    "explanation": "21 Haziran yaz gündönümüdür. Güneş ışınları Yengeç Dönencesi'ne dik gelir ve Kuzey Yarım Küre'de yaz mevsimi başlar.",
    "year": 2024,
    "source": "MEB LGS",
    "repetitions": 0,
    "easeFactor": 2.5,
    "intervalDays": 1
  }
];

export const initialStories: Story[] = [
  {
    id: 'story_1',
    category: 'Matematik',
    title: 'TYT Matematik Püf Noktası',
    content:
      `📌 Ardışık tek sayıların toplamı her zaman terim sayısının karesine eşittir!\n\nÖrnek: 1 + 3 + 5 + 7 = 16 (4 terim -> 4² = 16). Sınavda saniyeler kazandırır.`,
    color: '#002366',
    iconName: 'Calculator',
  },
  {
    id: 'story_2',
    category: 'Türkçe',
    title: 'LGS Türkçe: Yazım Kuralları',
    content:
      `📌 "Şey" sözcüğü her zaman AYRI yazılır!\n\nBir şey, her şey, çok şey... "Şey" hiçbir zaman kendinden önceki kelimeye bitişmez.`,
    color: '#E30A17',
    iconName: 'BookOpen',
  },
  {
    id: 'story_3',
    category: 'Tarih',
    title: 'KPSS Tarih: Şifreli Hafıza',
    content:
      `📌 Mudanya Ateşkesi'ne katılan devletler: İ-F-İ-T (İtalya, Fransa, İngiltere, TBMM).\n\nUnutma: Yunanistan görüşmelere bizzat katılmamış, gemide beklemiştir!`,
    color: '#1B5E20',
    iconName: 'Compass',
  },
  {
    id: 'story_4',
    category: 'Trafik',
    title: 'Ehliyet: Geçiş Üstünlüğü',
    content:
      `📌 Geçiş Üstünlüğü Sıralaması: C-A-P-S\n\n1. Cankurtaran (Ambulans)\n2. Asayiş (Polis/Jandarma)\n3. Polis/İtfaiye\n4. Sivil Savunma`,
    color: '#E65100',
    iconName: 'Car',
  },
];

export const cityLeaderboard: CityStat[] = [
  { rank: 1, code: 6, name: 'Ankara', solved: 2450120, xp: 4900240, schools: 420 },
  { rank: 2, code: 34, name: 'İstanbul', solved: 2190840, xp: 4381680, schools: 850 },
  { rank: 3, code: 35, name: 'İzmir', solved: 1870300, xp: 3740600, schools: 380 },
  { rank: 4, code: 16, name: 'Bursa', solved: 1420900, xp: 2841800, schools: 240 },
  { rank: 5, code: 7, name: 'Antalya', solved: 1280450, xp: 2560900, schools: 210 },
  { rank: 6, code: 42, name: 'Konya', solved: 1150200, xp: 2300400, schools: 190 },
  { rank: 7, code: 1, name: 'Adana', solved: 980700, xp: 1961400, schools: 160 },
  { rank: 8, code: 26, name: 'Eskişehir', solved: 940100, xp: 1880200, schools: 150 },
];
export const sampleStories = initialStories;
export const cityRankings = cityLeaderboard;
