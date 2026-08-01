# Story <NNN>: <başlık>

> **Epic:** <ad> | **Tip:** <Logic|Integration|Data|UI|Infra|Config> | **Sahip:** <agent>
> **Durum:** Hazır | **Tahmin:** <XS/S/M/L> | **Sprint:** — | **Güncellenme:** <YYYY-MM-DD>

## Ne yapılacak

<2-3 cümle. Geliştiricinin ilk okuyacağı şey. Somut ve teknik.>

## Kabul kriterleri

*Kaynak: REQ-<ID> — buraya kopyalandı, referans değil*

- [ ] **AC-1:** <kriter>
  - Given: <önkoşul>
  - When: <eylem>
  - Then: <gözlemlenebilir sonuç>
- [ ] **AC-2:** <kriter>
  - Given: <...>
  - When: <...>
  - Then: <...>

## İş kuralları

*Kaynak: REQ-<ID> — kopyalandı*

- **BR-1:** <kural>
- **BR-2:** <kural>

## Hata ve sınır durumları

| Durum | Beklenen davranış | Kullanıcıya mesaj |
|---|---|---|
| | | |

## Uygulanacak mimari kararlar

*ADR-<NNNN>: <başlık>*

<ADR'nin "Uygulama rehberi" bölümü buraya kopyalanır.
Geliştirici ADR dosyasını açmayacak.>

**Zorunlu desen:** <...>
**Yasak desen:** <...>

## Sözleşme

*İlgili endpoint / tablo / komponent tanımları — kopyalandı*

```yaml
# openapi.yaml'dan ilgili bölüm
```

```sql
-- ER.md / schema.sql'den ilgili tablo
```

## Dokunulacak dosyalar

*Tespit edilmiş yollar — tahmin değil*

- `<yol>` — <ne yapılacak>
- `<test yolu>` — yeni

## Kapsam DIŞI

*Komşu story'ler halleder — burada yapma*

- Story <NNN+1>: <ne>

## Test senaryoları

*QA Lead tarafından yazıldı. Sıfırdan test icat etme.*

**TC-<REQ>-01** — AC-1
- Given: <...> | When: <...> | Then: <...>
- Sınır durumları: <...>
- Öncelik: P0

## Zorunlu kanıt

**Tip:** <tip>
**Gereken:** <DoD'den tipin zorunlu kanıtı>
**Dosya:** `tests/<yol>/<slug>.test.<ext>`
**Durum:** [ ] Henüz oluşturulmadı

## Bağımlılıklar

**Önce bitmeli:** <story-NNN veya Yok>
**Bunu bekliyor:** <story-NNN veya Yok>

## İzlenebilirlik

REQ-<ID> → GOAL-<NN> | ADR-<NNNN> | Ekran: <varsa>
