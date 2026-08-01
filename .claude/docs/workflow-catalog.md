# İş Akışı Kataloğu

38 skill, 6 faza dağılmış. Her satır: komut, sahibi rol, girdi, çıktı.

---

## Faz 0 — Başlangıç

| Komut | Sahip | Girdi | Çıktı |
|---|---|---|---|
| `/start` | — | — | Proje durumu tespiti + sonraki adım önerisi |
| `/help` | — | — | Komut listesi, faza göre filtreli |
| `/kickoff "<fikir>"` | `ceo` + `product-owner` | Proje fikri | `product/00-brief.md`, `.state/project.json`, kadro seçimi |
| `/onboard` | `solution-architect` | Mevcut kod tabanı | `docs/CONTEXT.md`, `ARCHITECTURE.md` taslağı, borç listesi |

## Faz 1 — Keşif & Gereksinim

| Komut | Sahip | Girdi | Çıktı |
|---|---|---|---|
| `/discovery` | `product-owner` ‖ `business-analyst` | Brief | Problem tanımı, persona, kapsam sınırı, açık sorular |
| `/roundtable "<konu>"` | çağıran | Herhangi bir konu | Çok-mercekli analiz + anlaşmazlık kararları |
| `/prd` | `product-owner` | Discovery çıktısı | `product/prd/PRD.md` |
| `/requirements` | `business-analyst` | PRD | `FRD.md`, `NFR.md`, `data-dictionary.md` |
| `/roadmap` | `product-owner` | PRD + FRD | `ROADMAP.md`, faz dosyaları, MVP sınırı |
| `/estimate` | `delivery-manager` | Epic/story listesi | Efor tahmini + belirsizlik bandı |
| `/scope-check` | `product-owner` | Mevcut backlog | Kapsam kayması raporu + kesme önerileri |

## Faz 2 — Mimari & Tasarım

| Komut | Sahip | Girdi | Çıktı |
|---|---|---|---|
| `/architecture` | `solution-architect` + `cto` | FRD + NFR | `ARCHITECTURE.md`, stack seçimi, ilk ADR'ler |
| `/adr "<konu>"` | `solution-architect` | Teknik soru | `ADR-NNNN-*.md` |
| `/api-contract` | `solution-architect` | FRD + mimari | `docs/api/openapi.yaml` |
| `/data-model` | `sql-developer` | FRD + veri sözlüğü | `docs/data/ER.md`, `db/schema.sql`, migration planı |
| `/ux-flow` | `ux-designer` | PRD + FRD | Persona, akış diyagramları, IA, wireframe spesifikasyonu |
| `/design-system` | `ui-designer` | UX çıktısı | Token seti, komponent kataloğu, erişilebilirlik kuralları |
| `/threat-model` | `security-engineer` | Mimari + API | `docs/security/threat-model.md` |

## Faz 3 — Planlama & Geliştirme

| Komut | Sahip | Girdi | Çıktı |
|---|---|---|---|
| `/epics` | `product-owner` + `solution-architect` | FRD + roadmap fazı | `backlog/epics/*/EPIC.md` |
| `/stories <epic>` | `business-analyst` + `qa-lead` | Epic | Story dosyaları (görev paketi formatında) |
| `/sprint-plan` | `delivery-manager` | Hazır story'ler | `sprint-NN.md` — görev dağılımı, bağımlılık, kapasite |
| `/assign <story>` | `delivery-manager` | Story | Doğru agent'a yönlendirme + hazırlık kontrolü |
| `/dev-task <story>` | ilgili geliştirici | Story dosyası | Kod + testler + story güncellemesi |
| `/team-feature <epic>` | `delivery-manager` | Epic | Uçtan uca dikey dilim, çok agent koordineli |
| `/handoff` | herhangi | Devam eden iş | Devir paketi (≤200 kelime) |

## Faz 4 — Kalite

| Komut | Sahip | Girdi | Çıktı |
|---|---|---|---|
| `/code-review [kapsam]` | `code-reviewer` | Diff / dosyalar | Bulgu listesi + verdikt |
| `/test-plan` | `qa-lead` | FRD + risk | `docs/qa/test-plan.md`, risk bazlı kapsam |
| `/qa-run [kapsam]` | `test-engineer` | Test planı | Test çalıştırma + sonuç raporu + bug kayıtları |
| `/bug "<açıklama>"` | `test-engineer` | Gözlem | `BUG-NNN.md` + triage (öncelik/sahip) |
| `/security-review` | `security-engineer` | Kod + mimari | OWASP bulguları + verdikt |
| `/perf-check` | `performance-engineer` | NFR + kod | Bütçe karşılaştırması + darboğaz analizi |
| `/dod-check <story>` | `qa-lead` | Story + kanıt | DoD kapısı verdikti |

## Faz 5 — Yayın & İşletme

| Komut | Sahip | Girdi | Çıktı |
|---|---|---|---|
| `/release <sürüm>` | `devops-engineer` + `ceo` | Tamamlanan sürüm | Sürüm planı, rollback, go/no-go |
| `/changelog` | `tech-writer` | Story geçmişi | `CHANGELOG.md` girdisi |
| `/hotfix "<sorun>"` | `delivery-manager` | Üretim sorunu | Hızlı yol: analiz → düzeltme → doğrulama → yayın |
| `/retro` | `delivery-manager` | Sprint/sürüm | Retro notu + aksiyon maddeleri |
| `/status` | `delivery-manager` | Proje | Durum panosu + sonraki adım |

## Yardımcı

| Komut | Sahip | Amaç |
|---|---|---|
| `/context-compact` | `delivery-manager` | Şişmiş dokümanları sıkıştır, index'leri tazele |

---

## Faz geçiş kuralları

Bir faz, çıkış kapısı `ONAY` almadan sonrakine geçmez. `/status` hangi kapının
açık olduğunu söyler.

```
Faz 0 → 1 : CEO-VISION
Faz 1 → 2 : PO-SCOPE + BA-REQ
Faz 2 → 3 : CTO-STACK + ARCH-DESIGN
Faz 3 → 4 : DM-PLAN (sprint bazlı)
Faz 4 → 5 : QA-DONE (sürüm kapsamındaki tüm story'ler)
Faz 5     : OPS-READY + CEO-GONOGO
```

Faz atlanabilir mi? Evet — `scale=prototype` ise `/kickoff` şu kısayolu önerir:

```
/kickoff → /prd → /architecture → /epics → /stories → /dev-task → /qa-run → /release
```

`business-analyst`, `ux-designer`, `security-engineer`, `performance-engineer`
devre dışı kalır. Bu, token maliyetini yaklaşık %60 düşürür.
