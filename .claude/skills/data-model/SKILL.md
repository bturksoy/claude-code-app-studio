---
name: data-model
description: Veri modelini tasarlar — ER diyagramı, tablo şeması, kısıtlar, index'ler ve migration planı. Veri sözlüğünü kanonik kaynak alır. db/schema.sql ve docs/data/ER.md üretir.
---

# /data-model [kapsam]

Sahip: `sql-developer`, danışan: `solution-architect`.
Çıktı: `docs/data/ER.md`, `db/schema.sql`, `db/migrations/NNNN_*.sql`

---

## 1. Girdi

- `product/requirements/data-dictionary.md` — **kanonik terim kaynağı**
- İlgili REQ'lerin veri ile ilgili kısımları
- `docs/architecture/ARCHITECTURE.md` — veritabanı seçimi, işlem sınırları
- Mevcut `db/schema.sql` ve son migration numarası

## 2. `sql-developer` çağır

```
Veritabanı: <seçim + sürüm>
Veri sözlüğü: <terim tablosu — tam>
İlgili gereksinimler: <REQ ID + veri ile ilgili davranış özeti>
Mevcut şema: <tablo + sütun listesi, DDL değil>
Son migration: <numara>
İşlem sınırları: <mimariden>

Görev: Veri modelini üret.

1. ER diyagramı (Mermaid erDiagram) — ilişki kardinaliteleri doğru
2. Her tablo için:
   - Amaç (tek cümle)
   - Sütunlar: ad, tip, null, varsayılan, açıklama
   - Birincil anahtar, yabancı anahtarlar (ON DELETE davranışıyla)
   - Benzersizlik kısıtları (iş anahtarları)
   - CHECK kısıtları (iş kurallarının veritabanı karşılığı)
   - Silme stratejisi: hard / soft (deleted_at) / arşiv
3. Index'ler — her biri için hangi sorguyu hızlandırdığı YAZILI
4. Migration dosyaları: NNNN_<ad>.sql, her biri -- +up / -- +down bölümlü
5. Tam schema.sql (migration sonrası hedef durum)
6. Denormalizasyon yaptıysan gerekçe + ADR gerekiyor mu

Zorunlu kurallar:
- İsimlendirme: tablo çoğul snake_case, FK <tekil>_id, index ix_/uq_/ck_/fk_
- created_at, updated_at her tabloda timestamptz (UTC)
- Para: numeric veya minor-unit bigint — float YASAK
- Kısıt > uygulama kodu: veritabanı bozuk veri kabul etmemeli
- Veri sözlüğündeki terimleri kullan; yeni terim uydurma
- Çalışan sistemde güvenli migration sırası (nullable ekle → doldur → kısıt → eski sil)
```

## 3. `solution-architect` çapraz kontrolü (full mod)

```
<ER ÖZETİ: tablolar, ilişkiler, kritik kısıtlar>

Görev: Bu model mimariye uyuyor mu?
1. İşlem (transaction) sınırları model ile uyumlu mu
2. Modül sınırları ile tablo sahipliği çelişiyor mu
3. Sorgu desenleri N+1 veya karmaşık join'e zorluyor mu
4. Ölçek NFR'i bu modelde tutar mı
En fazla 10 satır. "ONAY|ŞARTLI|RET" ile başla.
```

## 4. Doğrulama

Migration dosyalarını gerçekten çalıştırabiliyorsan (yerel veritabanı varsa):
`up → down → up` sırasıyla test et ve çıktıyı raporla.
Çalıştıramıyorsan bunu **açıkça belirt** — "test edilmedi" yaz, "çalışır" deme.

## 5. Sun

```
## Veri Modeli
Tablolar: <N> | İlişkiler: <M> | Index: <K>

| Tablo | Amaç | Satır tahmini | Silme stratejisi |

Migration: <dosyalar>
Kısıtlar: <önemli CHECK/UNIQUE listesi>
⚠ Veri sözlüğünde olmayan yeni terim: <varsa>
```

`AskUserQuestion` ile onay al.

## 6. Yaz

- `docs/data/ER.md`, `db/schema.sql`, `db/migrations/*.sql`
- Veri sözlüğüne yeni terim eklendiyse **`business-analyst`'e öneri** olarak raporla
  (sen data-dictionary.md'yi değiştirmezsin — sahibi BA)
- `docs/DECISIONS.md`'ye model kararı satırı

## 7. Kapat

```
✓ Veri modeli → docs/data/ER.md + db/schema.sql
  <N> tablo | <M> migration | up/down test: <sonuç>

▶ Sonraki: /api-contract (yapılmadıysa) veya /epics
```

---

## Token notu

- Veri sözlüğü **tam** gömülür (kısa ve kritik). REQ'ler sadece veri ile ilgili özet.
- Mevcut şema DDL olarak değil, **tablo+sütun listesi** olarak gömülür.
- `solution-architect` çapraz kontrolü sadece `full` modda.
