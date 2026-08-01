# Claude Code App Studio

Bu depo, uygulama (web / mobil / API / kurumsal yazılım) projelerini **uçtan uca**
yürüten sanal bir yazılım şirketidir. Roller gerçek bir yazılım şirketinin
organizasyon şemasını taklit eder; her rol bir **agent**, her iş akışı bir
**skill** (slash komut) olarak tanımlıdır.

> **Bu bir otopilot değildir.** Agent'lar soru sorar, seçenekleri trade-off'larıyla
> sunar, taslak gösterir ve **yazmadan önce onay ister**. Nihai kararlar kullanıcıya
> aittir.

---

## Başlarken

| Durum | Komut |
|---|---|
| Yeni proje | `/kickoff "<proje fikrin>"` |
| Mevcut kod tabanı var | `/onboard` |
| Nerede kaldım? | `/status` |
| Komut listesi | `/help` |

Tipik akış:

```
/kickoff → /discovery → /prd → /requirements → /roadmap
        → /architecture → /ux-flow → /design-system
        → /epics → /stories → /sprint-plan
        → /dev-task (döngü) → /code-review → /qa-run → /dod-check
        → /release → /retro
```

---

## Anayasa (tüm agent'lar için bağlayıcı)

1. **Tek gerçek kaynağı (SSoT) vardır.** Bir bilgi tek bir dosyada yaşar; diğerleri
   ona referans verir. Kopyalama yasaktır. Bkz. `.claude/docs/context-protocol.md`.
2. **Önce oku, sonra yaz.** Dosya yazmadan önce ilgili SSoT dosyaları okunur.
   Okuma bütçesi aşılamaz (bkz. `.claude/docs/token-budget.md`).
3. **İzlenebilirlik zorunludur.** Her story bir gereksinime (`REQ-*`), her gereksinim
   bir hedefe (`GOAL-*`), her teknik seçim bir ADR'ye bağlanır. Bağı olmayan iş yapılmaz.
4. **Kapsam dışına çıkma.** Agent kendi alanının dışında karar vermez; ilgili role
   *escalate* eder. Bkz. `.claude/docs/coordination-rules.md`.
5. **Yazmadan önce onay.** Dosya oluşturma/değiştirme öncesi `AskUserQuestion` ile
   özet + onay. İstisna: `/dev-task` içinde onaylanmış story kapsamındaki kod.
6. **Kanıtsız "bitti" yoktur.** Bkz. `.claude/docs/definition-of-done.md`.
7. **Token disiplini.** Tam dosya okumak yerine `Grep`/`Glob` ile hedefli oku;
   alt-agent'lar özet döner, transkript dönmez.

---

## Kalıcı proje hafızası

Bu üç dosya her oturumda güncel tutulur ve agent'ların **ilk okuduğu** yerdir:

| Dosya | İçerik | Boyut limiti |
|---|---|---|
| `docs/CONTEXT.md` | Projenin 1 sayfalık beyni: ne, kim için, stack, mevcut faz | 200 satır |
| `.state/project.json` | Makine-okunur durum: faz, aktif sprint, açık kapılar | — |
| `docs/DECISIONS.md` | Karar günlüğü (tek satırlık kayıtlar, ADR'lere link) | 300 satır |

Bu dosyalar şişerse `/context-compact` çalıştırılır.

---

## Dizin yapısı

```
product/     Ürün katmanı — brief, PRD, gereksinimler, roadmap, backlog, sprintler
docs/        Teknik katman — mimari, ADR, API, veri modeli, tasarım, QA, ops
src/         Uygulama kaynak kodu
tests/       Test kodu (unit / integration / e2e)
infra/       IaC, CI/CD, ortam tanımları
.state/      Proje durum makinesi (JSON)
.claude/     Agent'lar, skill'ler, kurallar, kapılar, şablonlar
```

Ayrıntı: `.claude/docs/directory-structure.md`

---

## Roller

**Yönetim** — `ceo`, `cto`
**Ürün & Planlama** — `product-owner`, `business-analyst`, `solution-architect`, `delivery-manager`
**Tasarım** — `ux-designer`, `ui-designer`
**Geliştirme** — `frontend-developer`, `backend-developer`, `sql-developer`, `data-engineer`, `devops-engineer`
**Kalite** — `qa-lead`, `test-engineer`, `code-reviewer`, `security-engineer`, `performance-engineer`
**Destek** — `tech-writer`

Tam liste, model atamaları ve yetki sınırları: `.claude/docs/agent-roster.md`

---

## Kalite kapıları ve inceleme modu

Her fazın çıkışında bir **kapı (gate)** vardır — ilgili yönetici agent `ONAY` /
`ŞARTLI` / `RET` verdiktiyle yanıtlar. Kapı yoğunluğu `product/review-mode.txt`
ile ayarlanır:

| Mod | Davranış | Token maliyeti |
|---|---|---|
| `full` | Tüm kapılar çalışır (kurumsal / regüle projeler) | Yüksek |
| `lean` | Sadece faz geçiş kapıları çalışır — **varsayılan** | Orta |
| `solo` | Kapı yok, tek geliştirici modu | Düşük |

Ayrıntı: `.claude/docs/gates.md`

---

## Yasaklar

- Kullanıcı onayı olmadan `git push`, deploy, migration çalıştırma
- `.env`, secret, credential dosyalarına yazma veya içeriğini ekrana basma
- Gereksinim veya ADR icat etme — kaynak yoksa **sor**
- Onaylanmamış teknoloji/kütüphane ekleme (ADR gerektirir)
- Bir agent'ın başka bir agent'ın çıktısını sessizce ezmesi (`/handoff` kullanılır)
