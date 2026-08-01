---
name: retro
description: Sprint veya sürüm retrospektifi yapar. Ne iyi gitti, ne gitmedi, kök nedenler ve sahiplenilmiş aksiyon maddeleri üretir. Süreç iyileştirmesinin yeri.
---

# /retro [sprint | release | "<olay>"]

Sahip: `delivery-manager`.

---

## 1. Veri topla (bedava — bu retro'nun değeri verinin gerçekliğinde)

| Veri | Kaynak |
|---|---|
| Planlanan vs tamamlanan story | sprint dosyası + story durumları |
| Tahmin vs gerçek | story tahminleri + tamamlanma sırası |
| Bloke olaylar ve süreleri | sprint dosyası notları |
| Açılan/kapanan hata sayısı | `docs/qa/bugs/` |
| Kapı verdiktleri | `.state/gates.jsonl` — kaç RET, kaç ŞARTLI |
| Agent çağrı sayısı | `.state/agent-log.jsonl` |
| Kapsam değişiklikleri | `docs/DECISIONS.md` |
| Gerçekleşen riskler | `product/risks.md` |

## 2. `delivery-manager` çağır

```
Sprint/Sürüm: <NN>
Hedef: <sprint hedefi>

VERİLER:
Planlanan story: <N> | Tamamlanan: <M> | Devreden: <K>
Tahmin sapması: <story bazında liste>
Bloke olaylar: <neden + süre>
Hatalar: açılan <a>, kapanan <b>, üretime kaçan <c>
Kapı verdiktleri: ONAY <x>, ŞARTLI <y>, RET <z>
  RET alanlar: <hangi kapı, hangi story>
Agent çağrısı: <N> | Kapı: <M>
Kapsam değişiklikleri: <liste>
Gerçekleşen riskler: <liste>

Görev: Retrospektif.

1. Sprint hedefi karşılandı mı? Karşılanmadıysa asıl neden ne?
   (Semptom değil kök neden ara — "zaman yetmedi" bir neden değildir)
2. İyi giden 3 şey — TEKRARLANABİLİR olanlar (şans değil)
3. Kötü giden 3 şey — her biri için "5 neden" ile kök nedene in
4. Tahmin doğruluğu: sistematik sapma var mı, hangi tip story'de
5. Kalite sinyalleri: RET alan kapılar bir desene mi işaret ediyor
6. Süreç maliyeti: agent çağrı sayısı makul mü, nerede israf var
   (>30 çağrı/sprint = görev paketi kalitesi sorunu)
7. Aksiyon maddeleri — EN FAZLA 3, her biri:
   somut, sahipli, ölçülebilir, bir sonraki sprintte doğrulanabilir
   ("daha dikkatli olalım" bir aksiyon değildir)

Önceki retro'nun aksiyonları uygulandı mı? Uygulanmadıysa neden?
```

## 3. Sun

```
## Retrospektif — Sprint <NN>
Hedef: <hedef> → <karşılandı/karşılanmadı>

Sayılar
  Story: <M>/<N> tamamlandı | Devreden: <K>
  Tahmin sapması: <ortalama %>
  Hata: <a> açıldı, <b> kapandı, <c> üretime kaçtı
  Kapı: ONAY <x> | ŞARTLI <y> | RET <z>
  Agent çağrısı: <N> (hedef <30)

İyi giden (tekrarlanabilir)
  - <madde> — neden işe yaradı: <...>

Kötü giden (kök nedenle)
  - Semptom: <...> → Kök neden: <...>

Aksiyonlar (sonraki sprint)
  | # | Aksiyon | Sahip | Nasıl doğrulanacak |

Önceki retro aksiyonları: <uygulanan>/<toplam>
```

## 4. Yaz

- `product/sprints/retro-<NN>.md`
- Aksiyon maddelerini bir sonraki sprint dosyasına **taşı** (unutulmasın)
- Süreç aksiyonu ise ilgili `.claude/` dosyasında değişiklik öner
  (örn. story şablonuna alan eklenmesi) — kullanıcıya sor
- `docs/CONTEXT.md` → "Bilinen borç ve riskler" güncelle

## 5. Kapat

```
✓ Retro → product/sprints/retro-<NN>.md
  <N> aksiyon maddesi, sahipleriyle

▶ Sonraki: /sprint-plan  (aksiyonlar yeni sprinte taşındı)
```

---

## Token notu

- **1 agent çağrısı.** Veri toplama bedava.
- Retro'nun değeri **gerçek sayılarda** — hafızadan yazma, dosyalardan çıkar.
- En fazla 3 aksiyon: uygulanabilir olsun, liste olmasın.
