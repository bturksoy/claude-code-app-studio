---
name: qa-run
description: Testleri çalıştırır, sonuçları raporlar, başarısız olanları analiz eder ve gerçek hataları BUG kaydına dönüştürür. Eksik test kapsamı varsa yazdırır.
---

# /qa-run [kapsam]

Sahip: `test-engineer`. Kapsam: story, epic, `regression`, `smoke` veya boş (→ tümü).

---

## 1. Test komutunu tespit et

`package.json` / `pyproject.toml` / `*.csproj` / `Makefile` içinden test komutunu bul.
Bulamazsan kullanıcıya sor — **tahmin etme**.

## 2. Çalıştır (Bash — agent çağırmadan)

Kapsama göre:
```
smoke      → en kritik <8 test
regression → tüm otomatik testler
<epic>     → o epic'in test dosyaları
boş        → tüm test paketi
```

Çıktıyı **olduğu gibi** sakla. Başarısız varsa: test adı, hata mesajı, yığın izi.

## 3. Analiz

Başarısız test yoksa → adım 5.

Varsa `test-engineer` çağır:

```
Test çıktısı:
<gerçek çıktı — kırpma>

İlgili story/AC bilgisi:
<başarısız testlerin bağlı olduğu kabul kriterleri>

İlgili kod:
<başarısız testin test ettiği dosyanın ilgili bölümü>

Görev: Her başarısızlık için sınıflandır:
- ÜRÜN HATASI: kod yanlış → BUG kaydı gerekir
- TEST HATASI: test yanlış yazılmış → test düzeltilir
- KIRILGAN (flaky): deterministik değil → karantina + neden analizi
- ORTAM: bağımlılık/veri/config sorunu → düzeltme adımı

Her biri için:
  <test adı> → <sınıf> → <kök neden tek cümle> → <düzeltme önerisi> → <öncelik>

Kırılgan testleri retry ile GİZLEME — nedenini bul.
```

## 4. Hata kayıtları

`ÜRÜN HATASI` sınıfındakiler için `/bug` akışını uygula (BUG-NNN dosyaları oluştur).
P0/P1 hatalar için: **önce başarısız olan testi koru**, sonra düzeltme story'si aç.

## 5. Kapsam boşluğu kontrolü

Story'lerdeki kabul kriterlerini tara (Grep `AC-`), test dosyalarında karşılığı
olmayanları listele:

```
⚠ Testi olmayan kabul kriterleri:
  story-004 AC-3 — <kriter>
```

Kullanıcıya sor: eksik testler şimdi yazılsın mı?
Evet ise `test-engineer`'a **tek çağrıda** hepsini yazdır.

## 6. Sun

```
## Test Çalıştırma — <kapsam>
Komut: <komut>
Sonuç: <geçen>/<toplam> — <süre>

Başarısız (<n>)
| Test | Sınıf | Kök neden | Aksiyon |
| ... | ÜRÜN HATASI | ... | BUG-021 açıldı |
| ... | KIRILGAN | ... | karantinaya alındı |

Kapsam: <yüzde> (hedef <yüzde>)
⚠ Testi olmayan AC: <n>

Açılan hatalar: BUG-021 (P1), BUG-022 (P2)

▶ Sonraki: <duruma göre — /bug triage, /dev-task <düzeltme>, /dod-check>
```

## 7. Kaydet

`docs/qa/runs/run-<tarih>.md` — komut, sonuç, başarısızlıklar, açılan hatalar.
Kırılgan testleri `docs/qa/flaky.md`'ye ekle (test adı, ilk görülme, hipotez).

---

## Token notu

- Test çalıştırma **bedava** (Bash). Agent sadece **başarısızlık varsa** çağrılır.
- Hepsi geçtiyse **hiç agent çağrılmaz**.
- Başarısız testlerin tam çıktısı gömülür — analiz kalitesi buna bağlı.
- Eksik testleri tek çağrıda toplu yazdır.
