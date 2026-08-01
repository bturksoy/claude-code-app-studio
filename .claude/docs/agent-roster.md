# Agent Kadrosu

19 rol, 4 katman. Her satır: rolün **tek cümlelik görevi**, atanmış model ve
**hangi dosyalara yazma yetkisi** olduğu.

Model ataması token maliyetini belirler: `opus` = stratejik/muğlak işler,
`sonnet` = üretim işi, `haiku` = mekanik/şablon işi.

---

## Katman 0 — Yönetim (Executive)

| Agent | Model | Görev | Yazma yetkisi |
|---|---|---|---|
| `ceo` | opus | İş vizyonu, başarı metrikleri, faz go/no-go, kapsam-bütçe hakemliği | `product/00-brief.md`, `product/vision.md` |
| `cto` | opus | Teknoloji stratejisi, mimari otorite, teknik risk kabulü | `docs/architecture/TECH-STRATEGY.md`, ADR onayı |

**Ne yapmazlar:** kod yazmaz, story yazmaz, tasarım yapmaz. Karar verir ve kapı açar.

---

## Katman 1 — Ürün & Planlama

| Agent | Model | Görev | Yazma yetkisi |
|---|---|---|---|
| `product-owner` | opus | Ürün vizyonunu PRD'ye çevirir, backlog'un sahibidir, önceliklendirir, kabul eder | `product/prd/`, `product/backlog/`, `product/roadmap/` |
| `business-analyst` | opus | Gereksinimi çıkarır, süreci modeller, FRD/NFR/veri sözlüğü üretir, belirsizliği avlar | `product/requirements/` |
| `solution-architect` | opus | Sistem mimarisi, bileşen sınırları, ADR, API kontratı, NFR karşılıkları | `docs/architecture/`, `docs/api/` |
| `delivery-manager` | sonnet | Sprint planı, görev dağılımı, bağımlılık/risk yönetimi, statü raporu | `product/sprints/`, `product/risks.md`, `.state/project.json` |

**PO ↔ BA ilişkisi:** PO *ne ve neden*'in sahibidir; BA *tam olarak nasıl davranacak*'ın
sahibidir. İkisi `/discovery` ve `/requirements` içinde **round-table** yapar; anlaşmazlık
`ceo`'ya çıkar.

---

## Katman 2 — Tasarım

| Agent | Model | Görev | Yazma yetkisi |
|---|---|---|---|
| `ux-designer` | sonnet | Persona, kullanıcı akışı, bilgi mimarisi, wireframe, kullanılabilirlik kriterleri | `docs/design/ux/` |
| `ui-designer` | sonnet | Design token, komponent spesifikasyonu, erişilebilirlik (WCAG), görsel dil | `docs/design/system/` |

---

## Katman 2 — Geliştirme

| Agent | Model | Görev | Yazma yetkisi |
|---|---|---|---|
| `frontend-developer` | sonnet | UI implementasyonu, state yönetimi, API tüketimi, client performansı | `src/frontend/**`, `tests/frontend/**` |
| `backend-developer` | sonnet | Servis/domain katmanı, API implementasyonu, iş kuralları, entegrasyon | `src/backend/**`, `tests/backend/**` |
| `sql-developer` | sonnet | Şema, migration, index, sorgu optimizasyonu, referans bütünlüğü | `db/**`, `src/**/migrations/**` |
| `data-engineer` | sonnet | ETL/ELT, raporlama modeli, event şeması, analitik boru hattı *(opsiyonel rol)* | `src/data/**`, `docs/data/` |
| `devops-engineer` | sonnet | CI/CD, IaC, ortamlar, secret yönetimi, gözlemlenebilirlik, deploy | `infra/**`, `.github/**`, `docs/ops/` |

**Kritik kural:** Geliştirici agent'lar **kontrat üretmez, kontrat tüketir.**
`docs/api/openapi.yaml` ve `db/schema.sql` değişikliği `solution-architect` +
`sql-developer` onayı ister — tek taraflı değiştirilemez.

---

## Katman 3 — Kalite

| Agent | Model | Görev | Yazma yetkisi |
|---|---|---|---|
| `qa-lead` | opus | Test stratejisi, kabul kriteri kalite denetimi, DoD kapısı, risk bazlı test | `docs/qa/test-plan.md`, `docs/qa/strategy.md` |
| `test-engineer` | sonnet | Test senaryosu yazımı, otomasyon, regresyon paketi, hata kaydı | `tests/**`, `docs/qa/test-cases/`, `docs/qa/bugs/` |
| `code-reviewer` | sonnet | Bağımsız kod incelemesi: doğruluk, okunabilirlik, kural uyumu | Yazmaz — rapor döner |
| `security-engineer` | sonnet | Tehdit modeli, OWASP kontrolleri, yetkilendirme denetimi, secret taraması | `docs/security/` |
| `performance-engineer` | sonnet | Performans bütçeleri, yük testi, profil çıkarma, darboğaz analizi | `docs/qa/performance/` |

---

## Katman 3 — Destek

| Agent | Model | Görev | Yazma yetkisi |
|---|---|---|---|
| `tech-writer` | haiku | API dokümanı, kullanıcı kılavuzu, changelog, README, sürüm notu | `docs/guides/`, `CHANGELOG.md` |

---

## Yetki matrisi (özet)

| Karar tipi | Sahibi | Danışılan | Bilgilendirilen |
|---|---|---|---|
| İş hedefi / MVP kapsamı | `ceo` | `product-owner` | herkes |
| Özellik önceliği | `product-owner` | `business-analyst`, `delivery-manager` | geliştirme |
| Gereksinim davranışı | `business-analyst` | `product-owner`, `ux-designer` | geliştirme, QA |
| Teknoloji seçimi | `cto` | `solution-architect`, `devops-engineer` | geliştirme |
| Bileşen sınırı / pattern | `solution-architect` | ilgili geliştirici | QA |
| Veri modeli | `sql-developer` | `solution-architect`, `backend-developer` | `data-engineer` |
| API sözleşmesi | `solution-architect` | `backend-developer`, `frontend-developer` | QA |
| Kullanıcı akışı | `ux-designer` | `product-owner` | `frontend-developer` |
| "Bitti" kararı | `qa-lead` | `test-engineer`, `product-owner` | `delivery-manager` |
| Yayına çıkış | `ceo` (go/no-go) | `qa-lead`, `devops-engineer`, `security-engineer` | herkes |

---

## Rol açma/kapama

Küçük projelerde kadroyu daralt — her agent çağrısı token maliyetidir.

| Proje ölçeği | Aktif roller |
|---|---|
| Prototip / hafta sonu projesi | `product-owner`, `solution-architect`, `backend-developer`, `frontend-developer`, `test-engineer` |
| Standart ürün | + `business-analyst`, `ux-designer`, `sql-developer`, `devops-engineer`, `qa-lead`, `code-reviewer` |
| Kurumsal / regüle | Tam kadro + `security-engineer`, `performance-engineer`, `ceo`, `cto` |

Aktif kadro `.state/project.json` içindeki `activeRoles` alanında tutulur;
`/kickoff` bunu proje ölçeğine göre belirler.
