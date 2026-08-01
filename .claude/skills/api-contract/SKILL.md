---
name: api-contract
description: OpenAPI sözleşmesini üretir veya günceller. Endpoint'ler, şemalar, hata formatı, sayfalama ve yetkilendirme tek yerde tanımlanır. Frontend ve backend bu sözleşmeyi tüketir, değiştiremez.
---

# /api-contract [kapsam]

Sahip: `solution-architect`. Çıktı: `docs/api/openapi.yaml`

Ön koşul: `ARCHITECTURE.md` + `FRD.md`. Kapsam verilmezse Faz 1 REQ'leri.

---

## 1. Kapsam belirle

Argüman: epic slug, REQ listesi veya boş (→ mevcut faz).
Mevcut `openapi.yaml` varsa oku — **ekleme yapılacak**, sıfırdan yazılmayacak.

## 2. `solution-architect` çağır

```
Mevcut sözleşme: <varsa endpoint listesi — tam YAML değil, sadece path+method+özet>
Kapsam: <REQ listesi — ID + başlık + aktör + davranış özeti>
Mimari: <ilgili konteyner ve katman bilgisi>
İlgili ADR'ler: <uygulama rehberi özetleri — auth, sürümleme, hata formatı>
Veri modeli: <ilgili varlıklar ve alanları — ER.md'den>

Görev: OpenAPI 3.1 sözleşmesi üret.

Zorunlu kurallar:
1. Her endpoint `x-requirement: REQ-*` etiketi taşır
2. Kaynak odaklı yollar: /orders, /orders/{id}, /orders/{id}/items
   Fiil kullanma (/getOrders yasak)
3. Durum kodları: 200/201/204, 400, 401, 403, 404, 409, 422, 429, 500
   Her endpoint'te hangilerinin geçerli olduğunu tanımla
4. Hata gövdesi TEK TİP — RFC 7807:
   {type, title, status, detail, instance, errors[]}
   components/responses altında tanımla, her endpoint referans versin
5. Sayfalama TEK DESEN: cursor veya offset — birini seç, hepsinde kullan
   Yanıt zarfı: {data: [...], meta: {...}}
6. Filtreleme ve sıralama parametreleri tutarlı adlandırılır
7. Kimlik doğrulama: securitySchemes tanımlı, her endpoint'te security belirtilmiş
   Public endpoint'ler açıkça `security: []`
8. Yazma işlemleri için idempotency başlığı (uygulanabilirse)
9. Tüm şemalar components/schemas altında, tekrar yok
10. Her alan için: tip, format, örnek, zorunluluk, kısıt (min/max/pattern)
11. Kırıcı değişiklik yapıyorsan BELİRT ve geçiş planı öner

Çıktıyı geçerli YAML olarak ver. Yorum satırlarıyla REQ eşlemesini açıkla.
```

## 3. Tutarlılık denetimi (sen yaparsın, agent çağırmadan)

Üretilen sözleşmeyi şu maddelere karşı kontrol et:
- Her REQ karşılanmış mı → **kapsama tablosu** çıkar
- Hata formatı her endpoint'te aynı mı
- Sayfalama deseni tutarlı mı
- Yetkilendirme her endpoint'te tanımlı mı
- Aynı kavram iki farklı şema adıyla mı geçiyor
- `ER.md` ile alan adları uyumlu mu (uyumsuzsa **veri sözlüğü kazanır**)

Boşluk varsa tek ve kısa bir düzeltme turu gönder.

## 4. Sun

```
## API Sözleşmesi
| REQ | Endpoint | Method | Auth | Durum kodları |

Yeni: <N> endpoint | Değişen: <M> | Kırıcı değişiklik: <var/yok>
⚠ Karşılanmayan REQ: <varsa>
```

Kırıcı değişiklik varsa `AskUserQuestion` ile açıkça onay al ve geçiş planını göster.

## 5. Yaz ve dağıt

- `docs/api/openapi.yaml`
- Değişiklik özetini `docs/DECISIONS.md`'ye tek satır
- **Bildirim:** sözleşme değiştiyse `frontend-developer` ve `backend-developer`
  sahipli açık story'ler etkilenir — raporda listele

## 6. Kapat

```
✓ Sözleşme güncellendi → docs/api/openapi.yaml
  <N> endpoint | Kapsanan REQ: <M>

▶ Sonraki: /data-model (yapılmadıysa) veya /epics
```

---

## Token notu

- **1 agent çağrısı** + en fazla 1 düzeltme turu.
- Mevcut YAML'ın tamamını gömme — sadece `path + method + özet` listesi.
- Tutarlılık denetimini model yapar; ayrı bir inceleme agent'ı açma.
