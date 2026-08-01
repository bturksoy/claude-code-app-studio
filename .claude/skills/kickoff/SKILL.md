---
name: kickoff
description: Yeni projeyi başlatır. Proje fikrini alır, CEO ile iş hedeflerini ve başarı metriklerini netleştirir, proje ölçeğine göre agent kadrosunu ve inceleme modunu belirler, dizin yapısını ve durum dosyalarını kurar.
---

# /kickoff "<proje fikri>"

Faz 0. Çıktı: `product/00-brief.md`, `.state/project.json`, `docs/CONTEXT.md` iskeleti,
dizin yapısı ve seçilmiş kadro.

---

## 1. Girdiyi al

Argüman yoksa sor: *"Ne inşa etmek istiyorsun? Tek cümle yeterli."*

Argümanı **olduğu gibi** sakla — yorumlama, genişletme.

## 2. Netleştirme turu (agent çağırmadan, ucuz)

`AskUserQuestion` ile **tek seferde 4 soru** sor. Bunlar kadro ve mod seçimini belirler:

**Soru 1 — Proje tipi**
`Web uygulaması` / `Mobil uygulama` / `API / Backend servis` / `Masaüstü veya CLI`

**Soru 2 — Ölçek ve ciddiyet**
- `Prototip` — fikri test etmek, hızlı, tek kişilik
- `Standart ürün (Önerilen)` — gerçek kullanıcılar, bakımı yapılacak
- `Kurumsal / regüle` — uyumluluk, denetim, çok ekipli

**Soru 3 — Kullanıcı kim**
- `Kendim / iç ekip` / `Küçük işletmeler` / `Genel tüketici` / `Başka bir yazılım (API tüketicisi)`

**Soru 4 — En kritik kısıt**
- `Hız — bir an önce çalışsın`
- `Doğruluk — hata kabul edilemez (para/sağlık/hukuk)`
- `Ölçek — çok kullanıcı olacak`
- `Maliyet — işletme gideri düşük olmalı`

## 3. Ölçeğe göre kadro ve mod belirle

| Ölçek | Mod | Aktif roller |
|---|---|---|
| Prototip | `solo` | product-owner, solution-architect, backend-developer, frontend-developer, test-engineer |
| Standart | `lean` | + business-analyst, ux-designer, ui-designer, sql-developer, devops-engineer, qa-lead, code-reviewer, delivery-manager |
| Kurumsal | `full` | Tam kadro (19) |

4. sorunun cevabı kadroyu ayarlar:
- `Doğruluk` → `security-engineer` + `qa-lead` her ölçekte aktif
- `Ölçek` → `performance-engineer` + `devops-engineer` aktif
- `Maliyet` → `devops-engineer` aktif, `cto` maliyet kısıtını TECH-STRATEGY'ye yazar

Seçimi kullanıcıya **göster ve onayla**:
```
Kadro: <liste>
Mod: <mod> — <ne anlama geldiği tek cümle>
Devre dışı: <liste> — <neden>
Bunlar sonradan değiştirilebilir (product/review-mode.txt).
```

## 4. CEO ile iş çerçevesi

`ceo` agent'ını çağır. Prompt'a **göm** (dosya okutma):

```
Proje fikri: <argüman>
Tip: <cevap 1> | Ölçek: <cevap 2> | Kullanıcı: <cevap 3> | Kısıt: <cevap 4>

Görev:
1. En fazla 3 ölçülebilir iş hedefi (GOAL-01..03) öner. Her biri için:
   hedef değer, ölçüm yöntemi, ölçüm zamanı.
2. MVP'de OLMAYACAKLAR listesi çıkar (en az 5 madde) — bu, kapsamı korur.
3. En riskli 3 varsayımı ve her birinin nasıl test edileceğini yaz.
4. Bu projenin başarısız olma senaryosunu tek paragrafta yaz.

Kısa yaz. Yanıtına "CEO-VISION: ONAY|ŞARTLI|RET" satırıyla başla.
Belirsizlik varsa varsayım yapma — "SORU:" satırı aç.
```

