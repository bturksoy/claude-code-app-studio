---
name: release
description: Sürüm planını hazırlar, tüm kalite kapılarını toplar, migration ve geri alma planını doğrular ve CEO go/no-go kararını alır. OPS-READY ve CEO-GONOGO kapılarını işletir.
---

# /release <sürüm>

Sahip: `devops-engineer` + `ceo`. Çıktı: `docs/ops/release-<sürüm>.md`

---

## 1. Sürüm kapsamını topla (agent çağırmadan)

- Bu sürüme giren story'ler (`Durum: DONE` + sprint filtresi)
- Açık hatalar: P0/P1 var mı (varsa **uyar**)
- Kapı geçmişi (`.state/gates.jsonl`): açık `ŞARTLI` maddeler
- Migration'lar: bu sürümde çalışacak yeni migration'lar
- Değişen bağımlılıklar ve yapılandırma

**Ön kontrol — herhangi biri başarısızsa dur ve bildir:**
```
[ ] Sürüm kapsamındaki tüm story'ler DONE (QA-DONE: ONAY)
[ ] Açık P0 hata yok
[ ] Açık ŞARTLI kapı maddesi yok
[ ] Regresyon paketi son çalıştırmada yeşil
```

## 2. Eksik kapıları çalıştır

Bu sürüm için çalışmamış kapılar varsa öner:
- `SEC-REVIEW` yoksa → `/security-review` öner
- `PERF-BUDGET` yoksa (ve NFR'de performans hedefi varsa) → `/perf-check` öner
- Regresyon yeşil değilse → `/qa-run regression` öner

`AskUserQuestion` ile: `Eksik kapıları çalıştır (Önerilen)` /
`Atla ve riski kabul et` / `Sürümü ertele`

## 3. `devops-engineer` çağır — OPS-READY

```
Sürüm: <sürüm>
Kapsam: <story listesi — başlıklar>
Migration'lar: <dosya listesi + her birinin ne yaptığı>
Değişen bağımlılıklar/config: <liste>
Hedef ortam: <staging → prod>
Mevcut ortam tanımı: <docs/ops/environments.md özeti>
NFR — kullanılabilirlik/kurtarma: <ilgili NFR'ler>

Görev: Sürüm planı ve OPS-READY kapısı.

1. Dağıtım adımları — sıralı, her adımın doğrulaması ile
2. Migration planı: sıra, tahmini süre, kilit riski, geri alınabilirlik
   Kesinti gerekiyorsa süresi ve duyuru planı
3. Geri alma (rollback) planı — ADIM ADIM, veri kaybı riskiyle birlikte
   Migration geri alınamıyorsa BELİRT ve ileri-düzeltme (roll-forward) planı ver
4. Yayın öncesi kontrol listesi
5. Yayın sonrası doğrulama: hangi metrik/log/alarm izlenecek, ne kadar süre
6. Kademeli yayın önerisi (canary/yüzde) uygulanabilir mi

OPS-READY kriterleri:
- Ortam IaC'den üretilebiliyor mu
- Rollback yazılı ve test edilmiş mi
- Secret'lar yönetici üzerinden mi, sızıntı taraması temiz mi
- Log/metrik/alarm tanımlı, alarm sahipleri belli mi
- Yedekleme çalışıyor, geri dönüş denenmiş mi
- Kapasite beklenen yükün 2 katına dayanıyor mu

Yanıtına "OPS-READY: ONAY|ŞARTLI|RET" satırıyla başla.
```

## 4. `ceo` çağır — CEO-GONOGO

```
Sürüm: <sürüm>
Kapsam (kullanıcı değeri açısından): <story'lerin iş dilindeki özeti>
Hangi GOAL'lara hizmet ediyor: <liste>

KAPI DURUMU:
  QA-DONE: <verdikt>  |  SEC-REVIEW: <verdikt>  |  PERF-BUDGET: <verdikt>
  OPS-READY: <verdikt>

Açık riskler: <liste — kabul edilenler dahil>
Bilinen sınırlamalar: <bu sürümde çalışmayan/eksik olanlar>
Geri alma: <mümkün mü, maliyeti ne>

Görev: CEO-GONOGO kararı.
Değerlendir: yayınlamamanın maliyeti, yayınlamanın riskinden büyük mü?
Kısa yaz. Yanıtına "CEO-GONOGO: ONAY|ŞARTLI|RET" satırıyla başla.
```

## 5. Sun

```
## Sürüm <sürüm>
Kapsam: <N> story | <M> hata düzeltmesi

Kapılar
  QA-DONE      <verdikt>
  SEC-REVIEW   <verdikt>
  PERF-BUDGET  <verdikt>
  OPS-READY    <verdikt>
  CEO-GONOGO   <verdikt>

Migration: <N> — geri alınabilir: <evet/hayır>
Kesinti: <var/yok — süre>
Rollback: <özet>

Bilinen sınırlamalar: <liste>
Kabul edilen riskler: <liste>

Yayın sonrası izlenecek: <metrikler + süre>
```

## 6. Yaz — deploy ETME

```
✓ Sürüm planı → docs/ops/release-<sürüm>.md

⚠ Deploy komutu ÇALIŞTIRILMADI. Planı incele ve hazır olduğunda kendin çalıştır:
```
Deploy komutunu **kod bloğu olarak göster**, çalıştırma.
Kullanıcı açıkça "deploy et" derse ve `CEO-GONOGO: ONAY` ise çalıştır.

Ayrıca:
- `/changelog` çalıştırmayı öner
- `.state/gates.jsonl` → iki kapı satırı
- `.state/project.json` → `phase: "release"`

## 7. Yayın sonrası

Kullanıcı deploy ettiğini bildirdiğinde:
- Doğrulama listesini hatırlat
- `docs/ops/release-<sürüm>.md`'ye gerçek yayın zamanı ve sonucunu ekle
- `.state/project.json` → `phase: "operate"`
- `/retro` öner

---

## Token notu

- **2 agent çağrısı** (DevOps + CEO). Kapı toplama bedava.
- CEO'ya teknik detay değil, **iş dilinde özet** gönder.
- Eksik kapılar varsa onları ayrı skill'lerle çalıştır — bu skill'e gömme.
