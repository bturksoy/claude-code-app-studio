---
name: roadmap
description: Projeyi bağımsız değer üreten fazlara böler, her faza kapsam ve çıkış kriteri atar, sürüm planını çıkarır. Fazlandırma adımı — hangi gereksinimin hangi sürümde olacağını belirler.
---

# /roadmap

Sahip: `product-owner`, danışan: `delivery-manager`.
Çıktı: `product/roadmap/ROADMAP.md` + `product/roadmap/phases/phase-N.md`

Ön koşul: `product/requirements/FRD.md`

---

## 1. Girdi

FRD'den **sadece REQ başlık tablosunu** çıkar (ID, başlık, öncelik, kaynak GOAL,
bağımlılık). Tam gereksinim metinlerini gömme — bu adım için gereksiz.

NFR'lerden sadece faz kararını etkileyenleri al (ölçek, güvenlik, uyumluluk).

## 2. Fazlandırma ilkeleri (agent'a bunları ver)

1. **Her faz tek başına yayınlanabilir ve değer üretir.** "Önce backend fazı"
   bir faz değildir — kimse kullanamaz.
2. **Faz 1 en riskli varsayımı test eder.** En kolay şeyi değil, en belirsiz şeyi öne al.
3. **Faz büyüklüğü:** 1-3 sprint. Daha büyükse böl.
4. **Bağımlılık yönü ileri.** Faz 2, Faz 1'i kullanabilir; tersi olamaz.
5. **Her fazın çıkış kriteri ölçülebilir.** "Bitince" değil, "şu metrik şu değere ulaşınca".
6. **Teknik temel işleri fazlara dağıtılır**, ayrı bir "altyapı fazı" açılmaz —
   ama Faz 1 içinde "yürüyen iskelet" (walking skeleton) olmalıdır.

## 3. `product-owner` çağır

```
<REQ TABLOSU> + <GOAL listesi> + <kritik NFR'ler> + <kısıtlar>

Görev: Yol haritası üret.

1. Fazlar (en fazla 4). Her faz için:
   - Ad ve tek cümlelik hipotez ("Bu fazı yayınlarsak şunu öğreneceğiz/sağlayacağız")
   - Kapsam: REQ-* listesi
   - Çıkış kriteri: ölçülebilir (hangi GOAL metriği, hangi değer)
   - Bu fazda YAPMIYORUZ: liste
   - Yürüyen iskelet: Faz 1 için uçtan uca çalışan en ince dilim ne?
2. Faz bağımlılık grafiği (Mermaid)
3. Sürüm eşlemesi: hangi faz hangi sürüm (v0.1, v1.0, ...)
4. Her faz için en büyük risk ve erken uyarı sinyali
5. Kesme sırası: takvim daralırsa hangi REQ'ler sırayla çıkarılır (öncelikli liste)

Kural: Her REQ tam olarak bir faza atanmalı. Atanmayan REQ varsa listele ve
"kapsam dışı mı?" diye sor.
```

## 4. `delivery-manager` ile gerçeklik kontrolü (lean+ mod)

Aynı mesajda paralel çağrılamaz (PO'nun çıktısına bakar). PO çıktısı geldikten sonra:

```
<FAZ TABLOSU — kapsam ve REQ sayılarıyla>

Görev: Bu fazlandırma teslim edilebilir mi?
1. Her faz için kaba sprint tahmini (t-shirt: S/M/L + gerekçe)
2. Bağımlılık sorunları: bir fazın içinde birbirini bekleyen zincir var mı
3. Aynı anda çalışılamayacak işler var mı (aynı dosya/modül)
4. Kritik yol: hangi REQ'ler gecikirse tüm plan kayar
5. En büyük 3 teslimat riski

Kısa yaz. Yanıtına "DM-PLAN: ONAY|ŞARTLI|RET" satırıyla başla.
```

`solo` modda bu adımı atla.

## 5. Sun

```
## Yol Haritası

Faz 1 — <ad>  (v0.1, ~<N> sprint)
  Hipotez: <...>
  Kapsam: <N> REQ — <ID listesi>
  Çıkış: <ölçülebilir kriter>
  Yapmıyoruz: <liste>

Faz 2 — ...

Atanmamış REQ: <varsa liste> ⚠
Teslimat riski: <DM'den en büyük 3>
Kesme sırası: <takvim daralırsa çıkacaklar, sırayla>
```

`AskUserQuestion`: `Onayla ve yaz (Önerilen)` / `Faz 1'i daraltacağım` /
`Faz sırasını değiştireceğim`

## 6. Yaz

- `product/roadmap/ROADMAP.md` — üst seviye tablo + bağımlılık grafiği + kesme sırası
- `product/roadmap/phases/phase-N.md` — her faz için detay
- `docs/CONTEXT.md` → "Sürüm hedefi" güncellenir
- `.state/project.json` → `phase: "design"`, `.state/gates.jsonl` → DM-PLAN

## 7. Kapat

```
✓ Yol haritası: <N> faz, <M> sürüm
  Faz 1: <ad> — <K> REQ

▶ Sonraki: /architecture
   Faz 1 kapsamı için mimari ve teknoloji yığını belirlenecek.
```

---

## Token notu

- REQ **başlık tablosu** gömülür, tam metinler değil. En büyük tasarruf burada.
- `solo` modda tek agent çağrısı; `lean+` modda iki (sıralı).
- Sonraki fazların detayı **şimdi yazılmaz** — o faza gelince `/requirements`
  ve `/epics` tekrar çalışır.
