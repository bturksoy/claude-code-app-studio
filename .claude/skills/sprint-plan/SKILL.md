---
name: sprint-plan
description: Sprint hedefini belirler, story'leri agent'lara dağıtır, bağımlılıkları sıralar, paralel çalışma bantlarını kurar ve riskleri işaretler. Görev dağılımının yapıldığı yer. DM-PLAN kapısını işletir.
---

# /sprint-plan [new | status]

Sahip: `delivery-manager`. Çıktı: `product/sprints/sprint-NN.md`

---

## 1. Girdi

- `product/backlog/index.md` — epic durumları
- Hazır story'lerin **başlık tablosu** (Glob + her story'den ilk 8 satır —
  tam story dosyalarını okuma)
- `product/roadmap/ROADMAP.md` — mevcut faz hedefi
- `product/risks.md`
- `.state/project.json` — aktif roller, son sprint numarası

## 2. Kullanıcıdan sprint parametreleri

`AskUserQuestion`:
- **Sprint uzunluğu:** `1 hafta` / `2 hafta (Önerilen)` / `Süre yok — story bazlı ilerle`
- **Bu sprintte odak:** `Yürüyen iskelet` / `<epic adı>` / `Karışık — en öncelikli story'ler`

## 3. `delivery-manager` çağır

```
Faz: <ad> — <hipotez ve çıkış kriteri>
Aktif roller: <liste>
Sprint uzunluğu: <cevap> | Odak: <cevap>
Son sprint: <NN> — <varsa devreden story'ler>

Hazır story'ler:
| # | Epic | Başlık | Tip | Sahip | Tahmin | Bağımlı | Dokunduğu modüller |

Açık riskler: <risks.md özeti>

Görev: Sprint <NN+1> planı üret.

1. Sprint hedefi — TEK cümle, kullanıcı değeri içermeli
   ("<N> story bitirmek" bir hedef değildir)
2. Story seçimi: kapasiteye sığan, bağımlılığı çözülmüş, hedefe hizmet edenler
3. Görev dağılımı tablosu: | # | Story | Tip | Sahip | Tahmin | Bağımlı | Gün | Durum |
4. Kritik yol: sıralı zincir — biri gecikirse sprint gecikir
5. Paralel bantlar: hangi işler aynı anda yürüyebilir
   Bant formatı: "Bant A (sözleşme) → Bant B (veri+servis) ‖ Bant C (arayüz)"
   Entegrasyon noktasını belirt (sprint ortası, sonu değil)
6. Riskler: | Risk | Olasılık | Etki | Sahip | Erken uyarı | Önlem |
7. Sprint dışı bırakılanlar ve neden

ZORUNLU KURALLAR (ihlal varsa planı düzelt):
- Bir story = bir sahip
- Aynı dosyaya/modüle iki agent aynı sprintte yazamaz → sıraya koy
- Sözleşme üreten iş (API/şema) tüketenden ÖNCEKİ gün biter
- Kapasitenin %20'si tampon (hata + plansız iş)
- Bağımlılık zinciri 3'ten uzun olamaz
- Bloke story'ler sprinte alınmaz

Yanıtına "DM-PLAN: ONAY|ŞARTLI|RET" satırıyla başla (kendi planını denetle).
```

## 4. Çakışma denetimi (sen yaparsın)

Plan geldiğinde şunu kontrol et:
- Aynı `Dokunduğu modüller` değerine sahip iki story aynı bantta mı → uyar
- Bağımlı story sahibi, bağımlı olunan story'nin sahibiyle aynı mı → darboğaz uyarısı
- Toplam tahmin kapasiteyi aşıyor mu

## 5. Sun

```
## Sprint <NN> — <tarih aralığı>
Hedef: <tek cümle>

Görev dağılımı
| # | Story | Sahip | Tahmin | Gün | Bağımlı |

Paralel bantlar
  Bant A (sözleşme) : story-003 → sql-developer         [Gün 1]
  Bant B (servis)   : story-004, story-005 → backend    [Gün 2-4]
  Bant C (arayüz)   : story-006 → frontend (mock ile)   [Gün 2-4]
  Entegrasyon       : Gün 4
  Bant D (test)     : story-007 → test-engineer         [Gün 5]

Kritik yol: story-003 → story-004 → story-006
Kapasite: <kullanılan>/<toplam> (tampon %<n>)
Riskler: <en büyük 3>
Sprint dışı: <liste>

Kapı: DM-PLAN <verdikt>
⚠ Çakışma uyarısı: <varsa>
```

`AskUserQuestion`: `Planı onayla (Önerilen)` / `Kapsamı daraltacağım` /
`Sahip atamalarını değiştireceğim`

## 6. Yaz

- `product/sprints/sprint-NN.md`
- `product/sprints/index.md` satırı
- Her seçilen story dosyasının başlığındaki `**Sprint:**` alanını güncelle
- `.state/project.json` → `currentSprint`, `phase: "build"`
- `docs/CONTEXT.md` → "Şu an ne yapılıyor" bölümü
- `.state/gates.jsonl` → DM-PLAN

## 7. Kapat

```
✓ Sprint <NN> planlandı — <N> story, <M> rol

▶ Sonraki: /dev-task <ilk-story-yolu>
   Kritik yoldaki ilk story: <ad> (<sahip>)

   Alternatif: /team-feature <epic>  — tüm bandı koordineli yürütür
```

---

## `/sprint-plan status` modu

Argüman `status` ise yeni plan yapma; mevcut sprintin durumunu göster:

```
## Sprint <NN> — Gün <X>/<Y>
| Story | Sahip | Durum | Not |
Tamamlanan: <a>/<b> | Bloke: <c>
Kritik yol durumu: <yolunda | risk altında | gecikti>
Kalan kapasite: <...>
▶ Şimdi yapılacak: <story>
```

Bu mod **agent çağırmaz** — sadece dosya okur.

---

## Token notu

- **1 agent çağrısı.**
- Story dosyalarının **tamamını okuma** — başlık bloğu (ilk 8 satır) yeter.
- `status` modu tamamen bedava (dosya okuma).
- Çakışma denetimini model yapar.
