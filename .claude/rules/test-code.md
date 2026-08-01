# Test Kod Kuralları

**Kapsam:** `tests/**`, `**/*.test.*`, `**/*.spec.*`, `**/__tests__/**`

---

## Adlandırma

Test adı ne test ettiğini söyler ve kabul kriterine bağlanır:

```
✓ AC-2_stoktan_fazla_siparişte_409_döner
✓ boş_liste_gönderildiğinde_400_ve_alan_hatası_döner
✗ test_order_1
✗ should work
```

Dosya: `tests/<katman>/<alan>/<slug>.test.<ext>`

## Yapı

```
Given (Arrange) → When (Act) → Then (Assert)
```

- Bir test **bir davranışı** doğrular
- Assert olmadan test yoktur. "Hata fırlatmadı" bir assert değildir
- Assert **spesifik** olur: `expect(res.status).toBe(409)` — `toBeTruthy()` değil

## Bağımsızlık

- Testler **sıralamadan etkilenmez**; tek başına da, paralel de çalışır
- Her test kendi verisini kurar ve temizler
- Paylaşılan mutable state yasak
- Global `beforeAll` ile veri kurup testler arası paylaşma

## Determinizm

- `sleep` yerine koşullu bekleme (`waitFor`, polling with timeout)
- Tarih/saat enjekte edilebilir kaynaktan (sabit tarih kullan)
- Rastgelelik sabit tohumla (seed)
- Dış ağ çağrısı **yasak** — mock veya test double
- Kırılgan (flaky) test derhal karantinaya alınır ve nedeni araştırılır.
  **Retry ile gizlenmez**

## Kapsam

Her `AC-N` için en az bir test. Ek olarak sınır durumları:

```
boş / null / undefined
sıfır / negatif / maksimum
tek eleman / çok eleman
eşzamanlı çağrı
tekrar çağrı (idempotency)
geçersiz tip / format
yetkisiz erişim
```

Mutlu yol bir test, sınırlar üç test. Sadece mutlu yol yazan story DONE olmaz.

## Test seviyeleri

| Seviye | Ne test eder | Ne kullanmaz |
|---|---|---|
| Unit | Saf mantık, iş kuralı | Veritabanı, ağ, dosya sistemi |
| Integration | Bileşen etkileşimi, gerçek DB, API sözleşmesi | Dış üçüncü parti servisler |
| E2E | Kritik kullanıcı yolculuğu (≤8 senaryo) | — |

## E2E disiplini

- **En fazla 8 senaryo** — sadece paraya dokunan yolculuklar
- Seçici: `data-testid` veya erişilebilir rol/etiket. CSS sınıfı veya metin **kullanma**
- Her senaryo kendi kullanıcısını ve verisini oluşturur
- E2E'de birim mantık test etme — orası unit testin işi

## Mock kullanımı

- Sahip olduğun kodu mock'lama; sınırları mock'la (dış servis, saat, rastgelelik)
- Aşırı mock'lanmış test, implementasyonu test eder — davranışı değil
- Mock doğrulaması (`toHaveBeenCalledWith`) davranış assert'inin yerini tutmaz

## Test verisi

- Fabrika/builder deseni: `createOrder({status: 'paid'})` — sadece ilgili alanı belirt
- Sihirli değer yerine anlamlı isim: `EXPIRED_TOKEN`, `MAX_QUANTITY`
- Fixture'lar testin yanında yaşar, uzak bir klasörde değil

## Yasaklar

- Commit'lenmiş `skip` / `only` / `xit` / `fdescribe`
- Assert'i yorum satırına alınmış test
- Testi geçirmek için assert gevşetmek
- Üretim verisi kullanmak
- Testte `console.log` bırakmak
- Zaman aşımı süresini "geçsin diye" artırmak (kök nedeni bul)
