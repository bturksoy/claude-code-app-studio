---
name: epics
description: Faz kapsamındaki gereksinimleri epic'lere böler. Her epic bir yetenek grubunu, ilgili gereksinimleri, mimari katmanı ve bağımlılıkları taşır. Story kırılımının bir üst seviyesidir.
---

# /epics [faz]

Sahip: `product-owner` + `solution-architect` (paralel).
Çıktı: `product/backlog/epics/<slug>/EPIC.md` + `product/backlog/index.md`

Ön koşul: `FRD.md` + `ROADMAP.md` + `ARCHITECTURE.md`

---

## 1. Kapsam

Argüman yoksa `ROADMAP.md`'den mevcut fazı al. O fazın REQ listesini çıkar.

## 2. Paralel çağrı (tek mesaj)

### Çağrı A — `product-owner`

```
Faz: <ad> — <hipotez>
REQ tablosu: <ID | başlık | öncelik | aktör>
Yetenekler: <FEAT tablosu>

Görev: Bu fazı epic'lere böl.
- Her epic KULLANICI DEĞERİ etrafında toplanır, teknik katman etrafında değil
  ("Kullanıcı yönetimi" ✓ / "Backend API'leri" ✗)
- Her epic 3-8 story üretecek büyüklükte
- Her epic bir cümlelik değer ifadesi taşır: "<aktör> <şunu> yapabilir, böylece <fayda>"
- Epic sırası: kullanıcı değeri en erken görünen önce
- Her REQ tam olarak bir epic'e atanmalı — atanmayan varsa listele

Çıktı: | Epic slug | Ad | Değer ifadesi | REQ listesi | Öncelik |
```

### Çağrı B — `solution-architect`

```
Faz: <ad>
REQ tablosu: <ID | başlık>
Mimari: <konteyner ve modül listesi + bağımlılık yönü kuralı>
ADR listesi: <ID | başlık | etkilediği alan>
API endpoint listesi: <path + method>
Veri modeli: <tablo listesi>

Görev: Teknik kırılım kısıtlarını çıkar.
1. Teknik katman sırası: hangi işler diğerlerinden önce bitmeli
   (sözleşme → veri → servis → arayüz)
2. Her REQ için: hangi modüllere dokunur, hangi ADR'ler geçerli
3. Yürüyen iskelet: uçtan uca çalışan en ince dilim hangi REQ'lerden oluşur
4. Riskli/belirsiz REQ'ler: önce spike gerektirenler
5. Aynı modüle dokunan REQ'ler (paralel çalışılamayacaklar)

Çıktı tablo halinde, kısa.
```

## 3. Birleştir (sen yaparsın)

PO'nun değer bazlı epic'lerine SA'nın teknik kısıtlarını ekle:
- Her epic'e: dokunulan modüller, geçerli ADR'ler, teknik ön koşullar
- Epic sırasını teknik bağımlılığa göre düzelt (değer sırası ile çelişirse
  çelişkiyi kullanıcıya göster)
- Yürüyen iskelet epic'ini **ilk sıraya** al

## 4. Sun

```
## Epic Kırılımı — Faz <N>

| # | Epic | Değer | REQ | Modüller | ADR | Bağımlı |

Yürüyen iskelet: <epic>
Sıra gerekçesi: <tek paragraf>
⚠ Atanmamış REQ: <varsa>
⚠ Değer sırası ↔ teknik sıra çelişkisi: <varsa>
```

`AskUserQuestion` ile onay al.

## 5. Yaz

Her epic için `product/backlog/epics/<slug>/EPIC.md`:

```markdown
# Epic: <ad>
> **Faz:** <N> | **Öncelik:** <n> | **Durum:** Hazır | **Sıra:** <n>

## Değer
<aktör> <şunu> yapabilir, böylece <fayda>.

## Kapsanan gereksinimler
| REQ | Başlık | Öncelik | Kabul kriteri sayısı |

## Teknik bağlam
**Dokunulan modüller:** <liste>
**Geçerli ADR'ler:** <ADR-NNNN: başlık — 1 satır karar özeti>
**API endpoint'leri:** <liste>
**Veri tabloları:** <liste>
**Ekranlar:** <UX envanterinden>

## Bağımlılıklar
Önce bitmesi gereken: <epic listesi veya Yok>
Bunu bekleyen: <epic listesi veya Yok>

## Story'ler
*Henüz oluşturulmadı — `/stories <slug>` çalıştır*

## Tamamlanma kriteri
<epic ne zaman biter — ölçülebilir>
```

Ayrıca `product/backlog/index.md`:

```markdown
# Backlog
| # | Epic | Faz | REQ | Story | Durum | Bağımlı |
```

`.state/project.json` → `counters.epics` güncelle.

## 6. Kapat

```
✓ <N> epic → product/backlog/epics/
  Faz <M> | <K> REQ kapsandı

▶ Sonraki: /stories <ilk-epic-slug>
   İlk epic'i story'lere böl. Sırayla ilerle — bağımlılık sırası önemli.
```

---

## Token notu

- **2 paralel agent çağrısı**, birleştirme model tarafından yapılır.
- REQ'ler **başlık tablosu** olarak gömülür, tam metin değil.
- ADR'ler sadece **başlık + 1 satır karar** olarak; tam ADR story'de gömülecek.
- Tüm fazların epic'lerini birden yazma — sadece mevcut faz.
