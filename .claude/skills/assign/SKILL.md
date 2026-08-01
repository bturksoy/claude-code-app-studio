---
name: assign
description: Bir story'yi doğru agent'a yönlendirir. Hazırlık kontrolü yapar, eksik bağlamı tespit eder ve gerekirse story'yi tamamlar. /dev-task öncesi hazırlık adımı.
---

# /assign <story-yolu>

Sahip: `delivery-manager`. Agent çağırmadan çalışır (story eksikse hariç).

---

## 1. Story'yi oku ve sahip belirle

`Sahip` alanı doluysa onu kullan. Boşsa tipten ve içerikten türet:

| Sinyal | Sahip |
|---|---|
| Ekran, komponent, form, rota, CSS | `frontend-developer` |
| Endpoint, servis, iş kuralı, entegrasyon | `backend-developer` |
| Tablo, migration, index, sorgu | `sql-developer` |
| Pipeline, ortam, IaC, izleme, deploy | `devops-engineer` |
| ETL, rapor, event şeması | `data-engineer` |
| Test senaryosu, otomasyon, regresyon | `test-engineer` |
| Ekran akışı, IA, wireframe | `ux-designer` |
| Token, komponent spesifikasyonu | `ui-designer` |

**Birden fazla sinyal varsa story bölünmelidir** — bunu raporla:
```
⚠ story-007 hem backend hem frontend işi içeriyor.
   Öneri: iki story'ye böl → /stories <epic> tekrar çalıştır
   veya: sözleşme sınırından böl (BE önce, FE sonra)
```

## 2. Hazırlık kontrolü

```
[ ] Durum "Hazır" mı (Bloke değil)
[ ] Bağımlı story'ler DONE mı
[ ] Kabul kriterleri Given/When/Then formatında mı
[ ] "Uygulanacak mimari kararlar" dolu mu (veya gerekçeli N/A)
[ ] "Sözleşme" bölümü dolu mu (API/veri gerektiren tipler için)
[ ] "Dokunulacak dosyalar" listesi var mı
[ ] "Test senaryoları" dolu mu (Logic/Integration için)
[ ] "Kapsam DIŞI" bölümü dolu mu
```

## 3. Eksikleri tamamla

Eksik varsa **kaynağı bul ve story'ye kopyala** (agent çağırmadan):

| Eksik | Kaynak |
|---|---|
| Kabul kriterleri | `FRD.md` → ilgili REQ |
| ADR uygulama rehberi | `adr/ADR-NNNN-*.md` → "Uygulama rehberi" bölümü |
| Sözleşme | `openapi.yaml` ilgili endpoint / `ER.md` ilgili tablo |
| Dokunulacak dosyalar | Grep ile ilgili modülde tespit et |
| Test senaryoları | Yoksa `qa-lead` çağır (tek eksik bu ise) |

Bu adım **görev paketini tamamlar** ve `/dev-task`'ın maliyetini düşürür.

## 4. Sun

```
## Görev Ataması

Story <NNN>: <başlık>
Sahip: <agent>   Tip: <tip>   Tahmin: <boyut>

Hazırlık: <a>/<b> ✓
Tamamlanan eksikler:
  ✓ Sözleşme eklendi (openapi.yaml → POST /orders)
  ✓ ADR-0007 uygulama rehberi kopyalandı
  ✓ Dokunulacak dosyalar tespit edildi (<n> dosya)

Kalan eksik: <varsa>

Bağımlılıklar: <durum>

▶ Hazır: /dev-task <yol>
```

## 5. Bloke ise

```
⚠ Story bloke: <neden>
   Bağımlı: story-003 (durum: Devam ediyor)

   Şu an yapılabilecekler:
     /dev-task <bağımsız story yolu>
```

---

## Token notu

- **Genellikle 0 agent çağrısı** — sadece dosya okuma ve kopyalama.
- Bu skill `/dev-task`'ın maliyetini düşürmek için vardır: eksik görev paketi
  = geliştirici agent'ın arama yapması = 3-5 kat maliyet.
- Sprint başında tüm story'ler için toplu çalıştırılabilir.
