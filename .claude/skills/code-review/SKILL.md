---
name: code-review
description: Bağımsız kod incelemesi yapar. Doğruluk, güvenlik, kapsam sadakati, kural uyumu, okunabilirlik ve test kalitesi eksenlerinde bulgu üretir. CR-CODE kapısını işletir.
---

# /code-review [kapsam]

Sahip: `code-reviewer`. Kod yazmaz, bulgu raporlar.

Kapsam argümanı: story yolu, dosya listesi, epic slug veya boş (→ çalışma dizinindeki
değişiklikler / `git diff`).

---

## 1. Kapsamı topla

- Git repo ise: `git diff` (staged + unstaged) veya `git diff <base>..HEAD`
- Değilse: verilen dosya listesini oku
- İlgili story dosyasını bul (varsa) — kabul kriterleri ve kapsam sınırı için
- Dokunulan yollara göre ilgili `.claude/rules/*.md` dosyalarını seç

Diff 1500 satırı aşıyorsa **böl** ve iki turda incele; ya da kullanıcıya sor:
> "<N> satır değişmiş. Tümünü mü inceleyeyim, yoksa en riskli dosyaları mı?"

## 2. `code-reviewer` çağır

```
<DIFF veya DOSYA İÇERİKLERİ>

<STORY BAĞLAMI (varsa):
  kabul kriterleri, iş kuralları, kapsam DIŞI bölümü>

<İLGİLİ KURALLAR: .claude/rules/<dosya> içeriği>

Görev: CR-CODE kapısı.

İnceleme sırası (üstteki daha önemli):
1. Doğruluk — AC'ler karşılanıyor mu, sınır durumları, hata yolları,
   eşzamanlılık, null/off-by-one
2. Güvenlik — yetkilendirme, kaynak sahipliği (IDOR), girdi doğrulama,
   enjeksiyon, gizli veri sızıntısı
3. Kapsam sadakati — "Kapsam DIŞI" işleri yapılmış mı, ilgisiz refactor var mı
4. Kural uyumu — verilen rules dosyasındaki maddeler
5. Okunabilirlik/bakım — isimlendirme, tek sorumluluk, sihirli değer, ölü kod
6. Test kalitesi — her AC için test var mı, gerçekten assert ediyor mu,
   sınır durumları test edilmiş mi, skip/only kalmış mı

Bulgu formatı:
[BLOKE|ÖNEMLİ|ÖNERİ|NOT] <dosya:satır> — <tek cümle iddia + neden + hangi AC/kural>

YAZMA: stil tercihi, "daha güzel olurdu", övgü paragrafı,
aynı sorunun tekrarı (bir kez yaz, "N yerde" de).
En fazla 15 bulgu; fazlaysa en kritik 15'i ver.

Yanıtına "CR-CODE: ONAY|ŞARTLI|RET" satırıyla başla.
ONAY = BLOKE ve ÖNEMLİ yok. ŞARTLI = ÖNEMLİ var. RET = BLOKE var.
```

## 3. Sun

```
## Kod İncelemesi — <kapsam>
Verdikt: CR-CODE <verdikt>
Kapsam: <N> dosya, <M> satır

BLOKE (<a>)
  <dosya:satır> — <iddia>
ÖNEMLİ (<b>)
  ...
ÖNERİ (<c>)
  ...
NOT (<d>)
  ...
```

## 4. Düzeltme akışı

`AskUserQuestion`:
- `BLOKE + ÖNEMLİ bulguları düzelt (Önerilen)`
- `Sadece BLOKE olanları düzelt`
- `Ben düzelteceğim`

Düzeltme seçilirse ilgili geliştirici agent'a **tek turda** gönder:

```
Aşağıdaki bulguları düzelt. Sadece bunları — başka değişiklik yapma.
<bulgu listesi>
Düzeltme sonrası ilgili testleri çalıştır ve sonucu bildir.
```

`RET` verdiktinde düzeltme sonrası kapıyı **bir kez daha** çağır.
`ŞARTLI` verdiktinde tekrar çağırma.

## 5. Kaydet

`.state/gates.jsonl` → CR-CODE satırı.
Düzeltilmeyen `ÖNEMLİ` bulgular varsa `product/risks.md`'ye teknik borç olarak ekle.

---

## Token notu

- **1 agent çağrısı** + en fazla 1 düzeltme turu + (RET ise) 1 doğrulama turu.
- Kural dosyaları gömülür (sabit içerik → prompt cache dostu).
- Büyük diff'i bölmek, tek seferde göndermekten ucuzdur (bağlam taşması olmaz).
- Birden fazla story incelenecekse **tek çağrıda** birleştir.
