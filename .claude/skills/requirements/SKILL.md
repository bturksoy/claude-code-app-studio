---
name: requirements
description: PRD'deki yetenekleri test edilebilir fonksiyonel gereksinimlere (REQ), ölçülebilir fonksiyonel olmayan gereksinimlere (NFR) ve veri sözlüğüne çevirir. BA-REQ ve QA-TESTABLE kapılarını işletir.
---

# /requirements

Sahip: `business-analyst`, denetleyen: `qa-lead`.
Çıktı: `product/requirements/{FRD.md, NFR.md, data-dictionary.md}`

Ön koşul: `product/prd/PRD.md`.

---

## 1. Kapsamı belirle

PRD'deki "Olmalı" + "Olmalıydı" yeteneklerini al. "Olabilir" olanları **dahil etme** —
sonraki fazda yazılır. Yetenek sayısı 12'den fazlaysa kullanıcıya sor:

> "<N> yetenek var. Hepsini birden mi yazalım, yoksa önce MVP fazındaki <M> tanesini mi?"

Faz bazlı yazmak hem daha ucuz hem daha az çöp üretir.

## 2. `business-analyst` çağır

Bağlam bloğuna göm: hedefler, personalar, seçilen yetenek listesi (ID + tanım +
kullanıcı değeri), aktör/yetki tablosu, veri kavramları, discovery'deki kararlar,
kısıtlar.

```
<BAĞLAM BLOĞU>

Görev: Fonksiyonel gereksinimleri (FRD), NFR'leri ve veri sözlüğünü üret.

FRD kuralları:
- Her yetenek 1-5 REQ'e bölünür. REQ kimliği: REQ-<ALAN>-<NNN>
- Her REQ: kaynak (FEAT/GOAL), öncelik, aktör, tetikleyici, davranış,
  iş kuralları (BR-N), kabul kriterleri (Given/When/Then), hata/sınır tablosu,
  bağımlılıklar, varsayımlar
- Kabul kriteri gözlemlenebilir ve belirli olmalı. Ölçülemez ifade yazma.
- Her REQ için EN AZ 2 hata/sınır senaryosu. Sadece mutlu yol yazma.
- Yetki gerektiren her REQ'de "kim yapamaz" da yazılmalı.

NFR kuralları:
- Kategoriler: performans, ölçek, kullanılabilirlik, güvenlik, erişilebilirlik,
  gözlemlenebilirlik, uyumluluk, bakım, kurtarma
- Her NFR sayısal hedef + ölçüm yöntemi + kaynak GOAL içerir
- Ölçülemeyen NFR yazma — yazamıyorsan o satırı atla ve "AÇIK SORU" listesine ekle

Veri sözlüğü:
- Her iş terimi: tanım, tip/format, zorunluluk, kaynak, örnek, eşanlamlılar
- Aynı kavrama iki isim varsa birini kanonik seç

Belirsizlik varsa UYDURMA. "AÇIK SORU:" satırı aç ve bloke edici mi belirt.
Önce sadece REQ başlık listesini ver (ID + başlık + kaynak yetenek), sonra detayları.
```

## 3. Açık soruları çöz

BA'nın `AÇIK SORU` satırlarını topla. Bloke edici olanları `AskUserQuestion` ile
kullanıcıya sor (tur başına 4 soru, toplam 8'i geçme).

Cevapları **tek seferde** BA'ya geri gönder:
```
Şu sorular cevaplandı: <soru → cevap listesi>
Etkilenen REQ'leri güncelle. Sadece değişen REQ'leri döndür, tamamını tekrar yazma.
```

## 4. QA-TESTABLE kapısı (full mod)

`product/review-mode.txt` `full` ise `qa-lead` çağır:

```
Aşağıdaki kabul kriterlerini test edilebilirlik açısından değerlendir.
<REQ ID + AC listesi — sadece kabul kriterleri, tam REQ metni değil>

Her kriteri şu testlerden geçir: gözlemlenebilirlik, belirlilik, sınırlar,
hata yolu, ölçülebilirlik.

Geçemeyenler için SOMUT düzeltme öner (yeniden yazılmış kriter metni).
Yanıtına "QA-TESTABLE: ONAY|ŞARTLI|RET" satırıyla başla.
```

`ŞARTLI` maddelerini kriterlere işle. Kapıyı tekrar çağırma.

## 5. BA-REQ kapısı

`business-analyst`'ten verdikt iste. **Tercihen adım 2'deki çağrının sonunda** —
ayrı bir tur açma. Prompt'un sonuna şunu ekle:

```
Son olarak kendi çıktını denetle ve yanıtını
"BA-REQ: ONAY|ŞARTLI|RET" satırıyla bitir.

Kriterler:
- Her REQ bir GOAL'a bağlı mı?
- Her REQ'in en az bir Given/When/Then kabul kriteri var mı?
- Her REQ'in hata/sınır tablosu dolu mu (en az 2 senaryo)?
- İki gereksinim birbiriyle çelişiyor mu?
- Veri sözlüğündeki her terim en az bir REQ'te kullanılıyor mu (ve tersi)?
- Açık soruların hangileri bloke edici, belirtilmiş mi?

ŞARTLI ise en fazla 5 uygulanabilir madde listele.
```

`solo` modda bu kapıyı atla.

## 6. Sun ve yaz

Ekrana **kapsama tablosu** ver:

```
## Gereksinim Özeti
| Yetenek | REQ sayısı | AC sayısı | Öncelik |
|---|---|---|---|
| FEAT-01 | 4 | 11 | Olmalı |

NFR: <N> adet (<kategori dağılımı>)
Veri sözlüğü: <N> terim
Açık soru: <N> (<B> bloke edici)
Kapılar: BA-REQ <verdikt> | QA-TESTABLE <verdikt/atlandı>

⚠ GOAL'a bağlanmayan REQ: <varsa liste>
⚠ Kabul kriteri olmayan REQ: <varsa liste>
```

`AskUserQuestion` ile onay al, sonra üç dosyayı yaz.

Ayrıca:
- `docs/CONTEXT.md` → "Kritik NFR'ler" bölümünü doldur (en fazla 5 satır)
- `.state/gates.jsonl` → kapı satırları
- `.state/project.json` → `phase: "design"`

## 7. Kapat

```
✓ Gereksinimler yazıldı.
  FRD: <N> REQ | NFR: <M> | Veri sözlüğü: <K> terim

▶ Sonraki: /roadmap  (fazlandırma)
   veya doğrudan /architecture (roadmap netse)
```

---

## Token notu

- **1-2 agent çağrısı** (BA + full modda qa-lead). Paralel çalıştırılamaz —
  QA, BA'nın çıktısına bakar.
- Faz bazlı yazma en büyük tasarruf: 30 REQ yerine 12 REQ.
- Açık soruları **toplu** sor ve **tek seferde** geri gönder.
- Güncelleme turunda BA'dan sadece **değişen REQ'leri** iste.
