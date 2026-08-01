---
name: test-plan
description: Test stratejisi ve sürüm bazlı test planı üretir. Risk bazlı kapsam belirler, test piramidini tanımlar, hangi alanın ne kadar test edileceğine karar verir.
---

# /test-plan [kapsam]

Sahip: `qa-lead`. Çıktı: `docs/qa/strategy.md` (bir kez) + `docs/qa/test-plan.md` (sürüm bazlı)

---

## 1. Girdi

- `FRD.md` — REQ başlık tablosu + öncelikler
- `NFR.md` — tam (performans, güvenlik, erişilebilirlik hedefleri test edilecek)
- `ARCHITECTURE.md` — bileşenler ve entegrasyon noktaları
- Mevcut `docs/qa/strategy.md` (varsa — güncellenir, yeniden yazılmaz)
- Açık hatalar (`docs/qa/bugs/`) — regresyon riski göstergesi

## 2. `qa-lead` çağır

```
<BAĞLAM BLOĞU>

Görev: Test stratejisi ve planı üret.

A) STRATEJİ (ilk kez çalışıyorsa)
1. Test piramidi: bu proje için unit/integration/e2e hedef dağılımı ve gerekçesi
2. Risk bazlı kapsam matrisi:
   | Alan | İş etkisi | Değişim sıklığı | Karmaşıklık | Risk | Test yoğunluğu |
   Yüksek riskli alanlara yoğunlaş, düşük riskliye smoke yeter.
3. Kapsam eşikleri (kritik modül / genel)
4. Test verisi stratejisi: fixture yönetimi, sahte veri, anonimleştirme
5. Ortam stratejisi: hangi test hangi ortamda, izolasyon, paralel çalıştırma
6. Otomatikleştirilmeyecekler ve neden (manuel kalacak alanlar)

B) TEST PLANI (bu sürüm için)
1. Kapsam: hangi REQ'ler test edilecek
2. Test tipleri ve her biri için sorumlu:
   fonksiyonel, entegrasyon, uçtan uca, performans, güvenlik,
   erişilebilirlik, regresyon, smoke
3. Uçtan uca senaryolar (EN FAZLA 8 — sadece paraya dokunan yolculuklar)
4. NFR doğrulama: her ölçülebilir NFR için nasıl test edileceği
5. Giriş kriterleri (test başlamadan önce ne hazır olmalı)
6. Çıkış kriterleri (test bitti demek için ne sağlanmalı)
7. Test edilmeyecekler ve kabul edilen risk

Kural: Kapsam yüzdesi bir gösterge, hedef değil. Assert'siz test değersizdir.
```

## 3. Sun

```
## Test Planı — <sürüm/faz>
Piramit: unit %<a> | integration %<b> | e2e %<c>

Risk matrisi (yüksek riskli alanlar)
| Alan | Risk | Test yoğunluğu |

Uçtan uca senaryolar: <N>
NFR doğrulaması: <M> NFR → <K> test
Test edilmeyecek: <liste> — kabul edilen risk

Giriş kriterleri: <liste>
Çıkış kriterleri: <liste>
```

## 4. Yaz

- `docs/qa/strategy.md` (yoksa oluştur, varsa güncelle)
- `docs/qa/test-plan.md`
- Uçtan uca senaryoları `docs/qa/test-cases/e2e/` altına iskelet olarak yaz

## 5. Kapat

```
✓ Test planı → docs/qa/test-plan.md
  <N> e2e senaryo | <M> NFR doğrulaması

▶ Sonraki: /qa-run  (testleri çalıştır)
   Not: story bazlı test senaryoları /stories sırasında zaten yazıldı —
   bu plan sürüm seviyesindeki kapsamı tanımlar.
```

---

## Token notu

- **1 agent çağrısı.**
- Strateji bir kez yazılır, sonraki sürümlerde sadece test planı güncellenir.
- REQ'ler başlık olarak, NFR'ler tam gömülür.
