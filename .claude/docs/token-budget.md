# Token Bütçesi ve Optimizasyon Protokolü

Bu sistem çok-agent'lı çalışır; kontrolsüz bırakılırsa token tüketimi patlar.
Aşağıdaki kurallar **bağlayıcıdır** ve her agent tanımında referans verilir.

---

## 1. Bağlam Piramidi

Bir agent bilgiyi **en ucuz katmandan** almalıdır. Üst katman yetmiyorsa alta iner.

```
Katman 1 (bedava)   → Görev paketi (story/task dosyası) — kendi kendine yeterlidir
Katman 2 (ucuz)     → docs/CONTEXT.md (≤200 satır) + .state/project.json
Katman 3 (orta)     → İlgili SSoT dosyası (PRD / ADR / OpenAPI / şema) — hedefli bölüm
Katman 4 (pahalı)   → Kaynak kodda Grep ile hedefli arama
Katman 5 (çok pahalı) → Tam dosya okuma, dizin taraması
```

**Kural:** Katman 5'e inmeden önce, hangi Katman 3 dosyasının eksik olduğunu belirt.
Genelde cevap "dokümantasyon eksik"tir, "daha çok kod oku" değil.

---

## 2. Okuma bütçeleri (agent başına, tek görev için)

| Agent katmanı | Maks. tam dosya okuma | Maks. Grep | Notu |
|---|---|---|---|
| Yönetim (ceo, cto) | 3 | 5 | Sadece özet ve karar dosyaları |
| Ürün/Planlama | 6 | 10 | PRD/FRD kendi alanı |
| Geliştirme | 8 | 15 | Story + kontrat + dokunacağı modül |
| Kalite | 8 | 20 | Test için geniş arama makul |

Bütçe aşılacaksa agent **durur** ve şunu bildirir:
> "Bütçe aşıldı. Devam etmek için X dosyasına da bakmam gerekiyor — onaylıyor musun?"

---

## 3. Alt-agent (Task) protokolü

Bir agent başka bir agent'ı çağırdığında:

- **Girdi:** Görev + gerekli bağlamın **özeti** verilir; "şu dosyaları oku" denmez,
  gerekli içerik prompt'a gömülür. Alt-agent kör başlar; ne kadar az arama yaparsa o kadar iyi.
- **Çıktı:** Alt-agent **yapılandırılmış özet** döner — tam transkript, tam dosya
  içeriği veya düşünce zinciri **dönmez**. Standart format:

```
VERDİKT: <ONAY | ŞARTLI | RET | TAMAMLANDI | BLOKE>
ÖZET: <en fazla 3 cümle>
BULGULAR:
- [SEVİYE] <dosya:satır> — <tek cümle>
SONRAKİ ADIM: <tek satır>
```

- **Paralellik:** Bağımsız işler tek mesajda paralel çağrılır. Bağımlı işler
  zincirlenir; **asla** "her ihtimale karşı" agent açılmaz.

---

## 4. Model seçimi

| İş tipi | Model | Örnek |
|---|---|---|
| Muğlak, stratejik, çok değişkenli | `opus` | Mimari karar, kapsam pazarlığı, gereksinim çıkarımı |
| Belirli girdi → belirli çıktı | `sonnet` | Story implementasyonu, test yazımı, kod incelemesi |
| Mekanik/şablon | `haiku` | Changelog, index güncelleme, dosya adı denetimi, format |

Bir işi bir üst modele terfi ettirmeden önce sor: *girdi yeterince net mi?*
Net değilse çözüm daha büyük model değil, **daha iyi görev paketi**dir.

---

## 5. Görev paketi (Task Packet) ilkesi

Bir story/görev dosyası **kendi kendine yeterli** olmalıdır. İçinde:

- İlgili kabul kriterleri (kopyalanmış, referans değil)
- Uygulanacak ADR'nin **karar özeti** (ADR'yi açmaya gerek kalmamalı)
- Dokunulacak dosya yolları (tahmin değil, tespit edilmiş)
- Kapsam dışı olanlar (komşu story'ler)
- Hazır test senaryoları

Bu, geliştirici agent'ın 8 dosya yerine 1 dosya okumasını sağlar.
**En büyük token tasarrufu buradan gelir.**

---

## 6. Kapı (gate) modu

`product/review-mode.txt` içeriği:

| Mod | Çalışan kapılar | Tipik ek maliyet |
|---|---|---|
| `full` | Hepsi (~14 kapı) | +%60 |
| `lean` | Sadece faz geçişleri (~5 kapı) | +%20 |
| `solo` | Yok | +%0 |

Her skill, kapı çağırmadan önce bu dosyayı okur ve moda göre atlar.

---

## 7. Dokümantasyon hijyeni

- **Şişme kontrolü:** `docs/CONTEXT.md` 200 satırı, `docs/DECISIONS.md` 300 satırı
  aşarsa `/context-compact` çalıştırılır.
- **Index dosyaları:** Her koleksiyon dizininde (`adr/`, `epics/`, `test-cases/`)
  bir `index.md` bulunur. Agent önce index okur, sonra tek dosyaya iner.
- **Tekrar yasağı:** Aynı bilgi iki dosyada yaşamaz. Kopya bulunursa kaynağa link verilir.
- **Append-only tercih:** Karar günlüğü ve changelog'a ekleme yapılır, yeniden yazılmaz —
  prompt cache'i korur.

---

## 8. Oturum disiplini

- Bir oturumda **bir faz** yürüt. Faz bitince `/status` ile durumu diske yaz,
  yeni oturuma geç. Uzun oturumlar compact maliyeti üretir.
- Uzun çıktıları (rapor, plan) ekrana **iki kez** basma — dosyaya yaz, ekrana özet ver.
- Aynı dosyayı düzenledikten sonra doğrulamak için tekrar okuma.

---

## 9. Ölçüm

`/status` çıktısında son sprint için şu satır bulunur:

```
Token notu: <N> agent çağrısı, <M> kapı, mod=<lean>. Öneri: <varsa>
```

Bir sprintte 30'dan fazla agent çağrısı olduysa `delivery-manager` görev
paketlerinin yetersiz olduğunu raporlar.
