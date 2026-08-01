# Bağlam Protokolü — Tek Gerçek Kaynağı (SSoT) Haritası

Her bilgi **tek bir dosyada** yaşar. Aşağıdaki tablo, hangi bilginin nerede
tutulduğunu ve kimin yazma yetkisi olduğunu tanımlar. Bir agent bilgiyi
başka yerde tekrarlarsa bu bir **hatadır**.

---

## SSoT tablosu

| Bilgi | Dosya | Sahibi | Okuyanlar |
|---|---|---|---|
| İş hedefi, başarı metriği | `product/00-brief.md` | `ceo` | herkes |
| Ürün kapsamı, özellik listesi, öncelik | `product/prd/PRD.md` | `product-owner` | herkes |
| Fonksiyonel gereksinimler (`REQ-*`) | `product/requirements/FRD.md` | `business-analyst` | tasarım, geliştirme, QA |
| Fonksiyonel olmayan gereksinimler (`NFR-*`) | `product/requirements/NFR.md` | `business-analyst` | mimari, DevOps, QA |
| Veri sözlüğü / iş terimleri | `product/requirements/data-dictionary.md` | `business-analyst` | `sql-developer`, backend |
| Faz/sürüm planı | `product/roadmap/ROADMAP.md` | `product-owner` | herkes |
| Sprint içeriği ve görev dağılımı | `product/sprints/sprint-NN.md` | `delivery-manager` | herkes |
| Risk kaydı | `product/risks.md` | `delivery-manager` | yönetim |
| Sistem mimarisi | `docs/architecture/ARCHITECTURE.md` | `solution-architect` | geliştirme, QA |
| Mimari kararlar (`ADR-*`) | `docs/architecture/adr/` | `solution-architect` (onay: `cto`) | geliştirme |
| API sözleşmesi | `docs/api/openapi.yaml` | `solution-architect` | FE, BE, QA |
| Veritabanı şeması | `db/schema.sql` + `docs/data/ER.md` | `sql-developer` | BE, data |
| Kullanıcı akışları, IA | `docs/design/ux/` | `ux-designer` | FE, PO, QA |
| Design token & komponentler | `docs/design/system/` | `ui-designer` | FE |
| Test stratejisi | `docs/qa/strategy.md` | `qa-lead` | QA, geliştirme |
| Test senaryoları | `docs/qa/test-cases/` | `test-engineer` | geliştirme |
| Hata kayıtları | `docs/qa/bugs/` | `test-engineer` | geliştirme, PO |
| Tehdit modeli | `docs/security/threat-model.md` | `security-engineer` | mimari, BE |
| Ortamlar & CI/CD | `docs/ops/` + `infra/` | `devops-engineer` | herkes |
| Karar günlüğü | `docs/DECISIONS.md` | ekleme: herkes | herkes |
| Proje özeti (beyin) | `docs/CONTEXT.md` | `delivery-manager` | **herkes, ilk okunan** |
| Makine durumu | `.state/project.json` | `delivery-manager` | skill'ler |

---

## Okuma haritası — hangi rol neyi okur

Bir agent **sadece** kendi satırındaki dosyaları açar. Fazlası bütçe ihlalidir.

```
ceo                  → CONTEXT.md, 00-brief.md, ROADMAP.md, risks.md
cto                  → CONTEXT.md, ARCHITECTURE.md, adr/index.md, NFR.md
product-owner        → CONTEXT.md, 00-brief.md, PRD.md, FRD.md, ROADMAP.md, backlog/
business-analyst     → CONTEXT.md, PRD.md, FRD.md, NFR.md, data-dictionary.md, ux/
solution-architect   → CONTEXT.md, FRD.md, NFR.md, ARCHITECTURE.md, adr/, openapi.yaml, ER.md
delivery-manager     → CONTEXT.md, ROADMAP.md, backlog/index.md, sprints/, risks.md, project.json
ux-designer          → CONTEXT.md, PRD.md, FRD.md (ilgili REQ), ux/, system/
ui-designer          → CONTEXT.md, ux/, system/
frontend-developer   → story dosyası, openapi.yaml, system/, ux/ (ilgili akış), src/frontend
backend-developer    → story dosyası, openapi.yaml, ER.md, ilgili ADR, src/backend
sql-developer        → story dosyası, ER.md, schema.sql, data-dictionary.md, db/
data-engineer        → story dosyası, ER.md, docs/data/, src/data
devops-engineer      → story dosyası, NFR.md, ARCHITECTURE.md, infra/, docs/ops/
qa-lead              → CONTEXT.md, FRD.md, NFR.md, strategy.md, backlog/index.md
test-engineer        → story dosyası, FRD.md (ilgili REQ), test-cases/, tests/
code-reviewer        → diff, ilgili story, ilgili rules dosyası
security-engineer    → threat-model.md, ARCHITECTURE.md, openapi.yaml, ilgili src
performance-engineer → NFR.md, ARCHITECTURE.md, performance/, ilgili src
tech-writer          → CONTEXT.md, PRD.md, openapi.yaml, CHANGELOG.md
```

---

## `docs/CONTEXT.md` şablonu

Bu dosya **her agent'ın ilk okuduğu** dosyadır ve 200 satırı geçemez.

```markdown
# Proje Bağlamı

**Proje:** <ad> — <tek cümlelik tanım>
**Kullanıcı:** <birincil persona>
**Aşama:** <discovery | design | build | hardening | release | operate>
**Sürüm hedefi:** <vX.Y — tarih>
**İnceleme modu:** <full | lean | solo>

## Ne inşa ediyoruz
<3-5 madde, kullanıcı değeri odaklı>

## Kapsam dışı (bilinçli)
<3-5 madde>

## Teknoloji yığını
| Katman | Seçim | ADR |
|---|---|---|

## Kritik NFR'ler
<en fazla 5 satır — performans, güvenlik, ölçek hedefleri>

## Aktif roller
<kadro listesi>

## Şu an ne yapılıyor
**Sprint:** <NN> — <hedef>
**Devam eden:** <story listesi, sahipleriyle>
**Bloke:** <varsa>

## Bilinen borç ve riskler
<en fazla 5 satır>
```

---

## Devir (handoff) paketi

Bir agent işi diğerine devrederken `/handoff` kullanılır. Paket şu formattadır
ve **200 kelimeyi geçmez**:

```
DEVREDEN: <rol>   ALAN: <rol>   İŞ: <story-id>
YAPILDI: <maddeler>
KALAN: <maddeler>
KARARLAR: <alınan kararlar, gerekçesiyle>
DİKKAT: <tuzaklar, varsayımlar>
DOSYALAR: <dokunulan yollar>
DOĞRULAMA: <alan kişinin çalıştıracağı komut>
```

---

## Çakışma çözümü

İki agent aynı dosyayı değiştirmek isterse:

1. Dosyanın **sahibi** tabloya bakılarak belirlenir.
2. Sahip olmayan agent değişikliği **öneri** olarak sunar, kendisi yazmaz.
3. Sahip agent kabul ederse yazar; reddederse gerekçe `docs/DECISIONS.md`'ye eklenir.
4. Anlaşmazlık sürerse yetki matrisindeki bir üst role escalate edilir.
