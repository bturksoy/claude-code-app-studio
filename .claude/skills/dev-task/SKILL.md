---
name: dev-task
description: Tek bir story'yi uçtan uca implement eder. Hazırlık kontrolü yapar, doğru geliştirici agent'ı çağırır, testleri çalıştırır, kod incelemesi alır ve story'yi günceller. Ana geliştirme döngüsü.
---

# /dev-task <story-yolu>

Çıktı: kod + testler + güncellenmiş story dosyası.

---

## 1. Story'yi yükle ve hazırlık kontrolü

Argüman yoksa mevcut sprintten sıradaki story'yi öner (kritik yol önceliği).

Story dosyasını oku. **Hazırlık kontrolü** (agent çağırmadan):

```
[ ] Durum "Hazır" mı? (Bloke ise nedenini göster ve dur)
[ ] Kabul kriterleri var mı ve Given/When/Then formatında mı?
[ ] "Uygulanacak mimari kararlar" bölümü dolu mu (veya "N/A — <neden>")?
[ ] "Sözleşme" bölümü dolu mu (API/tablo gerektiren tipler için)?
[ ] "Dokunulacak dosyalar" listesi var mı?
[ ] "Test senaryoları" bölümü dolu mu (Logic/Integration için)?
[ ] Bağımlı story'ler DONE mı?
```

Eksik varsa **dur**:
```
⚠ Story hazır değil: <eksik maddeler>
Düzeltme: /stories <epic> tekrar çalıştır veya story'yi elle tamamla.
Yine de devam etmek istersen geliştirici agent ek dosya okumak zorunda kalacak
(daha yüksek token maliyeti ve hata riski).
```
`AskUserQuestion` ile: `Story'yi düzelt (Önerilen)` / `Yine de devam et`

Bağımlı story DONE değilse **kesinlikle dur** — sırayı bozma.

## 2. Doğru agent'ı seç

Story'nin `Sahip` alanı belirler. Eşleşme yoksa tipten türet:

| Tip / içerik | Agent |
|---|---|
| UI, ekran, komponent | `frontend-developer` |
| Logic/Integration, endpoint, iş kuralı | `backend-developer` |
| Data, şema, migration, index | `sql-developer` |
| Infra, pipeline, ortam | `devops-engineer` |
| ETL, rapor, event | `data-engineer` |
| Test otomasyonu | `test-engineer` |

## 3. Geliştirici agent'ı çağır

**Story dosyasının TAMAMINI prompt'a göm.** Dosya yolu verip okutma —
görev paketi zaten kendi kendine yeterli olacak şekilde yazıldı.

```
<STORY DOSYASININ TAM İÇERİĞİ>

Ek bağlam:
- Proje yığını: <stack özeti>
- Uygulanacak kod kuralları: .claude/rules/<ilgili>.md
  <ilgili kural dosyasının içeriği de gömülür — 40 satırlık bir dosya>

Görev: Bu story'yi implement et.

1. Kabul kriterlerini kontrol listesine çevir
2. "Dokunulacak dosyalar" listesindeki dosyalarla çalış.
   Liste eksikse Grep ile hedefli ara — dizin taraması YAPMA.
3. Benzer mevcut kod varsa genişlet, kopyalayıp yapıştırma
4. "Test senaryoları" bölümündeki TC'lere karşı test yaz.
   Sıfırdan test icat etme.
5. Testleri ÇALIŞTIR ve çıktıyı gör. "Geçmesi gerekir" deme.
6. "Kapsam DIŞI" bölümündeki işleri YAPMA.

Çıktı formatı:
VERDİKT: TAMAMLANDI | BLOKE
ÖZET: <3 cümle>
DOSYALAR: <yollar>
TESTLER: <komut> → <geçen/toplam>
KABUL KRİTERLERİ: AC-1 ✓ | AC-2 ✓ | AC-3 ✗ <neden>
NOT: <kapsam dışı gözlemler — DÜZELTME, sadece raporla>
SONRAKİ ADIM: <tek satır>
```

`BLOKE` dönerse: nedeni sınıflandır, ilgili role escalate et
(`.claude/docs/coordination-rules.md` §3), kullanıcıya bildir, dur.

## 4. Kod incelemesi (lean+ mod)

`code-reviewer` çağır:

```
<DEĞİŞEN DOSYALARIN İÇERİĞİ veya git diff>
<STORY'NİN kabul kriterleri + iş kuralları + kapsam dışı bölümü>
<İLGİLİ .claude/rules/*.md içeriği>

Görev: CR-CODE kapısı. İnceleme sırası: doğruluk → güvenlik → kapsam sadakati
→ kural uyumu → okunabilirlik → test kalitesi.

Her bulgu: [BLOKE|ÖNEMLİ|ÖNERİ|NOT] <dosya:satır> — <tek cümle iddia + neden>
En fazla 15 bulgu. Stil tercihi yazma.
Yanıtına "CR-CODE: ONAY|ŞARTLI|RET" satırıyla başla.
```

| Verdikt | Aksiyon |
|---|---|
| `ONAY` | Adım 5'e geç |
| `ŞARTLI` | ÖNEMLİ bulguları geliştiriciye **tek turda** gönder, düzelttir, kapıyı tekrar çağırma |
| `RET` | BLOKE bulguları geliştiriciye gönder, düzelttir, **kapıyı bir kez daha çağır** |

`solo` modda bu adımı atla.

## 5. Story'yi güncelle

- Kabul kriteri checkbox'larını işaretle
- `**Durum:**` → `İncelemede` (DoD henüz geçilmedi)
- `## Zorunlu kanıt` bölümüne test dosyası yolu ve sonucu yaz
- `**Güncellenme:**` tarihi

## 6. Sun

```
✓ Story <NNN>: <başlık>
  Sahip: <agent> | Tip: <tip>

Dosyalar: <N> değişti, <M> yeni
Testler: <geçen>/<toplam> ✓
Kabul kriterleri: <X>/<Y> ✓
Kod incelemesi: CR-CODE <verdikt> (<a> bulgu düzeltildi)

NOT (kapsam dışı gözlemler):
- <geliştiricinin raporladığı>

▶ Sonraki: /dod-check <story-yolu>
   veya doğrudan sıradaki story: /dev-task <yol>
```

Kapsam dışı gözlemler varsa kullanıcıya sor: bunlar backlog'a story olarak
eklensin mi?

---

## Token notu — bu skill neden ucuz olmalı

- **1-2 agent çağrısı** (geliştirici + [lean+: inceleyici]).
- Geliştirici agent **hiçbir dokümantasyon dosyası okumaz** — hepsi story'de gömülü.
- Kural dosyası da gömülür (40 satır, prompt cache dostu, sabit).
- Hazırlık kontrolü bedava ve **geri dönüşleri önler** — en büyük tasarruf budur.
- Bir story'de 3'ten fazla tur olursa bu bir görev paketi kalitesi sorunudur;
  `delivery-manager`'a raporla, aynı hatayı bir sonraki `/stories` çağrısında düzelt.
