---
name: bug
description: Hata kaydı oluşturur ve triage yapar — öncelik, sahip, kök neden hipotezi ve regresyon testi planı. Argümansız çalışırsa açık hataları önceliklendirir.
---

# /bug ["<açıklama>" | triage]

Sahip: `test-engineer`, önceliklendirme: `qa-lead` (P0/P1 için).

---

## Mod A — Yeni hata kaydı: `/bug "<açıklama>"`

### 1. Bilgi topla

`AskUserQuestion` ile eksikleri sor (tek turda):
- **Nerede görüldü:** `Yerel geliştirme` / `Test ortamı` / `Staging` / `Üretim`
- **Ne sıklıkla:** `Her seferinde` / `Bazen` / `Bir kez gördüm`
- **Etki:** `Veri kaybı/güvenlik` / `Ana akış çalışmıyor` / `İkincil akış` / `Kozmetik`

### 2. Numara ve bağlam

`docs/qa/bugs/` içindeki en büyük numarayı bul, +1.
Grep ile ilgili REQ ve story'yi bul (hata açıklamasındaki anahtar kelimelerle).

### 3. `test-engineer` çağır

```
Hata açıklaması: <argüman>
Ortam: <cevap> | Sıklık: <cevap> | Etki: <cevap>
İlgili REQ/story: <bulunanlar>
İlgili kod: <Grep ile bulunan ilgili bölüm>

Görev: BUG-<NNN> kaydı üret.
1. Tek cümlelik başlık — GÖZLENEN davranış (yorum değil)
2. Yeniden üretme adımları — numaralı, kesin, önkoşullarla
3. Beklenen vs gözlenen
4. Kök neden hipotezi (en fazla 2) + her biri nasıl doğrulanır
5. Kapsam: kaç kullanıcı/senaryo etkilenir, geçici çözüm var mı
6. Öncelik önerisi (P0-P3) + gerekçe
7. Regresyon testi: düzeltmeden sonra eklenecek testin adı ve ne assert edeceği
8. Sahip önerisi (hangi geliştirici rolü)
```

### 4. P0/P1 ise `qa-lead` onayı

```
<BUG kaydı>
Görev: Öncelik doğru mu? P0 sprint'i durdurur — emin misin?
Tek satırda: "Öncelik: P<n> — <gerekçe>"
```

### 5. Yaz

`docs/qa/bugs/BUG-NNN.md` (format: `test-engineer.md` içindeki şablon)
`.state/project.json` → `counters.bugs++`

P0 ise: `delivery-manager`'a bildir, mevcut sprint planına acil satır eklenmeli.

---

## Mod B — Triage: `/bug triage`

### 1. Açık hataları topla

`docs/qa/bugs/` içindeki `Durum: Açık|Doğrulandı` olanları oku (başlık blokları).

### 2. `qa-lead` çağır

```
Açık hatalar:
| ID | Başlık | Mevcut öncelik | Ortam | Etki | Yaş |

Mevcut sprint hedefi: <hedef>
Kalan kapasite: <bilgi>

Görev: Triage.
1. Öncelikleri gözden geçir — yanlış olanları düzelt ve gerekçelendir
2. Bu sprintte düzeltilecekler (P0 + P1)
3. Backlog'a gidecekler (P2) — hangi sprint
4. Kapatılacaklar (P3, tekrar, geçersiz) — gerekçeli
5. Küme tespiti: aynı kök nedene işaret eden hatalar var mı
   (varsa tek düzeltme çoğunu kapatır — bunu belirt)
```

### 3. Sun ve uygula

```
## Hata Triage — <N> açık hata
P0: <a> | P1: <b> | P2: <c> | P3: <d>

Bu sprintte: BUG-021, BUG-023
Backlog'a: BUG-019, BUG-020
Kapatılacak: BUG-015 (tekrar — BUG-012 ile aynı)

Küme tespiti: BUG-021 ve BUG-023 aynı kök nedene işaret ediyor
  → tek düzeltme ikisini de kapatabilir
```

`AskUserQuestion` ile onayla, hata dosyalarının durumlarını güncelle,
sprint'e alınacaklar için `delivery-manager`'a bildir.

---

## Token notu

- Yeni kayıt: **1-2 agent çağrısı**. Triage: **1 çağrı**.
- Triage'da hata dosyalarının **başlık bloklarını** gömme, tam içeriği değil.
- Küme tespiti tek düzeltmeyle çok hata kapatır — en verimli QA hamlesidir.
