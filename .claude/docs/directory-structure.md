# Dizin Yapısı

```
.
├── CLAUDE.md                    Sistem anayasası (her oturumda yüklenir — kısa tut)
├── README.md                    İnsan için giriş
│
├── .claude/
│   ├── settings.json            Model, izinler, hook'lar
│   ├── agents/*.md              19 rol tanımı
│   ├── skills/*/SKILL.md        Slash komutları (iş akışları)
│   ├── rules/*.md               Yol-kapsamlı kodlama kuralları
│   ├── hooks/*.ps1|sh           Otomatik denetimler
│   ├── templates/*.md           Doküman şablonları
│   └── docs/*.md                Bu dosya dahil sistem dokümanları
│
├── product/                     ÜRÜN KATMANI (iş dili)
│   ├── 00-brief.md              İş özeti, hedefler (GOAL-*), başarı metrikleri
│   ├── vision.md                Uzun vadeli ürün vizyonu
│   ├── review-mode.txt          full | lean | solo
│   ├── risks.md                 Risk kaydı
│   ├── prd/PRD.md               Ürün gereksinim dokümanı
│   ├── requirements/
│   │   ├── FRD.md               Fonksiyonel gereksinimler (REQ-*)
│   │   ├── NFR.md               Fonksiyonel olmayan gereksinimler (NFR-*)
│   │   └── data-dictionary.md   İş terimleri ve veri tanımları
│   ├── roadmap/
│   │   ├── ROADMAP.md           Fazlar, sürümler, kilometre taşları
│   │   └── phases/phase-N.md    Faz detayı ve çıkış kriterleri
│   ├── backlog/
│   │   ├── index.md             Tüm epic'lerin tablosu
│   │   └── epics/<slug>/
│   │       ├── EPIC.md
│   │       └── story-NNN-<slug>.md
│   └── sprints/
│       ├── index.md
│       └── sprint-NN.md         Sprint hedefi, görev dağılımı, kapasite
│
├── docs/                        TEKNİK KATMAN
│   ├── CONTEXT.md               ★ Proje beyni — her agent ilk bunu okur (≤200 satır)
│   ├── DECISIONS.md             Karar günlüğü (append-only)
│   ├── architecture/
│   │   ├── ARCHITECTURE.md      Bileşenler, sınırlar, veri akışı, dağıtım topolojisi
│   │   ├── TECH-STRATEGY.md     CTO'nun teknoloji duruşu
│   │   └── adr/
│   │       ├── index.md
│   │       └── ADR-NNNN-<slug>.md
│   ├── api/
│   │   ├── openapi.yaml         ★ API tek gerçek kaynağı
│   │   └── events.md            Asenkron mesaj/event sözleşmeleri
│   ├── data/
│   │   ├── ER.md                Varlık-ilişki modeli
│   │   └── migrations.md        Migration stratejisi ve sırası
│   ├── design/
│   │   ├── ux/                  Persona, akış, IA, wireframe
│   │   └── system/              Design token, komponent spesifikasyonları
│   ├── qa/
│   │   ├── strategy.md          Test stratejisi ve piramidi
│   │   ├── test-plan.md         Sürüm bazlı test planı
│   │   ├── test-cases/          Senaryolar (Given/When/Then)
│   │   ├── evidence/            Manuel doğrulama kanıtları
│   │   ├── performance/         Yük testi sonuçları ve bütçeler
│   │   └── bugs/BUG-NNN.md      Hata kayıtları
│   ├── security/
│   │   ├── threat-model.md      STRIDE tehdit modeli
│   │   └── checklist.md         OWASP kontrol listesi sonuçları
│   ├── ops/
│   │   ├── environments.md      Ortamlar, değişkenler, erişim
│   │   ├── runbook.md           Operasyon prosedürleri, olay müdahalesi
│   │   └── release-NNN.md       Sürüm planı ve rollback
│   └── guides/                  Kullanıcı ve geliştirici kılavuzları
│
├── src/                         KAYNAK KOD
│   ├── frontend/
│   ├── backend/
│   ├── shared/                  Ortak tipler, kontrat türevleri
│   └── data/                    ETL / analitik işleri
│
├── db/
│   ├── schema.sql               ★ Şema tek gerçek kaynağı
│   ├── migrations/NNNN_*.sql
│   └── seeds/
│
├── tests/
│   ├── unit/  integration/  e2e/  performance/
│
├── infra/                       IaC, container, pipeline tanımları
│
└── .state/
    ├── project.json             Faz, sprint, aktif roller, sayaçlar
    ├── gates.jsonl              Kapı geçmişi (append-only)
    └── agent-log.jsonl          Agent çağrı kaydı (token analizi için)
```

★ işaretli dosyalar **tek gerçek kaynağıdır** — kopyalanmaz, referans verilir.

---

## Adlandırma kuralları

| Öğe | Format | Örnek |
|---|---|---|
| İş hedefi | `GOAL-NN` | `GOAL-01` |
| Fonksiyonel gereksinim | `REQ-<alan>-NNN` | `REQ-AUTH-003` |
| NFR | `NFR-<kategori>-NN` | `NFR-PERF-02` |
| Mimari karar | `ADR-NNNN-<slug>.md` | `ADR-0007-event-bus.md` |
| Epic dizini | `<kebab-slug>/` | `user-management/` |
| Story | `story-NNN-<kebab-slug>.md` | `story-004-password-reset.md` |
| Sprint | `sprint-NN.md` | `sprint-03.md` |
| Hata | `BUG-NNN.md` | `BUG-021.md` |
| Test senaryosu | `TC-<REQ-ID>-NN` | `TC-AUTH-003-01` |
| Migration | `NNNN_<snake_name>.sql` | `0012_add_user_roles.sql` |

---

## `.state/project.json` şeması

```json
{
  "project": "<ad>",
  "phase": "discovery|design|build|hardening|release|operate",
  "reviewMode": "lean",
  "scale": "prototype|standard|enterprise",
  "activeRoles": ["product-owner", "solution-architect", "..."],
  "currentSprint": 3,
  "openGateConditions": 0,
  "stack": { "frontend": "", "backend": "", "db": "", "infra": "" },
  "counters": { "epics": 4, "stories": 27, "done": 12, "bugs": 3 },
  "lastUpdated": "YYYY-MM-DD"
}
```
