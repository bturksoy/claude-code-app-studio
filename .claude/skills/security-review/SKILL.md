---
name: security-review
description: Kod ve yapılandırma üzerinde güvenlik incelemesi yapar. OWASP kontrollerini, yetkilendirme mantığını, secret sızıntısını ve tehdit modelindeki önlemlerin uygulanıp uygulanmadığını denetler. SEC-REVIEW kapısını işletir.
---

# /security-review [kapsam]

Sahip: `security-engineer`. Kapsam: epic, sürüm veya boş (→ son sprint değişiklikleri).

---

## 1. Hedefli tarama (agent çağırmadan — ucuz ön eleme)

Grep ile şu desenleri ara ve bulgu adaylarını topla:

```
Secret sızıntısı : api[_-]?key|secret|password\s*=|token\s*=|BEGIN (RSA|PRIVATE)
Enjeksiyon riski : raw query, string concat + SELECT/INSERT, exec(, eval(
XSS riski        : innerHTML, dangerouslySetInnerHTML, v-html, |safe
Yetki eksikliği  : router/controller tanımları — auth middleware olmayanlar
Kripto           : md5|sha1|Math.random\(\)|DES|ECB
CORS/başlık      : cors\(|Access-Control-Allow-Origin
Deserializasyon  : pickle|yaml.load\(|JSON.parse\( + kullanıcı girdisi
Dosya            : path.join.*req\.|readFile.*req\.
```

Ayrıca bağımlılık taraması çalıştır (varsa): `npm audit`, `pip-audit`, `dotnet list package --vulnerable`.

## 2. `security-engineer` çağır

```
Kapsam: <ne incelendi>

TEHDİT MODELİ ÖNLEMLERİ (uygulanmış mı kontrol edilecek):
<threat-model.md'den YÜKSEK/KRİTİK önlemler tablosu>

TARAMA BULGU ADAYLARI:
<Grep sonuçları — dosya:satır + eşleşen satır>

BAĞIMLILIK TARAMASI:
<audit çıktısı>

DEĞİŞEN KOD:
<diff veya ilgili dosyalar>

API SÖZLEŞMESİ:
<endpoint listesi + security tanımları>

Görev: SEC-REVIEW kapısı.

1. Tarama adaylarını doğrula — hangileri gerçek açık, hangileri yanlış pozitif
2. Tehdit modelindeki her YÜKSEK/KRİTİK önlem uygulanmış mı — kodda göster
3. Ek kontroller:
   - Her endpoint'te yetkilendirme var mı, kaynak sahipliği (IDOR) kontrol ediliyor mu
   - Girdi doğrulama sınırda mı
   - Hata yanıtları detay sızdırıyor mu
   - Log'da gizli veri var mı
   - Hız sınırlama kritik uçlarda var mı
4. Her bulgu için SOMUT sömürü senaryosu yaz. Yazamıyorsan bulgu değildir → NOT.

Bulgu formatı:
[KRİTİK|YÜKSEK|ORTA|DÜŞÜK] <dosya:satır>
  Açık: | Sömürü: <saldırgan ne yapar, ne elde eder> | Etki: | Düzeltme: | Doğrulama:

Exploit kodu ÜRETME. Proje ölçeğine uygun ol.
Yanıtına "SEC-REVIEW: ONAY|ŞARTLI|RET" satırıyla başla.
```

## 3. Sun

```
## Güvenlik İncelemesi — <kapsam>
Verdikt: SEC-REVIEW <verdikt>

Bulgular: Kritik <a> | Yüksek <b> | Orta <c> | Düşük <d>
Yanlış pozitif elenen: <n>

[KRİTİK] <dosya:satır> — <açık>
  Sömürü: <senaryo>
  Düzeltme: <somut>

Tehdit modeli önlemleri: <uygulanan>/<toplam>
⚠ Uygulanmamış: <liste>

Bağımlılık: <açık sayısı> (<kritik sayısı> kritik)
```

## 4. Düzeltme ve kabul

`AskUserQuestion`:
- `Kritik + Yüksek bulguları düzelt (Önerilen)`
- `Sadece Kritik'leri düzelt, kalanı risk olarak kabul et`
- `Hepsini backlog'a story olarak ekle`

Kabul edilen riskler `product/risks.md`'ye: risk, gerekçe, kim kabul etti,
gözden geçirme tarihi. **Kabul kararı kullanıcınındır**, güvenlik mühendisinin değil.

Düzeltme seçilirse ilgili geliştiriciye tek turda gönder ve `RET` verdiktinde
düzeltme sonrası kapıyı bir kez daha çağır.

## 5. Kaydet

- `docs/security/checklist.md` — bu turun sonuçları (tarih damgalı)
- `.state/gates.jsonl` → SEC-REVIEW
- Kabul edilen riskler → `product/risks.md`

---

## Token notu

- **Grep ön elemesi bedava** ve agent'ın arama yapmasını önler — en büyük tasarruf.
- **1 agent çağrısı** + en fazla 1 düzeltme turu.
- Tehdit modelinin tamamını değil, sadece YÜKSEK/KRİTİK önlem tablosunu göm.
