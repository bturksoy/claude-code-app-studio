---
name: perf-check
description: Performans bütçelerini doğrular. Yük testi çalıştırır, ölçümleri hedeflerle karşılaştırır, darboğazları analiz eder ve regresyon tespiti yapar. PERF-BUDGET kapısını işletir.
---

# /perf-check [kapsam]

Sahip: `performance-engineer`. Ölçmeden verdikt verilmez.

---

## 1. Bütçeleri yükle

`docs/qa/performance/budgets.md` yoksa **önce onu oluştur**:

`performance-engineer` çağır:
```
NFR'ler: <performans/ölçek ile ilgili NFR'lerin tamamı>
Mimari: <konteynerler, veri katmanı>
Kritik akışlar: <UX akışlarından en çok kullanılacaklar>

Görev: Performans bütçe tablosu üret.
| ID | Metrik | Hedef | Koşul | Ölçüm aracı | Kaynak NFR |
Her bütçe ölçülebilir ve bağlamlı olmalı. Ölçüm aracını bu projenin
yığınına uygun seç. Test senaryosu iskeletlerini de ver.
```

## 2. Ölçüm yap

Sırayla dene (varsa çalıştır, yoksa atla ve **atladığını raporla**):

```
Yük testi   : tests/performance/ altındaki senaryolar (k6, artillery, locust)
Frontend    : lighthouse CI, bundle analyzer
Veritabanı  : kritik sorgular için EXPLAIN ANALYZE
Bellek/CPU  : varsa container/proses metrikleri
```

Çalıştıramadıklarını **açıkça belirt**. "Muhtemelen yeterlidir" yazma.

## 3. `performance-engineer` çağır

```
Bütçeler: <budgets.md tablosu>
Önceki ölçüm: <docs/qa/performance/ son run — karşılaştırma temeli>

BU TURUN ÖLÇÜMLERİ:
<gerçek çıktılar — kırpma>

Ölçülemeyenler: <liste + neden>

İlgili kod (şüpheli alanlar):
<Grep ile bulunan: N+1 deseni, döngü içi sorgu, senkron dış çağrı,
 sınırsız sonuç kümesi>

Görev: PERF-BUDGET kapısı.
1. Bütçe karşılaştırma tablosu: | ID | Hedef | Ölçülen | Durum | Önceki | Değişim |
2. Regresyon var mı (önceki turdan kötüleşme)
3. Aşılan bütçeler için darboğaz analizi:
   nerede, kanıt (ölçüm satırı), neden, düzeltme önerisi, tahmini kazanç
4. Ölçülemeyen bütçeler için: nasıl ölçülür (somut komut/araç)

Kural: Ölçmeden optimizasyon önerme. Amdahl'ı uygula — toplam sürenin %5'ini
alan şeyi önerme.
Yanıtına "PERF-BUDGET: ONAY|ŞARTLI|RET" satırıyla başla.
Ölçüm yapılmamışsa otomatik RET.
```

## 4. Sun

```
## Performans — <tarih> — <build>
Verdikt: PERF-BUDGET <verdikt>

| Bütçe | Hedef | Ölçülen | Durum | Önceki | Değişim |
| PB-01 | <300ms | 245ms | ✓ | 260ms | -6% |
| PB-03 | <200KB | 340KB | ✗ | 310KB | +10% ⚠ |

Regresyon: <varsa>
Ölçülemeyen: <liste>

Darboğazlar
| # | Nerede | Kanıt | Öneri | Tahmini kazanç |
```

## 5. Aksiyon

Aşılan bütçeler için `AskUserQuestion`:
- `Darboğazları düzelt (story aç)`
- `Bütçeyi gözden geçir — hedef gerçekçi değilmiş`
- `Risk olarak kabul et`

Düzeltme seçilirse backlog'a story olarak ekle (`delivery-manager`'a bildir).

## 6. Kaydet

- `docs/qa/performance/run-<tarih>.md`
- `.state/gates.jsonl` → PERF-BUDGET
- Kabul edilen aşımlar → `product/risks.md`

---

## Token notu

- Ölçüm **bedava** (Bash). Agent sadece analiz için çağrılır.
- Tüm bütçeler geçtiyse ve regresyon yoksa: agent çağırmadan `ONAY` raporla.
- Ölçüm çıktılarını kırpmadan göm — analizin tüm değeri veride.
