---
name: context-compact
description: Şişmiş dokümanları sıkıştırır, index dosyalarını tazeler, story'lerdeki kopyalanmış içeriğin kaynakla senkronizasyonunu denetler ve tekrarları temizler. Doğrudan token tasarrufu sağlar.
---

# /context-compact

Sahip: `delivery-manager`. Çalıştırma zamanı: sprint sonu veya `/status` uyardığında.

---

## 1. Şişme denetimi (bedava)

```
docs/CONTEXT.md        ≤ 200 satır   → aşıyorsa sıkıştır
docs/DECISIONS.md      ≤ 300 satır   → aşıyorsa arşivle
product/risks.md       ≤ 100 satır   → kapanan riskleri arşivle
docs/qa/bugs/          kapananlar    → docs/qa/bugs/archive/ altına taşı
product/backlog/       DONE epic'ler → index'te kapalı işaretle
```

Her dosya için satır sayısını ölç ve raporla.

## 2. Index tazeleme (bedava)

Şu index dosyalarını yeniden üret (kaynak dizinleri tarayarak):

```
product/backlog/index.md          ← epics/*/EPIC.md
product/sprints/index.md          ← sprint-*.md
docs/architecture/adr/index.md    ← ADR-*.md
docs/qa/test-cases/index.md       ← test case dosyaları
docs/qa/bugs/index.md             ← BUG-*.md (açık olanlar)
```

Index'ler agent'ların **tek dosya okuyup** koleksiyona bakmasını sağlar.

## 3. Senkronizasyon denetimi ⚠ kritik

Story dosyaları kaynak dokümanlardan **kopyalanmış** içerik taşır
(bilinçli SSoT istisnası). Kaynak değiştiyse kopyalar bayat kalır.

Kontrol et:
- Story'lerdeki kabul kriterleri ↔ `FRD.md`'deki güncel hali
- Story'lerdeki ADR uygulama rehberi ↔ ADR dosyasının güncel hali
- Story'lerdeki sözleşme blokları ↔ `openapi.yaml` / `ER.md`

Yöntem: Grep ile story'lerdeki `REQ-*` ve `ADR-*` referanslarını topla,
kaynak dosyaların değişiklik tarihiyle story'nin `Güncellenme` tarihini karşılaştır.
Kaynak daha yeniyse **bayat aday**dır.

```
⚠ Bayat olabilecek story'ler:
  story-004 — REQ-ORD-003 <tarih>'te değişti, story <tarih>'te güncellendi
```

Kullanıcıya sor: bayat story'ler yenilensin mi (`/stories` ile ilgili epic tekrar).

## 4. Sıkıştırma

`docs/CONTEXT.md` şişmişse `delivery-manager` çağır:

```
Mevcut CONTEXT.md:
<tam içerik>

Ek durum: <project.json özeti>

Görev: 200 satırın altına sıkıştır.
Kuralları:
- Yapıyı KORU (şablon bölümleri değişmez)
- Tarihsel bilgi ÇIKAR — sadece "şu an geçerli olan" kalır
- Ayrıntı yerine referans: uzun açıklama → "<dosya>'ya bak"
- Teknoloji tablosu, kritik NFR'ler, aktif odak KORUNUR
- Bitmiş sprintlerin detayı çıkar, sadece özet kalır
```

`docs/DECISIONS.md` 300 satırı aşarsa: eski girdileri
`docs/decisions/archive-<yıl>.md`'ye taşı, ana dosyada özet satır bırak.

## 5. Tekrar avı (bedava)

Aynı bilginin iki yerde yaşadığını tespit et:
- Aynı NFR hem `NFR.md`'de hem `ARCHITECTURE.md`'de tam metin olarak mı var
- Aynı iş kuralı hem `FRD.md`'de hem `PRD.md`'de mi
- Aynı terim hem `data-dictionary.md`'de hem `ER.md`'de farklı mı tanımlı

Bulunanları raporla; **sahibi olmayan kopyayı** referansa çevirmeyi öner
(`.claude/docs/context-protocol.md` SSoT tablosuna göre).

## 6. Sun

```
## Bağlam Sıkıştırma

Dosya boyutları
| Dosya | Önce | Sonra | Limit |
| docs/CONTEXT.md | 340 | 186 | 200 ✓ |

Index tazelendi: <N> dosya
Arşivlenen: <a> kapalı hata, <b> kapalı risk, <c> karar

⚠ Bayat story adayı: <n>
  story-004 — REQ-ORD-003 daha yeni

⚠ Tekrar eden içerik: <n>
  NFR-PERF-01 hem NFR.md hem ARCHITECTURE.md'de tam metin
  → ARCHITECTURE.md'de referansa çevrilmeli

Tahmini tasarruf: her agent çağrısında ~<N> satır daha az bağlam
```

## 7. Uygula

`AskUserQuestion` ile onay al, sonra değişiklikleri yaz.
Arşivlenen içerik **silinmez**, `archive/` altına taşınır.

---

## Token notu

- Denetim ve index tazeleme **tamamen bedava**.
- Sıkıştırma için en fazla **1 agent çağrısı**.
- Bu skill'in kendisi ucuz, kazancı sürekli: sıkıştırılmış `CONTEXT.md`
  her agent çağrısında tasarruf sağlar.
- Sprint sonlarında rutin olarak çalıştır.
