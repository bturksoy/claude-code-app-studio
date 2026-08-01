---
name: estimate
description: Epic veya story listesi için efor tahmini üretir. Belirsizlik bandı, varsayımlar ve tahmini şişiren faktörleri açıkça belirtir.
---

# /estimate [kapsam]

Sahip: `delivery-manager`. Kapsam: epic slug, story listesi veya boş (→ mevcut backlog).

---

## 1. Girdi

Story/epic başlık blokları + tip + bağımlılık + dokunulan modüller.
Geçmiş veri varsa (tamamlanmış story'lerin tahmin vs gerçek) **onu da göm** —
kalibrasyon için en değerli girdi budur.

## 2. `delivery-manager` çağır

```
Kapsam: <epic/story listesi>
| # | Başlık | Tip | Sahip | AC sayısı | Bağımlı | Modüller |

Geçmiş kalibrasyon (varsa):
| Story | Tahmin | Gerçek | Sapma |

Proje bağlamı: <yığın, ekip kadrosu, mevcut kod olgunluğu>

Görev: Efor tahmini.

1. Her story için t-shirt boyutu (XS/S/M/L/XL) + gerekçe
   XS: <2 saat | S: yarım gün | M: 1 gün | L: 2-3 gün | XL: bölünmeli
2. XL çıkanlar için BÖLME önerisi — XL bir tahmin değil, bir uyarıdır
3. Belirsizlik seviyesi: her story için Düşük/Orta/Yüksek + neden
   Yüksek belirsizlik → önce spike öner (zaman kutulu araştırma)
4. Toplam: iyimser / gerçekçi / kötümser bant
5. Tahmini şişiren faktörler: bağımlılık bekleme, entegrasyon sürprizi,
   bilinmeyen üçüncü parti, test verisi hazırlığı
6. Kalibrasyon notu: geçmiş veriye göre sistematik sapma var mı

Kural: Tek sayı verme, BANT ver. Belirsizliği gizleme.
```

## 3. Sun

```
## Efor Tahmini — <kapsam>

| Story | Tip | Boyut | Belirsizlik | Not |
| 004 | Logic | M | Düşük | — |
| 007 | Integration | XL | Yüksek | ⚠ Bölünmeli — 3. parti entegrasyon |

Toplam
  İyimser:   <N> gün
  Gerçekçi:  <M> gün    ← planlamada bunu kullan
  Kötümser:  <K> gün

Spike önerilenler: <liste> — <zaman kutusu>
Bölünmesi gerekenler: <liste>

Şişiren faktörler
  - <faktör> → <etki>

Kalibrasyon: geçmiş tahminler ortalama %<n> <düşük/yüksek> çıkmış
  → bu tahmine %<n> ekle/çıkar
```

## 4. Kaydet

Story dosyalarındaki `**Tahmin:**` alanlarını güncelle.
Spike gerekenler için backlog'a spike story'si eklemeyi öner.

---

## Token notu

- **1 agent çağrısı.**
- Story dosyalarının başlık bloklarını göm, tam içeriği değil.
- Geçmiş kalibrasyon verisi tahmin kalitesini en çok artıran girdidir — atlamayın.
