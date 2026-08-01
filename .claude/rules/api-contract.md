# API Sözleşme Kuralları

**Kapsam:** `docs/api/**`, `**/openapi.y*ml`, `**/*.proto`, `docs/api/events.md`

**Sahip:** `solution-architect`. Bu dosyalar **tek taraflı değiştirilemez** —
frontend ve backend geliştiricileri tüketir, üretmez.

---

## Yol tasarımı

- Kaynak odaklı, çoğul isim: `/orders`, `/orders/{id}`, `/orders/{id}/items`
- Fiil kullanma: `/getOrders`, `/createOrder` **yasak**
- İç içe derinlik en fazla 2 seviye
- Küçük harf, tire ile ayır: `/purchase-orders`
- Eylem gerçekten kaynak değilse alt kaynak olarak modelle:
  `POST /orders/{id}/cancellation`

## Durum kodları

| Kod | Ne zaman |
|---|---|
| 200 | Başarılı okuma/güncelleme |
| 201 | Oluşturma (+ `Location` başlığı) |
| 204 | Başarılı, gövde yok (silme) |
| 400 | Geçersiz istek yapısı |
| 401 | Kimlik doğrulanmamış |
| 403 | Kimlik var, yetki yok |
| 404 | Kaynak yok (veya yetkisiz — sızıntı önleme) |
| 409 | Çakışma (benzersizlik, durum ihlali) |
| 422 | Yapı geçerli, iş kuralı ihlali |
| 429 | Hız sınırı |
| 5xx | Sunucu hatası (detay sızdırmaz) |

Her endpoint'te hangi kodların dönebileceği **açıkça tanımlı**.

## Hata gövdesi — RFC 7807

**Tek tip**, `components/responses` altında tanımlı, her endpoint referans verir:

```json
{
  "type": "https://example.com/errors/insufficient-stock",
  "title": "Yetersiz stok",
  "status": 409,
  "detail": "Ürün SKU-123 için 5 adet istendi, 2 adet mevcut.",
  "instance": "/orders/9f3a",
  "errors": [{"field": "items[0].quantity", "message": "En fazla 2"}]
}
```

İç detay (stack trace, SQL, dosya yolu) **asla** dönmez.

## Yanıt zarfı

Tutarlı, endpoint'e göre değişmez:

```json
{ "data": {...}, "meta": {...} }
```

Liste yanıtları: `{"data": [...], "meta": {"cursor": "...", "hasMore": true}}`

## Sayfalama, sıralama, filtreleme

- **Tek desen** seç (cursor veya offset), hepsinde kullan
- Varsayılan limit tanımlı, maksimum limit zorunlu
- Sıralama: `?sort=created_at:desc` — tek format
- Filtreleme: `?status=paid&created_after=2026-01-01` — tutarlı adlandırma
- Sınırsız sonuç kümesi **yasak**

## Yetkilendirme

- `securitySchemes` tanımlı
- Her endpoint'te `security` belirtilmiş
- Public endpoint'ler açıkça `security: []` — unutulmuş sayılmasın

## Idempotency

Yazma işlemleri tekrarlanabilir olmalı:
- `Idempotency-Key` başlığı (POST için), veya
- Doğal anahtar üzerinden çakışma tespiti (409)

## Şemalar

- Tüm şemalar `components/schemas` altında, tekrar yok
- Her alan: tip, format, örnek, zorunluluk, kısıt (min/max/pattern/enum)
- Tarih: `format: date-time` (ISO 8601, UTC)
- Para: minor-unit `integer` + ayrı `currency` alanı, veya `string` decimal
- Kimlik: `format: uuid` veya açıkça belirtilmiş

## İzlenebilirlik

Her endpoint bir gereksinime bağlı:
```yaml
paths:
  /orders:
    post:
      x-requirement: REQ-ORD-003
```

## Sürümleme ve değişim

| Değişim | Kırıcı mı | Yapılabilir mi |
|---|---|---|
| Yeni opsiyonel alan (yanıt) | Hayır | ✓ |
| Yeni opsiyonel parametre | Hayır | ✓ |
| Yeni endpoint | Hayır | ✓ |
| Alan kaldırma | **Evet** | Yeni sürüm + geçiş |
| Alan yeniden adlandırma | **Evet** | Yeni sürüm + geçiş |
| Tip değiştirme | **Evet** | Yeni sürüm + geçiş |
| Zorunlu parametre ekleme | **Evet** | Yeni sürüm + geçiş |
| Durum kodu değiştirme | **Evet** | Yeni sürüm + geçiş |

Kırıcı değişiklik: yeni sürüm, paralel yayın süresi, kullanımdan kaldırma duyurusu,
geçiş rehberi. Sürümleme stratejisi bir ADR'de kayıtlı.

## Event sözleşmeleri (`docs/api/events.md`)

- Her event: ad, sürüm, yayınlayan, tetikleyici, anahtar, sıra garantisi, alan tablosu
- Alan **silme veya yeniden adlandırma yasak** — yeni alan eklenir, eskisi deprecate
- Tekilleştirme için `event_id`, zaman için `occurred_at` zorunlu
- Teslimat semantiği belirtilir (at-least-once → tüketici idempotent olmalı)

## Yasaklar

- Geliştiricinin sözleşmeyi tek taraflı değiştirmesi
- Aynı kavram için iki farklı şema adı
- Endpoint'e özel hata formatı
- Dokümante edilmemiş alan döndürmek
- Sözleşme ile implementasyon arasında sessiz farklılık
