---
name: team-feature
description: Bir özelliği (epic'i) tüm ekiple uçtan uca yürütür — sözleşme, veri, servis, arayüz, test, inceleme. Agent'ları doğru sırada ve mümkün olan yerde paralel çalıştırır. Dikey dilim teslimatı.
---

# /team-feature <epic-slug>

`delivery-manager` orkestrasyonunda çok agent'lı dikey dilim.
Tek tek `/dev-task` çağırmak yerine bir özelliği bir seferde bitirir.

**Ne zaman kullanılır:** Epic'in story'leri hazır ve birbirine bağımlı;
sıralı `/dev-task` çağrıları arasında bağlam kaybı olacak.

**Ne zaman kullanılmaz:** Tek story'lik iş (`/dev-task` yeter) veya
story'ler hazır değil (`/stories` çalıştır).

---

## 1. Hazırlık

Epic'in story'lerini yükle (başlık blokları). Kontrol et:
- Tüm story'ler `Hazır` mı? Bloke olan varsa listele ve dur.
- Bağımlılık grafiği döngüsüz mü?
- Toplam story sayısı ≤ 8? Fazlaysa iki turda yap.

Bağımlılık grafiğinden **dalga (wave)** çıkar:

```
Dalga 1 (paralel): bağımlılığı olmayan story'ler
Dalga 2 (paralel): sadece Dalga 1'e bağımlı olanlar
Dalga 3: ...
```

Aynı modüle dokunan story'ler **aynı dalgaya konulmaz** — sonraki dalgaya kaydır.

## 2. Planı sun

```
## Dikey Dilim: <epic adı>

Dalga 1 — paralel  [sözleşme & temel]
  story-001  sql-developer      <başlık>
  story-002  solution-architect <başlık>

Dalga 2 — paralel  [servis & arayüz]
  story-003  backend-developer  <başlık>
  story-004  frontend-developer <başlık>  (mock ile başlar)

Dalga 3 — sıralı   [entegrasyon & test]
  story-005  frontend-developer <başlık>  (gerçek API'ye geçiş)
  story-006  test-engineer      <başlık>

Toplam: <N> story | <M> agent çağrısı tahmini
```

`AskUserQuestion`: `Başlat (Önerilen)` / `Sadece Dalga 1'i çalıştır` /
`Tek tek /dev-task ile ilerleyeceğim`

## 3. Dalgaları yürüt

Her dalga için:

**a) Paralel çağrı** — dalgadaki tüm story'ler tek mesajda, her biri kendi
agent'ına. Her prompt `/dev-task` adım 3'teki formatı kullanır (story tam gömülü).

**b) Sonuçları topla.** Her agent şu formatta döner:
`VERDİKT / ÖZET / DOSYALAR / TESTLER / KABUL KRİTERLERİ / NOT`

**c) Çakışma kontrolü.** İki agent aynı dosyaya yazdıysa:
- Değişiklikleri karşılaştır, çakışma varsa kullanıcıya göster
- Bu bir **planlama hatasıdır** — sonraki `/sprint-plan` için not düş

**d) Dalga kapısı.** Bir story `BLOKE` döndüyse:
- Ona bağımlı sonraki dalga story'lerini **durdur**
- Bağımsız olanlar devam eder
- Kullanıcıya durumu bildir, escalation yap

**e) Devir notu.** Dalga 2'ye geçerken, Dalga 1'in çıktısından sonraki dalganın
ihtiyacı olan bilgiyi **≤200 kelimelik devir paketi** olarak hazırla ve
sonraki dalganın prompt'una ekle:

```
ÖNCEKİ DALGADAN:
- <story-001> tamamlandı → <ne üretildi: tablo/endpoint/tip adları>
- Dikkat: <varsayım, tuzak>
- Kullanabileceğin: <dosya yolları, fonksiyon/tip adları>
```

## 4. Toplu kod incelemesi (lean+ mod)

Tüm dalgalar bitince **tek bir** `code-reviewer` çağrısı yap (story başına ayrı değil):

```
<TÜM DEĞİŞEN DOSYALARIN DIFF'İ>
<EPIC'İN kabul kriterleri ve kapsam sınırı>
<İLGİLİ kural dosyaları>

Görev: CR-CODE — dikey dilim incelemesi. Ek olarak:
- Katmanlar arası tutarlılık (FE'nin beklediği ile BE'nin döndürdüğü aynı mı)
- Sözleşme uyumu (OpenAPI ile gerçek implementasyon)
- Tekrar eden kod (iki agent aynı yardımcıyı ayrı ayrı yazmış olabilir)
```

## 5. Entegrasyon doğrulaması

Uçtan uca test çalıştır (varsa). Yoksa `test-engineer`'a bir tane yazdır:

```
Epic: <ad> — ana kullanıcı yolculuğu
Görev: Bu dilim için 1 adet uçtan uca test yaz ve çalıştır.
Kapsam: <akış adımları>
```

## 6. Sun

```
✓ Dikey dilim tamamlandı: <epic>

| Story | Sahip | Durum | Testler |
| 001 | sql-developer | ✓ | 4/4 |
| 004 | frontend-developer | ⚠ | 6/7 — <not> |

Toplam: <a> tamamlandı, <b> bloke
Kod incelemesi: CR-CODE <verdikt>
Uçtan uca: <sonuç>

Planlama notları (sonraki sprint için):
- <çakışma veya bağımlılık sürprizi>

▶ Sonraki: /dod-check <epic>  → /qa-run <epic>
```

---

## Token notu

- Paralellik **wall-clock** kazandırır, token kazandırmaz — maliyet story sayısıyla
  doğrusaldır. Aynı işi yapıyorsun, sadece daha hızlı.
- **Toplu kod incelemesi** gerçek tasarruf: 6 ayrı inceleme yerine 1 tane.
- Devir paketleri ≤200 kelime — dalga arası bağlam aktarımı ucuz olmalı.
- 8 story üst sınırı: fazlası hem çakışma hem bağlam riski.
