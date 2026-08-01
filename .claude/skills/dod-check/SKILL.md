---
name: dod-check
description: Bir story, sprint veya sürümün Definition of Done kriterlerini kanıta dayalı olarak denetler. "Bitti" kararının verildiği kapı. QA-DONE kapısını işletir.
---

# /dod-check [story-yolu | sprint | release]

Sahip: `qa-lead`. Kanıtsız ONAY verilmez.

---

## 1. Kapsamı belirle

| Argüman | Kapsam |
|---|---|
| story yolu | Tek story DoD |
| `sprint` | Mevcut sprintin tüm story'leri + sprint DoD |
| `release` | Sürüm kapsamı + sürüm DoD |
| yok | Mevcut sprintte `İncelemede` olan story'ler |

## 2. Kanıt topla (agent çağırmadan — bu ucuz kısım)

Story için:
- Story dosyası: kabul kriteri checkbox'ları, `Zorunlu kanıt` bölümü, tip
- Belirtilen test dosyası **gerçekten var mı** (Glob)
- Testleri **çalıştır** (Bash) ve çıktıyı al — iddiaya güvenme
- Kod incelemesi verdikti (`.state/gates.jsonl`)
- `Kapsam DIŞI` bölümündeki işlerin yapılıp yapılmadığı (git diff ile kontrol)

Sprint/release için ek olarak: regresyon paketi sonucu, açık ŞARTLI kapı maddeleri,
açık P0/P1 hatalar.

## 3. `qa-lead` çağır

```
Kapsam: <story/sprint/release>

<STORY BİLGİSİ: başlık, tip, kabul kriterleri ve işaretli durumları,
 iş kuralları, kapsam dışı bölümü>

TOPLANAN KANIT:
- Test dosyası: <yol> — var/yok
- Test çalıştırma çıktısı:
  <gerçek komut çıktısı — kırpma, olduğu gibi ver>
- Kod incelemesi: CR-CODE <verdikt>, <a> bulgu düzeltildi
- Değişen dosyalar: <liste>
- Kapsam dışı bölümüne dokunulmuş mu: <evet/hayır — kanıt>

Görev: QA-DONE kapısı.

Kontrol listesi (.claude/docs/definition-of-done.md):
1. Tüm kabul kriterleri işaretli VE her biri bir teste bağlı mı?
   (test adında AC-N geçiyor mu — kontrol et)
2. Story tipinin zorunlu kanıtı mevcut ve GEÇİYOR mu?
3. Hata/sınır senaryoları test edilmiş mi? (sadece mutlu yol → RET)
4. İzlenebilirlik tam mı: test → AC → REQ → GOAL
5. Kapsam dışına taşma var mı?
6. Kod incelemesi kapatılmış mı?

Kanıtı gör, iddiaya güvenme. Test çıktısında başarısız varsa RET.
Yanıtına "QA-DONE: ONAY|ŞARTLI|RET" satırıyla başla.
ŞARTLI ise en fazla 5 uygulanabilir madde listele.
```

## 4. Verdikti işle

| Verdikt | Aksiyon |
|---|---|
| `ONAY` | Story `Durum: DONE`, `.state/project.json` → `counters.done++` |
| `ŞARTLI` | Maddeleri göster, ilgili agent'a düzelttir, **kapıyı tekrar çağırma** — düzeltme sonrası ONAY kabul edilir |
| `RET` | Story `Durum: Hazır`'a döner, eksik listesiyle `delivery-manager`'a bildir |

## 5. Sun

```
## DoD Denetimi — <kapsam>

| Story | Tip | AC | Test | İnceleme | Verdikt |
| 004 | Logic | 3/3 ✓ | 7/7 ✓ | ONAY | ONAY |
| 005 | UI | 2/3 ⚠ | 4/5 ✗ | ŞARTLI | RET |

Kanıt özeti:
  Testler: <geçen>/<toplam>
  Kapsam: <yüzde, varsa>
  Açık bulgu: <n>

RET/ŞARTLI nedenleri:
  story-005: AC-3 için test yok; boş liste senaryosu test edilmemiş

▶ Sonraki: <duruma göre>
```

## 6. Sprint/release modunda ek kontroller

```
Sprint DoD:
[ ] Sprint hedefi karşılandı mı (yoksa sapma gerekçesi)
[ ] Tüm story'ler DONE veya gerekçeli backlog'a döndü
[ ] Regresyon paketi yeşil
[ ] Açık ŞARTLI kapı maddesi yok (.state/gates.jsonl)
[ ] docs/CONTEXT.md güncellendi
[ ] product/risks.md gözden geçirildi

Release DoD: (.claude/docs/definition-of-done.md — Sürüm DoD bölümü)
```

## 7. Kaydet

- `.state/gates.jsonl` → QA-DONE satırı
- Story dosyalarında durum güncellemesi
- `.state/project.json` → sayaçlar
- `docs/CONTEXT.md` → "Şu an ne yapılıyor" (sprint modunda)

---

## Token notu

- **1 agent çağrısı.** Kanıt toplama bedava (dosya okuma + Bash).
- Test çıktısını **kırpmadan** göm — bu kapının tüm değeri kanıtta.
- Birden fazla story denetleniyorsa **tek çağrıda hepsini** gönder,
  story başına ayrı çağrı yapma.
