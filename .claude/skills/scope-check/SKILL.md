---
name: scope-check
description: Kapsam kaymasını tespit eder. Mevcut backlog'u orijinal hedeflerle karşılaştırır, hedefe bağlanmayan işleri bulur ve kesme önerileri üretir.
---

# /scope-check

Sahip: `product-owner`. Ne zaman: sprint planı öncesi, takvim baskısında,
yeni istek geldiğinde.

---

## 1. İzlenebilirlik denetimi (bedava)

Zinciri kontrol et: `story → REQ → GOAL`

Grep ile topla:
- Tüm story'lerin `İzlenebilirlik` satırları
- `FRD.md`'deki REQ → GOAL eşlemeleri
- `00-brief.md`'deki GOAL listesi

Kopukları bul:
```
⚠ GOAL'a bağlanmayan REQ: <liste>
⚠ REQ'e bağlanmayan story: <liste>
⚠ Hiçbir story tarafından karşılanmayan REQ: <liste>
⚠ MVP'de olmayacaklar listesindeki bir şey backlog'a girmiş mi: <liste>
```

## 2. Büyüme ölçümü (bedava)

```
Orijinal PRD yetenek sayısı : <N>   (PRD ilk sürümünden)
Şu anki backlog story sayısı: <M>
Fazın kapsamındaki REQ      : <K>   (roadmap'ten)
Backlog'a sonradan eklenen  : <L>   (DECISIONS.md kapsam değişiklikleri)
```

## 3. `product-owner` çağır (kopukluk veya büyüme varsa)

```
Orijinal hedefler: <GOAL listesi>
MVP'de olmayacaklar (orijinal): <liste>

İzlenebilirlik kopuklukları:
<yukarıdaki liste>

Büyüme: PRD <N> yetenek → backlog <M> story (faz kapsamı <K> REQ)
Sonradan eklenenler: <liste + tarih + gerekçe>

Mevcut sprint kapasitesi: <bilgi>

Görev: Kapsam denetimi.
1. Kopuk işler gerçekten gerekli mi? Her biri için: TUT / KES / ERTELE + gerekçe
2. "Olmayacak" listesini ihlal eden işler var mı
3. Büyüme haklı mı? (öğrenme sonucu meşru genişleme vs disiplinsizlik)
4. Kesme sırası: takvim daralırsa hangi işler SIRAYLA çıkarılır
   Her kesme için: hangi GOAL zarar görür, ne kadar
5. En küçük değerli sürüm: bugünkü backlog'tan hangi <n> story ile
   yayınlanabilir bir ürün çıkar
```

## 4. Sun

```
## Kapsam Denetimi

Büyüme: <N> → <M>  (%<artış>)
İzlenebilirlik: <a> kopuk bağ

Kopuk işler
| Story/REQ | Bağlanmıyor | Öneri | Gerekçe |
| story-012 | GOAL yok | KES | Hiçbir hedefe hizmet etmiyor |

"Olmayacak" ihlali: <liste>

Kesme sırası (takvim daralırsa)
1. <story> — GOAL-02 kısmen etkilenir
2. <story> — etki yok

En küçük değerli sürüm: <n> story
  <liste>
```

`AskUserQuestion`:
- `Önerilen kesmeleri uygula (Önerilen)`
- `Sadece kopuk işleri kes`
- `Hiçbir şey kesme — kapasiteyi artıracağım`
- `En küçük değerli sürüme daralt`

## 5. Uygula

Kesilen story'ler **silinmez** — `product/backlog/deferred/` altına taşınır,
durumu `Ertelendi` olur, gerekçesi yazılır.
Kararlar `docs/DECISIONS.md`'ye eklenir.

---

## Token notu

- İzlenebilirlik denetimi ve büyüme ölçümü **bedava**.
- Kopukluk yoksa ve büyüme %20'nin altındaysa **agent çağırmadan** temiz raporla.
- **1 agent çağrısı** (gerekliyse).
