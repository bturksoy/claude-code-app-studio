---
name: adr
description: Mimari Karar Kaydı (ADR) üretir. Bir teknik kararı, değerlendirilen alternatifleri, sonuçlarını ve uygulama rehberini kalıcı olarak kaydeder. Geliştiricinin story içinde göreceği talimatlar burada üretilir.
---

# /adr "<karar konusu>"

Sahip: `solution-architect`, onay: `cto`.
Çıktı: `docs/architecture/adr/ADR-NNNN-<slug>.md`

---

## 1. Numara ve konu

`docs/architecture/adr/` içindeki en büyük numarayı Glob ile bul, +1 al.
Argüman yoksa `adr/index.md`'deki "Önerilen" listesinden seç veya kullanıcıya sor.

## 2. ADR gerektiren durumlar (kontrol et)

Bunlardan biri değilse ADR yazma — `docs/DECISIONS.md`'ye tek satır yeter:
- Yeni bağımlılık / kütüphane / servis
- Veri saklama veya modelleme yaklaşımı
- Kimlik doğrulama / yetkilendirme yaklaşımı
- Entegrasyon deseni (senkron/asenkron, kuyruk, webhook)
- Eşzamanlılık veya tutarlılık modeli
- Hata/yeniden deneme/geri alma stratejisi
- Sürümleme veya geriye uyumluluk politikası
- Geri dönülemez herhangi bir seçim

## 3. `solution-architect` çağır

```
Karar konusu: <konu>
Bağlam: <CONTEXT.md özeti + ilgili NFR'ler + mevcut yığın>
İlgili gereksinimler: <REQ/NFR listesi>
Mevcut ADR'ler: <adr/index.md'deki başlıklar — çelişki kontrolü için>

Görev: ADR-<NNNN> üret.

## Bağlam
Hangi güçler bu kararı zorluyor — REQ/NFR referanslı, 1 paragraf

## Değerlendirilen seçenekler
En az 3 (biri "hiçbir şey yapma / mevcut haliyle devam" olmalı).
| Seçenek | Artı | Eksi | Neden elendi |

## Karar
Emir kipinde tek paragraf: "X kullanacağız."

## Sonuçlar
Olumlu: | Olumsuz (kabul ettiğimiz maliyet): | Geri dönüş maliyeti: düşük/orta/yüksek

## Uygulama rehberi
KRİTİK BÖLÜM — bu, story dosyalarına kopyalanacak.
Geliştiricinin ADR'yi açmasına gerek kalmayacak kadar somut yaz:
- Hangi dosya/katmanda ne yapılır
- Zorunlu desen (kod düzeyinde tarif)
- Yasak desen
- Yapılandırma / isimlendirme kuralı

## Doğrulama
Bu kararın uygulandığını nasıl kontrol ederiz: test, lint kuralı,
kod incelemesi maddesi veya mimari fitness fonksiyonu.

Mevcut bir ADR ile çelişiyorsa BELİRT — hangi ADR, nasıl çelişiyor.
```

## 4. `cto` onayı (lean+ mod)

```
<ADR TASLAĞI — tam metin>

Görev: Onayla veya geri çevir.
Kriterler: alternatifler gerçekten değerlendirilmiş mi (samimi mi),
sonuçlar dürüst yazılmış mı, NFR'lere karşılık geliyor mu,
daha basit bir seçenek yanlışlıkla elenmiş mi, çıkış maliyeti kabul edilebilir mi.

Yanıtına "ADR-<NNNN>: KABUL|ŞARTLI|RET" satırıyla başla.
```

`solo` modda atla; durum doğrudan `Kabul edildi` olur.

## 5. Yaz

- `docs/architecture/adr/ADR-NNNN-<slug>.md` — durum: `Kabul edildi` veya `Önerilen`
- `docs/architecture/adr/index.md`'ye satır ekle:
  `| ADR-NNNN | <başlık> | Kabul edildi | <tarih> | <etkilediği alan> |`
- `docs/DECISIONS.md`'ye tek satır ekle
- Bir ADR'yi **değiştiriyorsa**: eski ADR'nin durumunu `Değiştirildi (ADR-MMMM ile)`
  yap, içeriğini **silme**

## 6. Kapat

```
✓ ADR-<NNNN>: <başlık> — <durum>
  Etkilediği: <REQ/modül listesi>

Uygulama rehberi story'lere kopyalanacak (/stories bunu otomatik yapar).

▶ Sonraki: <varsa bir sonraki önerilen ADR> veya /data-model | /api-contract
```

---

## Token notu

- **1-2 agent çağrısı.** ADR taslağı CTO'ya tam gömülür (kısa bir doküman).
- Mevcut ADR'lerden sadece **index başlıkları** gömülür, içerikleri değil.
- "Uygulama rehberi" bölümüne yatırım yap — bu bölüm sayesinde geliştirici
  agent ADR dosyasını hiç açmaz. Doğrudan token tasarrufu.
