---
name: stories
description: Bir epic'i story'lere böler. Her story kendi kendine yeterli bir GÖREV PAKETİ olarak yazılır — geliştirici agent başka dosya okumadan implement edebilir. Story tipi ve test senaryoları QA Lead tarafından atanır. Token optimizasyonunun kalbi.
---

# /stories <epic-slug>

Sahip: `business-analyst` + `qa-lead`, denetim: `solution-architect` (full mod).
Çıktı: `product/backlog/epics/<slug>/story-NNN-<slug>.md`

**Bu skill sistemin en kritik parçasıdır.** Story dosyasının kalitesi, sonraki tüm
geliştirme adımlarının token maliyetini belirler. İyi bir story = 1 dosya okuma.
Kötü bir story = 8 dosya okuma + geri dönüşler.

---

## 1. Girdiyi yükle

Argüman yoksa `product/backlog/index.md`'den story'si olmayan ilk epic'i öner.

Oku:
- `product/backlog/epics/<slug>/EPIC.md`
- Epic'in kapsadığı REQ'ler — `FRD.md`'den **tam metin** (davranış, iş kuralları,
  kabul kriterleri, hata tablosu)
- Epic'in listelediği ADR'lerin **"Uygulama rehberi"** bölümleri
- İlgili `openapi.yaml` endpoint tanımları
- İlgili `ER.md` tablo tanımları
- İlgili wireframe spesifikasyonları

**ADR doğrulaması:** Epic'te listelenen her ADR dosyası gerçekten var mı? Yoksa dur:
> "Epic ADR-NNNN'e referans veriyor ama dosya bulunamadı. `/adr` çalıştır veya
> epic'teki referansı düzelt. Story yazılamaz."

Durumu `Önerilen` olan ADR varsa ilgili story `Bloke` durumunda yazılır.

## 2. Story tipi sınıflandırması

| Tip | Ne zaman | Zorunlu kanıt |
|---|---|---|
| **Logic** | İş kuralı, hesaplama, durum geçişi, validasyon | Unit test |
| **Integration** | 2+ bileşen, API çağrısı, kuyruk, dış servis | Integration test |
| **Data** | Şema, migration, index, veri dönüşümü | Migration up/down + şema güncel |
| **UI** | Ekran, komponent, form, navigasyon | Komponent testi veya kanıt dosyası |
| **Infra** | CI/CD, ortam, IaC, izleme | Pipeline çıktısı + rollback yazılı |
| **Config** | Sadece ayar/veri, yeni mantık yok | Smoke kaydı |

Karma story'de **en yüksek riskli tip** geçerlidir.

## 3. `business-analyst` çağır — kırılım

```
<EPIC BİLGİSİ>
<REQ'LERİN TAM METNİ — davranış, BR-*, kabul kriterleri, hata tablosu>
<İLGİLİ ADR UYGULAMA REHBERLERİ>
<İLGİLİ API ENDPOINT'LERİ>
<İLGİLİ TABLOLAR>
<İLGİLİ EKRAN SPESİFİKASYONLARI>
<MODÜL LİSTESİ ve BAĞIMLILIK YÖNÜ>

Görev: Bu epic'i story'lere böl.

Kurallar:
1. Bir story = tek odaklı bir oturumda bitecek iş (1-3 gün / 2-4 saatlik odak)
2. Bir story = bir sahip = bir ana modül. İki modüle yayılıyorsa BÖL.
3. Sıra: sözleşme/şema → temel davranış → sınır durumları → arayüz → cila
4. Her kabul kriteri (AC) tam olarak bir story'ye ait olmalı — bölünmemeli
5. Her story'ye tip ata (Logic/Integration/Data/UI/Infra/Config)
6. Her story'ye sahip rol ata (frontend-developer, backend-developer,
   sql-developer, devops-engineer, data-engineer, test-engineer)
7. Bağımlılıkları belirt: "Önce X bitmeli", "Bunu Y bekliyor"

Önce SADECE story listesini ver:
| # | Başlık | Tip | Sahip | REQ | AC | Bağımlı | Tahmin |

Detayları henüz yazma.
```

## 4. `qa-lead` çağır — test senaryoları

BA'nın listesi geldikten sonra (sıralı, paralel değil):

```
<STORY LİSTESİ>
<İLGİLİ KABUL KRİTERLERİ — Given/When/Then>

Görev:
1. Story tiplerini doğrula. Yanlış atanmış varsa düzelt ve gerekçelendir.
2. Her Logic ve Integration story'si için somut test senaryosu spesifikasyonu üret:
   TC-<REQ-ID>-NN: <başlık>
     Given: <önkoşul>  When: <eylem>  Then: <assert edilecek somut sonuç>
     Sınır durumları: <liste>  Öncelik: P0|P1|P2
3. Her UI story'si için manuel doğrulama adımları:
   Kurulum: <nasıl bu duruma gelinir>  Doğrula: <ne aranır>  Geçme koşulu: <net>
4. Test edilemez kabul kriteri varsa BELİRT ve yeniden yazılmış halini öner.

Geliştirici bu senaryolara karşı kod yazacak — sıfırdan test icat etmeyecek.
```

## 5. `solution-architect` denetimi (full mod)

