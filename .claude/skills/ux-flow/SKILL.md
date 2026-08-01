---
name: ux-flow
description: Kullanıcı akışlarını, bilgi mimarisini ve wireframe spesifikasyonlarını üretir. Gereksinimleri ekran ve etkileşim diline çevirir. UX-FLOW kapısını işletir.
---

# /ux-flow [kapsam]

Sahip: `ux-designer`. Çıktı: `docs/design/ux/` altındaki dosyalar.

Ön koşul: `product/requirements/FRD.md`. Kapsam verilmezse mevcut faz REQ'leri.

---

## 1. Girdi

Bağlam bloğu:
- Personalar (`product/discovery.md` veya `PRD.md`'den)
- REQ listesi: ID, başlık, aktör, davranış özeti, **kabul kriterleri**
  (kabul kriterleri ekran davranışını belirler, tam gömülür)
- Kullanılabilirlik ile ilgili NFR'ler
- Platform bilgisi (web/mobil, hedef cihaz)

## 2. `ux-designer` çağır

```
<BAĞLAM BLOĞU>

Görev: UX tasarımını üret.

1. Bilgi mimarisi — bölümler, hiyerarşi, navigasyon modeli (Mermaid)
   İsimlendirme kullanıcı dilinde olmalı, sistem dilinde değil.
2. Kritik akışlar (en fazla 6) — her biri için:
   mutlu yol adımları, alternatif yollar, hata durumları,
   kullanılabilirlik kriterleri (adım sayısı hedefi, geri dönülebilirlik)
3. Ekran envanteri — akışlardan TÜRET, hayali ekran yazma:
   | Ekran | Rota | Amaç | Karşıladığı REQ | Öncelik |
4. Her ekran için wireframe spesifikasyonu (metin, görsel değil):
   yerleşim, durumlar (boş/yükleniyor/hata/yetkisiz), etkileşimler,
   erişilebilirlik (klavye sırası, odak yönetimi, ekran okuyucu),
   duyarlılık (mobil/tablet/masaüstü farkları)
5. REQ kapsama tablosu: her REQ hangi ekran(lar)da karşılanıyor
   Karşılanmayan REQ varsa AÇIKÇA listele.

Kurallar:
- Adım sayısını azalt, ekran sayısını değil
- Her ekranın boş durumu tanımlı olmalı
- Hata mesajı ne yapılacağını söylemeli — "Bir hata oluştu" yasak
- Erişilebilirlik sonradan eklenmez, spesifikasyonun parçası
- Renk/font/boşluk seçme — o ui-designer'ın işi

Önce ekran envanterini ver, sonra wireframe detaylarını.
Yanıtına "UX-FLOW: ONAY|ŞARTLI|RET" satırıyla başla (kendi çıktını değerlendir:
her REQ karşılandı mı, her ekranın 4 durumu var mı).
```

## 3. Ekran sayısı kontrolü

Ekran sayısı 12'yi aşıyorsa kullanıcıya sor:

> "<N> ekran çıktı. Hepsinin wireframe'ini şimdi mi yazalım, yoksa önce
> Faz 1'deki <M> ekranı mı?"

Wireframe spesifikasyonları uzundur — faz bazlı yazmak ciddi tasarruf sağlar.

## 4. Sun

```
## UX Tasarımı
Bilgi mimarisi: <N> bölüm
Akışlar: <M> kritik akış
Ekranlar: <K>

| Ekran | Rota | REQ | Öncelik |

REQ kapsaması: <X>/<Y>
⚠ Karşılanmayan: <liste>
⚠ Ekransız REQ (arka plan işi olabilir): <liste>

Kapı: UX-FLOW <verdikt>
```

## 5. Yaz

- `docs/design/ux/personas.md` (yoksa)
- `docs/design/ux/information-architecture.md`
- `docs/design/ux/flows/<akış>.md`
- `docs/design/ux/wireframes/<ekran>.md`
- `.state/gates.jsonl`

## 6. Kapat

```
✓ UX tasarımı → docs/design/ux/
  <M> akış | <K> ekran | REQ kapsaması <X>/<Y>

▶ Sonraki: /design-system
   UI Designer bu ekranların kullanacağı token ve komponentleri tanımlayacak.
```

---

## Token notu

- **1 agent çağrısı.** Kapı verdikti aynı çağrıda alınır.
- Kabul kriterleri tam gömülür (ekran davranışını belirler); REQ gövdesi gömülmez.
- Faz bazlı wireframe yazımı en büyük tasarruf.
- Wireframe'leri ekrana basma — dosyaya yaz, envanter tablosu göster.
