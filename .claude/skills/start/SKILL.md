---
name: start
description: Proje durumunu tespit eder ve nereden devam edileceğini söyler. Yeni projede kurulumu başlatır, mevcut projede eksik adımı bulur. Her oturumun ilk komutu.
---

# /start

Ucuz bir durum tespiti yapar ve **tek bir sonraki adım** önerir. Agent çağırmaz.

## 1. Durum tespiti

Şu dosyaların varlığını **Glob ile** kontrol et (içeriklerini okuma):

```
.state/project.json
product/00-brief.md
product/prd/PRD.md
product/requirements/FRD.md
product/roadmap/ROADMAP.md
docs/architecture/ARCHITECTURE.md
docs/api/openapi.yaml
product/backlog/index.md
product/sprints/index.md
docs/CONTEXT.md
```

Ayrıca: `src/` altında dosya var mı (Glob `src/**/*.*`, ilk 5 sonuç yeter).

## 2. Duruma göre yönlendir

### A) Hiçbiri yok, `src/` de boş → **yeni proje**

```
Bu dizinde henüz proje yok.

Başlamak için proje fikrini tek cümleyle yaz:
  /kickoff "<proje fikrin>"

Örnek:
  /kickoff "Küçük işletmeler için stok ve fatura takip uygulaması"
```

Dur, başka bir şey yapma.

### B) `src/` dolu ama `product/` ve `docs/` yok → **mevcut kod tabanı**

```
Kod var ama App Studio dokümanları yok.

  /onboard    → mevcut kod tabanını analiz edip CONTEXT.md ve mimari taslağı çıkarır
```

### C) `.state/project.json` var → **devam eden proje**

`.state/project.json` ve `docs/CONTEXT.md` oku (sadece bu ikisi).
Şu tabloyu üret:

```
## <proje adı>
Faz: <faz>  |  Sprint: <NN>  |  Mod: <lean>  |  Ölçek: <standard>

Tamamlanan
  ✓ <adım>  → <dosya>
Eksik
  ○ <adım>  → <komut>

Açık kapı koşulu: <N>  (varsa .state/gates.jsonl'den ŞARTLI olanlar)

▶ Sonraki adım: <tek komut>
```

Faz → sonraki komut haritası:

| Mevcut durum | Sonraki |
|---|---|
| brief var, PRD yok | `/prd` |
| PRD var, FRD yok | `/requirements` |
| FRD var, roadmap yok | `/roadmap` |
| roadmap var, mimari yok | `/architecture` |
| mimari var, backlog yok | `/epics` |
| epic var, story yok | `/stories <epic>` |
| story var, sprint yok | `/sprint-plan` |
| sprint var, açık story var | `/dev-task <story>` |
| tüm story'ler DONE | `/dod-check` → `/release` |

## 3. Kurallar

- **Hiçbir agent çağırma.** Bu skill sadece dosya varlığına bakar.
- **Tam dosya okuma sayısı: en fazla 2** (`project.json`, `CONTEXT.md`).
- Birden fazla eksik varsa **sadece ilkini** öner — kullanıcıyı seçeneğe boğma.
- Kullanıcı "hepsini anlat" derse `/help` çalıştırmasını söyle.
