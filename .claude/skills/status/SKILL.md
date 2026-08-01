---
name: status
description: Proje durum panosu üretir — faz, sprint, ilerleme, bloke işler, açık kapılar, riskler ve token kullanım notu. Ardından tek bir sonraki adım önerir.
---

# /status

Sahip: `delivery-manager`. **Varsayılan olarak agent çağırmaz** — dosya okur.

---

## 1. Veri topla (hepsi ucuz)

| Kaynak | Ne alınır |
|---|---|
| `.state/project.json` | faz, sprint, mod, ölçek, sayaçlar, yığın |
| `docs/CONTEXT.md` | mevcut odak, bilinen borç |
| `product/sprints/sprint-NN.md` | görev dağılımı ve durumlar |
| Story dosyaları (başlık blokları) | durum, sahip, tip |
| `.state/gates.jsonl` | kapı geçmişi, açık ŞARTLI maddeler |
| `product/risks.md` | aktif riskler |
| `docs/qa/bugs/` | açık hatalar (başlık blokları) |
| `.state/agent-log.jsonl` | agent çağrı sayısı (token notu için) |

## 2. Panoyu üret

```
╭─ <Proje adı> ────────────────────────────────────────────
│ Faz: <faz>   Sprint: <NN>   Mod: <mod>   Ölçek: <ölçek>
│ Yığın: <özet>
╰───────────────────────────────────────────────────────────

İLERLEME
  Epic     ████████░░  <a>/<b>
  Story    ██████░░░░  <c>/<d> DONE
  Sprint <NN>  Gün <x>/<y>

SPRINT <NN> — <hedef>
| Story | Sahip | Tip | Durum |
| 004 | backend-developer | Logic | DONE |
| 005 | frontend-developer | UI | Devam ediyor |
| 006 | test-engineer | Integration | Bloke ⚠ |

BLOKE (<n>)
  story-006 — <neden> → <kime escalate edilmeli>

AÇIK KAPI KOŞULLARI (<n>)
  ARCH-DESIGN ŞARTLI — <n> madde açık

RİSKLER (aktif, yüksek)
  | Risk | Olasılık×Etki | Sahip | Önlem |

AÇIK HATALAR
  P0: <a>  P1: <b>  P2: <c>

TEKNİK BORÇ
  <CONTEXT.md'den, en fazla 3 satır>

TOKEN NOTU
  Bu sprintte <N> agent çağrısı, <M> kapı, mod=<mod>.
  <N>30 ise: "Görev paketleri yetersiz — /stories çıktısına ADR özeti ve
  dosya yolları eklenmeli."

▶ SONRAKİ ADIM
  <tek komut> — <tek cümle gerekçe>
```

## 3. Sonraki adım kararı

Öncelik sırası (ilk eşleşen kazanır):

```
1. Bloke story var           → escalation önerisi (hangi role, ne sorulacak)
2. Açık ŞARTLI kapı maddesi  → o maddeleri kapatan komut
3. Açık P0 hata              → /dev-task <düzeltme story>
4. Sprint devam ediyor       → /dev-task <kritik yoldaki sıradaki story>
5. Sprint story'leri bitti   → /dod-check sprint
6. Sprint kapandı            → /retro → /sprint-plan
7. Faz story'leri bitti      → /release <sürüm>
8. Faz kapandı               → /roadmap (sonraki faz) veya /requirements
```

## 4. `/status --deep` modu

Kullanıcı derin analiz isterse `delivery-manager` çağır:

```
<PANO VERİSİ>
Son 2 sprintin story tamamlanma oranı: <veri>
Tahmin vs gerçek: <veri>

Görev: Teslimat sağlığı analizi.
1. Hız (velocity) eğilimi — hızlanıyor mu, yavaşlıyor mu, neden
2. Tahmin doğruluğu — sistematik sapma var mı
3. Darboğaz rolü — hangi agent sürekli kritik yolda
4. Süreç sorunu — tekrar eden bloke nedenleri
5. En fazla 3 somut iyileştirme önerisi
```

Bu mod isteğe bağlıdır ve tek agent çağırır.

## 5. Güncelle

`docs/CONTEXT.md`'nin "Şu an ne yapılıyor" bölümünü panodan güncelle.
`.state/project.json` → `lastUpdated`.

---

## Token notu

- Varsayılan mod **tamamen bedava** — sadece dosya okuma.
- Story dosyalarının **başlık bloklarını** oku (ilk 8 satır), tamamını değil.
- Her oturumun başında `/status` çalıştırmak, sonraki adımların doğru
  bağlamla başlamasını sağlar — dolaylı ama büyük tasarruf.
