---
name: help
description: App Studio komut listesini faza göre gruplu şekilde gösterir. Argüman verilirse o komutun ne yaptığını açıklar.
---

# /help

## Argümansız kullanım

`.state/project.json` varsa mevcut fazı oku ve **o fazın komutlarını başa al**,
diğerlerini kısalt. Yoksa tamamını göster.

```
# Claude Code App Studio — Komutlar

## Başlangıç
/start                    Durum tespiti + sonraki adım
/kickoff "<fikir>"        Yeni proje başlat (CEO + PO)
/onboard                  Mevcut kod tabanını sisteme al
/status                   Proje durum panosu

## Faz 1 — Keşif & Gereksinim
/discovery                PO + BA round-table: problem, persona, kapsam
/roundtable "<konu>"      Çok rollü tartışma + karar
/prd                      Ürün gereksinim dokümanı
/requirements             FRD + NFR + veri sözlüğü
/roadmap                  Fazlandırma ve sürüm planı
/estimate                 Efor tahmini
/scope-check              Kapsam kayması kontrolü

## Faz 2 — Mimari & Tasarım
/architecture             Mimari + teknoloji yığını
/adr "<konu>"             Mimari karar kaydı
/api-contract             OpenAPI sözleşmesi
/data-model               ER + şema + migration planı
/ux-flow                  Persona, akış, wireframe
/design-system            Token + komponent kataloğu
/threat-model             Güvenlik tehdit modeli

## Faz 3 — Planlama & Geliştirme
/epics                    Epic kırılımı
/stories <epic>           Story üretimi (görev paketi)
/sprint-plan              Sprint + görev dağılımı
/assign <story>           Story'yi doğru agent'a yönlendir
/dev-task <story>         Story'yi implement et
/team-feature <epic>      Uçtan uca dikey dilim, çok agent
/handoff                  Agent'lar arası devir paketi

## Faz 4 — Kalite
/code-review [kapsam]     Bağımsız kod incelemesi
/test-plan                Test planı ve kapsam
/qa-run [kapsam]          Testleri çalıştır ve raporla
/bug "<açıklama>"         Hata kaydı + triage
/security-review          OWASP + tehdit doğrulaması
/perf-check               Performans bütçeleri
/dod-check <story>        "Bitti" kapısı

## Faz 5 — Yayın
/release <sürüm>          Sürüm planı + go/no-go
/changelog                Değişiklik günlüğü
/hotfix "<sorun>"         Acil düzeltme hattı
/retro                    Retrospektif

## Yardımcı
/context-compact          Dokümanları sıkıştır, token tasarrufu
```

## Argümanlı kullanım — `/help <komut>`

`.claude/skills/<komut>/SKILL.md` dosyasını oku ve şu özeti ver:

```
/<komut>
Ne yapar: <1-2 cümle>
Sahibi: <agent>
Girdi: <ne gerekir>
Çıktı: <hangi dosyalar>
Öncesi: <hangi komut çalışmış olmalı>
Sonrası: <mantıklı bir sonraki komut>
```

## Ek bilgi

Kullanıcı sistemi anlamak isterse şu dosyalara yönlendir:

| Soru | Dosya |
|---|---|
| Roller ve yetkileri | `.claude/docs/agent-roster.md` |
| Kim kime rapor verir | `.claude/docs/coordination-rules.md` |
| Token maliyetini nasıl düşürürüm | `.claude/docs/token-budget.md` |
| "Bitti" ne demek | `.claude/docs/definition-of-done.md` |
| Kalite kapıları | `.claude/docs/gates.md` |
| Dosya nerede durur | `.claude/docs/context-protocol.md` |