```
<STORY LİSTESİ + modül atamaları>
Görev: Mimari uygunluk. ARCH-STORY kapısı.
- Her story tek modülde mi kalıyor?
- Sözleşme üreten story'ler tüketenlerden önce mi?
- Bağımlılık zinciri 3'ten uzun mu?
- Aynı dosyaya yazacak paralel story var mı?
Yanıtına "ARCH-STORY: ONAY|ŞARTLI|RET" ile başla. En fazla 10 satır.
```

## 6. Kullanıcıya sun

```
## Story Kırılımı — Epic: <ad>

| # | Başlık | Tip | Sahip | REQ | Tahmin | Bağımlı |
| 001 | ... | Data | sql-developer | REQ-X-001 | S | — |

Toplam: <N> story  (Logic <a>, Integration <b>, Data <c>, UI <d>, Infra <e>)
Kapsanan AC: <X>/<Y>
Bloke story: <varsa — nedeniyle>
Kapı: ARCH-STORY <verdikt/atlandı>

⚠ Kapsanmayan kabul kriteri: <varsa liste>
```

`AskUserQuestion`: `<N> story'yi yaz (Önerilen)` / `Kırılımı değiştireceğim` /
`Önce sadece ilk 3'ünü yaz`

## 7. Story dosyalarını yaz — GÖREV PAKETİ FORMATI

**En kritik bölüm.** Story kendi kendine yeterli olmalı; geliştirici agent
`docs/` altındaki hiçbir dosyayı açmak zorunda kalmamalı.

```markdown
# Story <NNN>: <başlık>

> **Epic:** <ad> | **Tip:** <tip> | **Sahip:** <agent> | **Durum:** Hazır
> **Tahmin:** <S/M/L veya saat> | **Sprint:** — | **Güncellenme:** <tarih>

## Ne yapılacak
<2-3 cümle. Geliştiricinin ilk okuyacağı şey. Teknik ve somut.>

## Kabul kriterleri
*Kaynak: REQ-<ID> — buraya KOPYALANDI, referans değil*

- [ ] **AC-1:** <kriter metni>
  - Given: <önkoşul>
  - When: <eylem>
  - Then: <gözlemlenebilir sonuç>
- [ ] **AC-2:** ...

## İş kuralları
*Kaynak: REQ-<ID> — kopyalandı*
- **BR-1:** <kural>
- **BR-2:** <kural>

## Hata ve sınır durumları
| Durum | Beklenen davranış | Kullanıcıya mesaj |
|---|---|---|

## Uygulanacak mimari kararlar
*ADR-<NNNN>: <başlık>*
<ADR'nin "Uygulama rehberi" bölümü BURAYA KOPYALANIR.
Geliştirici ADR dosyasını açmayacak.>

**Zorunlu desen:** <...>
**Yasak desen:** <...>

## Sözleşme
*İlgili endpoint / tablo / komponent tanımları — kopyalandı*

```yaml
POST /orders
  request: {...}
  responses: 201 {...}, 400 {...}, 409 {...}
```

```sql
-- ilgili tablo yapısı
```

## Dokunulacak dosyalar
*Tespit edilmiş yollar — tahmin değil*
- `src/backend/orders/order.service.ts` — <ne yapılacak>
- `tests/backend/orders/create-order.test.ts` — yeni

## Kapsam DIŞI
*Komşu story'ler halleder — burada YAPMA*
- Story <NNN+1>: <ne>
- Story <NNN+2>: <ne>

## Test senaryoları
*QA Lead tarafından yazıldı. Sıfırdan test icat etme — bunlara karşı kodla.*

**TC-<REQ>-01** — AC-1
- Given: <...> | When: <...> | Then: <...>
- Sınır durumları: <...>
- Öncelik: P0

## Zorunlu kanıt
**Tip:** <tip>
**Gereken:** <tipin zorunlu kanıtı — DoD'den>
**Dosya:** `tests/<yol>/<slug>.test.<ext>`
**Durum:** [ ] Henüz oluşturulmadı

## Bağımlılıklar
**Önce bitmeli:** <story-NNN veya Yok>
**Bunu bekliyor:** <story-NNN veya Yok>

## İzlenebilirlik
REQ-<ID> → GOAL-<NN> | ADR-<NNNN> | Ekran: <varsa>
```

Ayrıca:
- `EPIC.md`'deki "Story'ler" bölümünü tabloyla doldur
- `product/backlog/index.md`'de epic satırının `Story` sütununu güncelle
- `.state/project.json` → `counters.stories`
- `.state/gates.jsonl` → ARCH-STORY

## 8. Kapat

```
✓ <N> story → product/backlog/epics/<slug>/
  Logic <a> | Integration <b> | Data <c> | UI <d>

Story'ler görev paketi formatında — geliştirici agent tek dosya okuyacak.

▶ Sonraki:
   /stories <sonraki-epic>   (başka epic varsa)
   /sprint-plan              (tüm epic'ler kırıldıysa)
```

---

## Token notu — bu skill neden pahalı ama karlı

Bu skill **bilerek** çok bağlam yükler (REQ tam metni, ADR rehberi, sözleşmeler).
Çünkü bu maliyeti **bir kez** öder, karşılığında her `/dev-task` çağrısında
8 dosya okuma yerine 1 dosya okuma kazanır.

- 2-3 agent çağrısı (BA → QA → [full: SA])
- Story'leri **epic bazında** yaz, tüm backlog'u birden değil
- Kopyalama burada **doğrudur** — SSoT kuralının bilinçli istisnası.
  Kaynak değişirse `/context-compact` senkronizasyonu raporlar.
