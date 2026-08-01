---
name: changelog
description: Tamamlanan story ve hata düzeltmelerinden değişiklik günlüğü girdisi üretir. Keep a Changelog + SemVer formatında, kullanıcı diliyle yazar.
---

# /changelog [sürüm]

Sahip: `tech-writer` (haiku — ucuz, mekanik iş).

---

## 1. Girdi topla (bedava)

- Son sürümden bu yana `Durum: DONE` olan story'ler (başlık + değer ifadesi)
- Kapatılan hatalar (`docs/qa/bugs/` — `Durum: Kapandı`)
- Kırıcı değişiklikler (`docs/DECISIONS.md` + `openapi.yaml` değişiklikleri)
- Mevcut `CHANGELOG.md` (format ve son sürüm numarası için)

## 2. Sürüm numarası belirle

```
Kırıcı değişiklik var  → MAJOR
Yeni özellik var       → MINOR
Sadece düzeltme        → PATCH
```

Kullanıcıya öner ve onaylat.

## 3. `tech-writer` çağır

```
Önceki sürüm: <vX.Y.Z>
Önerilen sürüm: <vX.Y.Z>

Tamamlanan story'ler:
| ID | Başlık | Kullanıcı değeri |

Kapatılan hatalar:
| ID | Başlık |

Kırıcı değişiklikler: <liste>
Güvenlik düzeltmeleri: <liste>

Görev: CHANGELOG girdisi üret (Keep a Changelog formatı).
Bölümler: Eklendi / Değişti / Kullanımdan kalktı / Kaldırıldı / Düzeltildi / Güvenlik

Kurallar:
- KULLANICI dilinde yaz, teknik jargon değil
  ✗ "OrderService'e idempotency key eklendi"
  ✓ "Aynı sipariş yanlışlıkla iki kez oluşturulamıyor"
- Her satır sonunda referans: (story-014) veya (BUG-021)
- Kırıcı değişiklik varsa GEÇİŞ NOTU zorunlu: ne değişti, kullanıcı ne yapmalı
- Pazarlama dili yasak
- Kullanıcının fark etmeyeceği iç değişiklikleri YAZMA
```

## 4. Yaz

`CHANGELOG.md`'nin **başına** ekle (append-only — eski girdileri düzenleme).

## 5. Kapat

```
✓ CHANGELOG güncellendi — <vX.Y.Z>
  Eklendi <a> | Düzeltildi <b> | Güvenlik <c>
  Kırıcı değişiklik: <var/yok>

▶ Sonraki: /release <vX.Y.Z>
```

---

## Token notu

- **1 haiku çağrısı** — bu iş mekaniktir, büyük model gerektirmez.
- Story'lerin tam içeriğini değil, başlık + değer ifadesini göm.
