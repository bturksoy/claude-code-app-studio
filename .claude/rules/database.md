# Veritabanı Kuralları

**Kapsam:** `db/**`, `**/migrations/**`, `**/*.sql`, `**/entities/**`, `**/models/**`

---

## İsimlendirme

| Nesne | Kural | Örnek |
|---|---|---|
| Tablo | çoğul, snake_case | `order_items` |
| Sütun | tekil, snake_case | `unit_price` |
| Birincil anahtar | `id` | `id` |
| Yabancı anahtar | `<tekil>_id` | `order_id` |
| Index | `ix_<tablo>_<sütunlar>` | `ix_orders_customer_id_created_at` |
| Benzersiz | `uq_<tablo>_<sütunlar>` | `uq_users_email` |
| Kontrol | `ck_<tablo>_<kural>` | `ck_orders_total_positive` |
| Yabancı anahtar kısıtı | `fk_<tablo>_<hedef>` | `fk_order_items_order` |
| Migration | `NNNN_<snake_ad>.sql` | `0012_add_user_roles.sql` |

Kısaltma kullanma (`usr`, `ord` yasak). Rezerve kelime kullanma.

## Zorunlu sütunlar

Her tabloda:
```sql
id           <uuid|bigint>  PRIMARY KEY
created_at   timestamptz    NOT NULL DEFAULT now()
updated_at   timestamptz    NOT NULL DEFAULT now()
```
Soft delete kullanılıyorsa `deleted_at timestamptz NULL` + kısmi index.

## Kısıtlar

**Kısıt > uygulama kodu.** Veritabanı bozuk veri kabul etmemeli.

- `NOT NULL` varsayılan; nullable olması gerekçe ister
- Her yabancı anahtar `ON DELETE` davranışıyla tanımlı (`RESTRICT` varsayılan)
- İş anahtarları `UNIQUE` kısıtla korunur
- Değer aralıkları `CHECK` ile korunur (`ck_orders_total_positive`)
- Enum: az değişen ve kodda bilinen → DB enum/CHECK; iş tarafından yönetilen → referans tablosu

## Tipler

- Para: `numeric(precision, scale)` veya minor-unit `bigint` — `float`/`real` **yasak**
- Zaman: `timestamptz` (UTC). `timestamp` (tz'siz) yasak
- Metin: `text` + `CHECK (length(...))` — keyfi `varchar(255)` yerine gerçek sınır
- Boolean: `boolean`, nullable değil (varsayılan ver)
- JSON: `jsonb`; ama sorgulanacak alan JSON'da yaşamaz, sütun olur

## Index

Her index bir sorguya bağlı ve gerekçesi yazılı:

```sql
-- Sorgu: müşteriye göre siparişler, tarih sıralı (REQ-ORD-004)
-- Öncesi: Seq Scan 340ms → Sonrası: Index Scan 12ms
CREATE INDEX CONCURRENTLY ix_orders_customer_id_created_at
  ON orders (customer_id, created_at DESC);
```

- Yabancı anahtarlar index'lenir (silme ve join performansı)
- Bileşik index'te sütun sırası: eşitlik → aralık → sıralama
- Gereksiz index yazma maliyetidir; kullanılmayanları temizle

## Migration

- Her migration `-- +up` ve `-- +down` bölümlerine sahip
- **Uygulanmış migration düzenlenmez** — yeni migration yazılır
- Şema değişikliği ve veri değişikliği **ayrı dosyalarda**
- Çalışan sistemde güvenli sıra:
  ```
  1. Nullable sütun ekle
  2. Veriyi doldur (ayrı migration)
  3. NOT NULL kısıtı ekle
  4. Eski sütunu kaldır (bir sonraki sürümde)
  ```
- Tek migration'da sütun yeniden adlandırma yapma — iki sürüme yay
- Büyük tabloda `CREATE INDEX CONCURRENTLY`; `ALTER TABLE`'ın tablo yeniden yazıp
  yazmadığını kontrol et
- Migration DONE olmadan önce `up → down → up` test edilir

## Sorgu

- `SELECT *` yasak — sütunları açıkça yaz
- Sınırsız sonuç kümesi yasak — `LIMIT` zorunlu
- İş mantığı SQL'de değil, domain katmanında (basit türetmeler hariç)
- Trigger son çare; kullanılıyorsa ADR gerekir
- Saklı yordam (stored procedure) ADR gerektirir

## Yasaklar

- `DROP TABLE` / `DROP DATABASE` / `TRUNCATE` önermek veya çalıştırmak
- Üretim veritabanında doğrudan `UPDATE`/`DELETE` (migration veya runbook üzerinden)
- Kişisel veriyi index'te veya log'da açık tutmak
- Kısıt olmadan "uygulama zaten kontrol ediyor" demek