CEO'nun `SORU:` satırları varsa `AskUserQuestion` ile kullanıcıya sor,
cevapları alıp CEO'ya **tek seferde** geri gönder (ikinci tur, en fazla bir kez).

## 5. Brief'i sun ve onay al

Yazmadan önce özet göster:

```
## <Proje adı>
<tek cümlelik tanım>

Hedefler
  GOAL-01: <ölçülebilir hedef>
  GOAL-02: ...

MVP'de olmayacak
  - <madde>

Riskli varsayımlar
  - <varsayım> → <nasıl test edilir>

Kadro: <liste>  |  Mod: <mod>
```

`AskUserQuestion`:
- `Onayla ve kur (Önerilen)`
- `Hedefleri değiştireceğim`
- `Kadroyu/modu değiştireceğim`

## 6. Dosyaları oluştur

Onay sonrası:

**Dizinler** (boş dizinlere `.gitkeep`):
```
product/{prd,requirements,roadmap/phases,backlog/epics,sprints}
docs/{architecture/adr,api,data,design/{ux/flows,ux/wireframes,system/components},qa/{test-cases,evidence,performance,bugs},security,ops,guides}
src tests/{unit,integration,e2e,performance} db/{migrations,seeds} infra .state
```

**`product/00-brief.md`**
```markdown
# <Proje> — İş Özeti
**Tarih:** <bugün> | **Ölçek:** <ölçek> | **Tip:** <tip>

## Tek cümlede
<tanım>

## Problem
<CEO çıktısından>

## Hedef kullanıcı
<cevap 3 + detay>

## İş hedefleri
| ID | Hedef | Hedef değer | Ölçüm | Ne zaman |
|---|---|---|---|---|
| GOAL-01 | | | | |

## MVP'de olmayacaklar
- <madde> — <neden>

## Riskli varsayımlar
| # | Varsayım | Nasıl test edilir | Yanlışsa ne olur |

## Kısıtlar
<kritik kısıt + varsa bütçe/takvim/teknoloji kısıtı>

## Başarısızlık senaryosu
<CEO'nun yazdığı paragraf>
```

**`product/review-mode.txt`** → tek satır: `<mod>`

**`.state/project.json`**
```json
{
  "project": "<ad>",
  "phase": "discovery",
  "reviewMode": "<mod>",
  "scale": "<ölçek>",
  "activeRoles": [...],
  "currentSprint": null,
  "openGateConditions": 0,
  "stack": {},
  "counters": {"epics":0,"stories":0,"done":0,"bugs":0},
  "lastUpdated": "<bugün>"
}
```

**`docs/CONTEXT.md`** — `.claude/docs/context-protocol.md`'deki şablonu doldur
(bilinmeyen alanlar `<henüz belirlenmedi>`).

**`docs/DECISIONS.md`**
```markdown
# Karar Günlüğü
| Tarih | Karar | Veren | Gerekçe | Referans |
|---|---|---|---|---|
| <bugün> | Ölçek=<ölçek>, mod=<mod> | kullanıcı | /kickoff | — |
```

**`product/risks.md`** — CEO'nun riskli varsayımlarını risk kaydına dönüştür.

**`.state/gates.jsonl`** — CEO-VISION verdiktini ilk satır olarak yaz.

## 7. Kapat

```
✓ <Proje> kuruldu.

Hedefler: GOAL-01..NN  |  Kadro: <N> rol  |  Mod: <mod>

▶ Sonraki: /discovery
   Product Owner ve Business Analyst kafa kafaya verip projeyi detaylandıracak.
```

`AskUserQuestion` ile: `Şimdi /discovery çalıştır (Önerilen)` / `Önce brief'i okuyacağım`

---

## Token notu

- Bu skill **tek agent** çağırır (`ceo`), en fazla iki tur.
- Netleştirme soruları agent'a değil kullanıcıya sorulur — bedava.
- Dizin oluşturmayı tek Bash çağrısında yap.
