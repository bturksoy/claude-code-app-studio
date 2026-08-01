---
name: prd
description: Ürün Gereksinim Dokümanını (PRD) üretir. Keşif çıktısını yapılandırılmış, önceliklendirilmiş ve ölçülebilir bir ürün tanımına dönüştürür. PO-SCOPE kapısını işletir.
---

# /prd

Sahip: `product-owner`. Çıktı: `product/prd/PRD.md`.

Ön koşul: `product/discovery.md` (yoksa `/discovery` öner ve dur).
Bloke edici açık soru varsa önce onları çöz.

---

## 1. Girdi hazırla

`product/00-brief.md` + `product/discovery.md` oku. Bağlam bloğu (≤ 60 satır):
hedefler, personalar, yetenek listesi (MoSCoW), alınan kararlar, kapsam dışı.

## 2. `product-owner` çağır

```
<BAĞLAM BLOĞU>

Görev: PRD üret. Bölümler:

1. Özet — 3 cümle: ne, kim için, neden şimdi
2. Hedefler ve metrikler — GOAL tablosu, her birine ürün içi ölçüm olayı bağla
3. Personalar — keşiften, kısaltılmış
4. Kapsam
   4.1 Yetenekler: her biri FEAT-NN kimliği alır
       | ID | Yetenek | Kullanıcı değeri | Öncelik | GOAL | Faz |
   4.2 Kullanıcı yolculukları: her persona için uçtan uca 1 senaryo
   4.3 Kapsam dışı: madde + neden + ne zaman tekrar bakılacak
5. Varsayımlar ve bağımlılıklar
6. Kısıtlar (teknik, yasal, ticari, takvim)
7. Riskler — olasılık/etki/önlem
8. Açık sorular — sahip ve bloke edici mi

Kurallar:
- Her "Olmalı" yeteneği bir GOAL'a bağlı olmalı. Bağlanamıyorsa öncelik düşür.
- Teknik çözüm yazma (hangi veritabanı, hangi framework) — bu mimarinin işi.
- Ekran tasarlama — bu UX'in işi.
- Her yeteneği tek cümlede kullanıcı değeriyle ifade et.
- Fazlandırma taslağı ver ama detayı /roadmap'e bırak.

Sonra yanıtına "PO-SCOPE: ONAY|ŞARTLI|RET" satırıyla başla ve şunu değerlendir:
- MVP kapsamı tek ekibin makul sürede bitirebileceği büyüklükte mi?
- "Olmayacak" listesi dolu mu?
- Metrikler ölçülebilir mi?
- En riskli varsayım ilk fazda test ediliyor mu?
```

## 3. Kapı işleme

`product/review-mode.txt` oku:
- `solo` → PO-SCOPE atla, not düş
- `lean` / `full` → verdikti işle

| Verdikt | Aksiyon |
|---|---|
| `ONAY` | Devam |
| `ŞARTLI` | Maddeleri kullanıcıya göster, düzeltmeleri PRD'ye işle, kapıyı **tekrar çağırma** |
| `RET` | Kullanıcıya nedeni göster, `/discovery` veya kapsam daraltma öner, dur |

## 4. Sun ve onay al

Ekrana **özet** ver (tam PRD'yi basma):

```
## PRD Özeti
Yetenekler: <N> (Olmalı: <a>, Olmalıydı: <b>, Olabilir: <c>, Olmayacak: <d>)

MVP (Faz 1)
  FEAT-01 <ad> → GOAL-01
  ...

Sonraki fazlara ertelenen: <N> yetenek
Açık soru: <N> (<B> bloke edici)
Kapı: PO-SCOPE <verdikt>
```

`AskUserQuestion`: `PRD'yi yaz (Önerilen)` / `Kapsamı daraltacağım` / `Yetenek ekleyeceğim`

## 5. Yaz ve güncelle

- `product/prd/PRD.md`
- `docs/CONTEXT.md` → "Ne inşa ediyoruz" bölümünü PRD özetiyle güncelle
- `.state/project.json` → `phase: "discovery"` kalır, `counters` güncellenmez
- `.state/gates.jsonl` → PO-SCOPE satırı ekle
- Açık sorular `product/discovery.md`'deki tabloya senkronlanır (tek yerde yaşasın)

## 6. Kapat

```
✓ PRD yazıldı → product/prd/PRD.md
  <N> yetenek | MVP: <M> yetenek | Kapı: PO-SCOPE <verdikt>

▶ Sonraki: /requirements
   Business Analyst her yeteneği test edilebilir gereksinime çevirecek.
```

---

## Token notu

- **1 agent çağrısı.** PO hem PRD'yi yazar hem kapıyı verir (ayrı çağrı yapma).
- Bağlam bloğu ≤ 60 satır; discovery.md'nin tamamını gömme.
- PRD'yi ekrana basma — dosyaya yaz, özet göster.
