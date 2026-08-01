---
name: design-system
description: Design token setini ve komponent kataloğunu üretir. UX ekranlarından komponent listesini türetir, her komponentin varyant, durum, prop ve erişilebilirlik spesifikasyonunu yazar.
---

# /design-system

Sahip: `ui-designer`. Çıktı: `docs/design/system/`

Ön koşul: `docs/design/ux/wireframes/` (yoksa `/ux-flow` öner).

---

## 1. Girdi

- Ekran envanteri ve wireframe spesifikasyonlarındaki **UI öğeleri**
  (Grep ile `[` ile başlayan yerleşim satırlarını topla — tam wireframe gömme)
- Erişilebilirlik NFR'leri
- Marka/görsel tercih varsa `docs/DECISIONS.md`'den

Kullanıcıya `AskUserQuestion` ile sor:
- **Görsel yön:** `Nötr ve profesyonel (Önerilen)` / `Sıcak ve samimi` /
  `Yoğun ve veri odaklı` / `Mevcut markam var (anlatacağım)`
- **Tema:** `Açık + koyu (Önerilen)` / `Sadece açık`

## 2. `ui-designer` çağır

```
Ekranlarda geçen UI öğeleri: <türetilmiş liste>
Görsel yön: <cevap> | Tema: <cevap>
Erişilebilirlik hedefi: WCAG 2.2 AA
Platform: <web/mobil>

Görev: Design system üret.

1. tokens.md
   - Ham palet (kontrast oranlarıyla)
   - ANLAMSAL eşleme tablosu (açık + koyu tema)
     surface.*, text.*, border.*, action.*, feedback.*
   - Tipografi ölçeği, boşluk ölçeği (4px tabanlı), yarıçap, gölge, hareket
   - Kural: komponentler SADECE anlamsal token kullanır

2. Komponent envanteri — ekranlardan TÜRET, hayali komponent yazma
   | Komponent | Kullanıldığı ekranlar | Öncelik | Karmaşıklık |

3. Her komponent için spesifikasyon:
   anatomi, varyantlar, durumlar (default/hover/focus-visible/active/
   disabled/loading/error), props tablosu, erişilebilirlik
   (ARIA rolü, klavye haritası, odak halkası, dokunma hedefi ≥44px),
   yapılmaz listesi

4. patterns.md — form yerleşimi, tablo+filtre, modal, boş durum,
   bildirim, onay akışı, sayfalama. Her biri için TEK doğru yol.

5. accessibility.md — WCAG 2.2 AA kontrol listesi + bu sistemdeki karşılıkları

Kurallar:
- Az sayıda, iyi tanımlı token. 40 renk tokeni sistemi öldürür.
- Kontrast oranlarını hesapla ve yaz (metin ≥4.5:1, UI ≥3:1)
- Bir komponentin loading ve error hali yoksa komponent bitmemiştir
- Frontend geliştiricinin soru sormadan implement edebileceği netlikte yaz

Önce token setini ve komponent envanterini ver, sonra spesifikasyonları.
```

## 3. Kapsam kontrolü

Komponent sayısı 15'i aşıyorsa: öncelik `Yüksek` olanları şimdi, kalanı
ihtiyaç doğdukça yaz. Kullanıcıya sor.

## 4. Sun

```
## Design System
Tokenlar: <N> anlamsal (renk <a>, tipografi <b>, boşluk <c>)
Tema: <açık+koyu>
Komponentler: <M>

| Komponent | Kullanım | Öncelik |

Kontrast kontrolü: <geçen>/<toplam>
⚠ Kontrast sorunlu: <varsa>
```

## 5. Yaz

- `docs/design/system/tokens.md`
- `docs/design/system/components/<ad>.md`
- `docs/design/system/patterns.md`
- `docs/design/system/accessibility.md`

## 6. Kapat

```
✓ Design system → docs/design/system/
  <N> token | <M> komponent

▶ Sonraki: /epics
   Artık geliştirmeye hazırız — backlog kırılımı yapılacak.
```

---

## Token notu

- **1 agent çağrısı.**
- Wireframe'lerin tamamını gömme; sadece UI öğesi satırlarını türet.
- Komponent spesifikasyonlarını öncelik sırasına göre yaz — hepsini birden değil.
