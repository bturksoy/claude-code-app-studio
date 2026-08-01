---
name: onboard
description: Mevcut bir kod tabanını App Studio sistemine alır. Kodu analiz edip CONTEXT.md, mimari taslağı, teknik borç listesi ve geriye dönük gereksinim taslağı üretir. Brownfield projeler için giriş noktası.
---

# /onboard

Sahip: `solution-architect`. Çıktı: `docs/CONTEXT.md`, `ARCHITECTURE.md` taslağı,
teknik borç listesi, `.state/project.json`.

---

## 1. Hızlı keşif (bedava — agent'ın arama yapmasını önler)

Glob ve Grep ile şunları topla (dosya içeriği okuma, sadece varlık ve yapı):

```
Dil/yığın işaretleri : package.json, requirements.txt, *.csproj, go.mod, pom.xml,
                       Gemfile, composer.json, Cargo.toml
Yapı                 : üst seviye dizinler (2 seviye derinlik)
Giriş noktaları      : main.*, index.*, app.*, Program.cs, server.*
Yapılandırma         : *.config.*, .env.example, appsettings*.json
Test                 : test/ spec/ __tests__/ — dosya sayısı
Veritabanı           : migrations/, schema.sql, models/, entities/
CI/CD                : .github/workflows/, .gitlab-ci.yml, Jenkinsfile, Dockerfile
Dokümantasyon        : README, docs/, ADR izleri
Bağımlılık sayısı    : manifest dosyasından
Kod hacmi            : dosya sayısı ve yaklaşık satır (Glob sayımı)
```

Git varsa: `git log --oneline -20`, katkıda bulunan sayısı, son commit tarihi.

## 2. `solution-architect` çağır

```
KEŞİF ÇIKTISI:
<yukarıda toplanan yapılandırılmış bilgi>

ANA DOSYA İÇERİKLERİ:
<package.json / manifest dosyası — tam>
<giriş noktası dosyası — tam>
<README — varsa, tam>
<varsa migration/schema dosya adları>

Görev: Bu kod tabanını haritalandır.

1. Yığın tespiti: dil, framework, veritabanı, altyapı — sürümleriyle
2. Mimari desen: katmanlı mı, modüler mi, monolit mi, mikroservis mi
   Bağımlılık yönü kuralı var mı, uygulanıyor mu
3. Bileşen haritası: ana modüller ve sorumlulukları (C4-2 seviyesi)
4. Veri modeli: hangi varlıklar var (dosya/klasör adlarından çıkarım)
5. Test durumu: hangi seviyeler var, kaba kapsam tahmini
6. Teknik borç sinyalleri:
   - Eski/bakımsız bağımlılıklar
   - Test boşlukları
   - Yapılandırma/secret yönetimi sorunları
   - Mimari tutarsızlıklar
   - Eksik dokümantasyon
7. Bilinmeyenler: koddan çıkaramadığın, kullanıcıya sorulması gerekenler

Kural: Emin olmadığın şeyi "TAHMİN:" olarak işaretle.
Ek dosya okuman gerekiyorsa hangi dosya olduğunu SÖYLE, listele — kendin
geniş tarama yapma.
```

Agent belirli dosyalar isterse **onları oku ve tek bir ikinci turda** gönder.
En fazla bir ek tur.

## 3. Kullanıcıya sorular

Agent'ın "Bilinmeyenler" listesinden `AskUserQuestion` ile sor (en fazla 4):
- Bu projenin amacı / kullanıcısı kim?
- Hangi aşamada (üretimde mi, geliştirme mi)?
- Bilinen en büyük sorun ne?
- App Studio'yu ne için kullanmak istiyorsun: `Yeni özellik ekleme` /
  `Refactor / borç ödeme` / `Dokümantasyon çıkarma` / `Kalite artırma`

## 4. Sun

```
## Kod Tabanı Analizi

Yığın: <dil> <framework> | <veritabanı> | <altyapı>
Hacim: ~<N> dosya, <M> bağımlılık
Mimari: <desen> — <tutarlılık değerlendirmesi>

Bileşenler
| Modül | Sorumluluk | Durum |

Test: <seviyeler> — kaba kapsam <tahmin>
CI/CD: <var/yok — ne yapıyor>

Teknik borç (öncelik sırasıyla)
| # | Borç | Etki | Tahmini maliyet |

Bilinmeyenler: <kullanıcıya sorulanlar>
TAHMİN işaretli maddeler: <n> — doğrulanmalı
```

## 5. Yaz

- `docs/CONTEXT.md` — şablonu doldur, bilinmeyenleri `<doğrulanmalı>` işaretle
- `docs/architecture/ARCHITECTURE.md` — **taslak** (durum: "Tersine mühendislik —
  doğrulanmadı" notuyla)
- `product/risks.md` — teknik borç maddeleri risk olarak
- `.state/project.json` — `phase: "operate"` veya kullanıcının seçtiği amaca göre
- Eksik `.claude/` dizin yapısını kur (`/kickoff` adım 6'daki dizinler)

## 6. Sonraki adımı öner

Kullanıcının amacına göre:

| Amaç | Sonraki |
|---|---|
| Yeni özellik ekleme | `/prd` (sadece yeni özellik için) → `/epics` → `/stories` |
| Refactor / borç ödeme | `/architecture` (hedef mimari) → `/adr` → `/epics` |
| Dokümantasyon | `/api-contract` (mevcut koddan) → `/data-model` |
| Kalite artırma | `/test-plan` → `/qa-run` → `/security-review` |

```
✓ Kod tabanı sisteme alındı.
  docs/CONTEXT.md ve mimari taslağı hazır.

⚠ Mimari doküman TERSİNE MÜHENDİSLİKTİR — doğrulanmadı.
  <n> madde TAHMİN olarak işaretli.

▶ Sonraki: <amaca göre komut>
```

---

## Token notu

- Keşif adımı **bedava** ve agent'ın kör arama yapmasını önler — en kritik tasarruf.
- **1-2 agent çağrısı.**
- Tüm kaynak kodu okuma. Manifest + giriş noktası + README yeter;
  gerisi agent'ın talebi üzerine hedefli.
- Büyük kod tabanlarında modül modül ilerle, hepsini birden haritalandırma.
