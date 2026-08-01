# BUG-<NNN>: <tek cümle — gözlenen davranış, yorum değil>

**Öncelik:** P0 | P1 | P2 | P3
**Durum:** Açık | Doğrulandı | Düzeltiliyor | Düzeltildi | Kapandı
**Bulunduğu ortam:** <local | test | staging | prod>
**Sürüm/build:** <...>
**İlgili:** REQ-<ID> / story-<NNN>
**Sahip:** <agent>
**Tarih:** <YYYY-MM-DD>

## Yeniden üretme adımları

1. <önkoşul: hangi kullanıcı, hangi veri>
2. <adım>
3. <adım>

**Sıklık:** Her seferinde | Bazen (<n>/10) | Bir kez görüldü

## Beklenen

<Ne olmalıydı — kaynak: REQ-<ID> AC-<N>>

## Gözlenen

<Ne oldu>

## Kanıt

```
<log satırı, hata mesajı, test çıktısı>
```

## Kapsam ve etki

- **Etkilenen kullanıcı/senaryo:** <...>
- **Veri bozulması var mı:** <evet/hayır>
- **Geçici çözüm:** <var — nasıl | yok>

## Kök neden

<Doğrulandıktan sonra doldurulur>

## Düzeltme

<Ne değişti, hangi dosyalar>

## Regresyon testi

**Dosya:** `tests/<yol>/<slug>.test.<ext>`
**Ne assert ediyor:** <...>
**Durum:** [ ] Yazıldı ve önce başarısız oldu, sonra geçti

## Önleme

<Bu sınıf hata neden yakalanmadı — test/inceleme/izleme boşluğu.
Takip story'si açıldı mı?>
