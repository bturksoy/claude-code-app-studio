---
name: handoff
description: Bir agent'tan diğerine iş devri paketi üretir. Yapılanı, kalanı, alınan kararları ve tuzakları 200 kelimeyi geçmeyecek şekilde aktarır. Oturum sonu veya rol değişiminde kullanılır.
---

# /handoff [devreden] [alan]

Bağlam kaybını önler ve alan tarafın sıfırdan araştırma yapmasını engeller.

**Ne zaman:** rol değişimi, oturum sonu, dalga geçişi, bloke işi başkasına devretme.

---

## 1. Devir bilgisini topla

Mevcut oturumdan veya belirtilen story'den:
- Ne yapıldı (dosyalar, testler, kararlar)
- Ne yarım kaldı
- Hangi kararlar alındı ve neden
- Hangi tuzaklara düşüldü / hangi varsayımlar yapıldı
- Alan tarafın çalıştıracağı doğrulama komutu

## 2. Paketi üret — **200 kelime sınırı**

```markdown
## Devir Paketi
**Devreden:** <rol> | **Alan:** <rol> | **İş:** <story-id / konu> | **Tarih:** <tarih>

### Yapıldı
- <madde — somut, dosya/fonksiyon adıyla>

### Kaldı
- <madde — sonraki somut adım>

### Alınan kararlar
- <karar> — <tek cümle gerekçe>

### Dikkat
- <tuzak, varsayım, sürpriz>

### Dosyalar
- `<yol>` — <ne yapıldı>

### Doğrulama
```bash
<alan tarafın çalıştıracağı komut>
```
```

**Sınır aşılırsa:** Ayrıntıyı çıkar, sonucu bırak.
"Şunu denedim olmadı, sonra şunu denedim" → "X yaklaşımı seçildi çünkü Y."

## 3. Nereye yazılır

| Durum | Yer |
|---|---|
| Story devri | Story dosyasının sonuna `## Devir Notu` bölümü |
| Oturum sonu | `docs/CONTEXT.md` → "Şu an ne yapılıyor" |
| Dalga geçişi | Sonraki dalganın agent prompt'una gömülür (dosyaya yazılmaz) |
| Bloke devri | `product/sprints/sprint-NN.md` → not olarak |

## 4. Alan taraf için başlangıç

Devir paketi, alan agent'ın prompt'una **story ile birlikte** gömülür:

```
<STORY DOSYASI>

ÖNCEKİ ÇALIŞANDAN DEVİR:
<devir paketi>

Görev: Kaldığı yerden devam et. Devir paketindeki kararları SORGULAMA —
uygulanmış kararlardır. Sadece "Kaldı" bölümündeki işi yap.
```

---

## Kural

Devir paketi **yorum içermez**, sadece durum aktarır.
"Şunu daha iyi yapabilirdim" gibi ifadeler yazılmaz — o retro'nun işi.

---

## Token notu

- **0 agent çağrısı** — mevcut bağlamdan üretilir.
- 200 kelime sınırı kasıtlı: uzun devir notu, alan tarafın okuma maliyetidir.
- İyi bir devir paketi, alan agent'ın 5-8 dosya taramasını önler.
