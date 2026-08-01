---
name: architecture
description: Sistem mimarisini ve teknoloji yığınını belirler. Solution Architect tasarlar, CTO onaylar. Bileşen sınırları, veri akışı, NFR karşılıkları ve ilk ADR'ler üretilir. CTO-STACK ve ARCH-DESIGN kapılarını işletir.
---

# /architecture

Sahip: `solution-architect`, onay: `cto`.
Çıktı: `docs/architecture/ARCHITECTURE.md`, `TECH-STRATEGY.md`, ilk ADR'ler.

Ön koşul: `product/requirements/FRD.md` + `NFR.md`

---

## 1. Girdi hazırla

Bağlam bloğu:
- Proje tanımı, ölçek, kritik kısıt (`docs/CONTEXT.md`'den)
- REQ başlık tablosu (Faz 1 kapsamı — tam metin değil)
- **NFR'lerin tamamı** (bunlar mimariyi belirler, tam gömülür)
- Kullanıcının bilinen tercihleri (varsa `docs/DECISIONS.md`'den)

Ayrıca kullanıcıya `AskUserQuestion` ile sor (mimariyi büyük ölçüde belirler):

**Soru 1 — Teknoloji tercihi**
`Benim bildiğim yığını kullan (belirteceğim)` / `Sen öner (Önerilen)` /
`Mevcut bir sistemle uyumlu olmalı`

**Soru 2 — Barındırma**
`Bulut (yönetilen servisler)` / `Kendi sunucum / VPS` / `Şirket içi (on-prem)` / `Henüz belli değil`

**Soru 3 — Beklenen ölçek (ilk yıl)**
`< 100 kullanıcı` / `100 - 10.000` / `10.000+` / `Bilinmiyor`

## 2. `solution-architect` ve `cto` — paralel çağrı

Bu ikisi **aynı mesajda paralel** çağrılır; farklı sorulara cevap verirler.

### Çağrı A — `solution-architect`

```
<BAĞLAM BLOĞU + kullanıcı cevapları>

Görev: Mimari tasarımı üret.

1. Bağlam diyagramı (C4-1): sistem, aktörler, dış sistemler — Mermaid
2. Konteynerler (C4-2): her biri için sorumluluk + karşıladığı NFR
3. Bileşen sınırları ve bağımlılık yönü kuralı
4. Kritik senaryolar için veri akışı (en fazla 3 sequence diyagramı)
5. Çapraz kesen konular: kimlik/yetki, hata yönetimi, loglama,
   konfigürasyon, önbellek, işlem sınırları
6. NFR karşılık tablosu: | NFR | mekanizma | doğrulama yöntemi |
   HER NFR bir satır almalı. Karşılığı yoksa "AÇIK" yaz.
7. Bilinçli olarak yapmadıklarımız (elenen yaklaşımlar + neden)
8. ADR gerektiren kararların listesi (başlık + neden ADR gerekiyor)

Kural: En basit çalışan çözüm. Dağıtık sistem, mikroservis, event sourcing gibi
seçimler somut bir NFR'ye dayanmalı — dayanmıyorsa önerme.
Yanıtına "ARCH-DESIGN: ONAY|ŞARTLI|RET" satırıyla başlama — bu ilk tur, tasarım turu.
```

### Çağrı B — `cto`

```
<BAĞLAM BLOĞU + kullanıcı cevapları>

Görev: Teknoloji yığınını belirle ve TECH-STRATEGY içeriğini üret.

1. Katman katman yığın önerisi (frontend, backend, veritabanı, altyapı, CI,
   izleme). Her seçim için: neden bu, hangi alternatif elendi, çıkış maliyeti.
2. İzin verilen / verilmeyen teknoloji politikası
3. Bağımlılık politikası: ne zaman kütüphane eklenir, kriterler
4. Teknik borç duruşu: neyi şimdi ödemeyiz, ne zaman öderiz
5. Operasyon maliyeti tahmini (kaba: düşük/orta/yüksek + aylık mertebe)
6. Bu yığının 6 ay sonra bizi neyi yapmaktan alıkoyacağı

Kural: Sıkıcı ve olgun > yeni ve heyecan verici. Ekibin bildiği > teorik en iyi.
Parça sayısını minimize et.
Yanıtına "CTO-STACK: ONAY|ŞARTLI|RET" satırıyla başla.
```

## 3. Çakışma kontrolü (sen yaparsın)

İki çıktı uyumsuzsa (mimari X varsayıyor, CTO Y seçmiş) çelişkiyi **görünür kıl**
ve `AskUserQuestion` ile karara bağla. Agent'lara tekrar sorma.

## 4. NFR boşluk denetimi

`ARCH-DESIGN` verdikti için NFR karşılık tablosunu **sen kontrol et**:
- Karşılığı `AÇIK` olan NFR var mı → listele
- Doğrulama yöntemi olmayan NFR var mı → listele

Boşluk varsa `solution-architect`'e **tek ve kısa** bir ikinci tur gönder:
```
Şu NFR'lerin mimari karşılığı eksik: <liste>
Sadece bu satırları doldur. Tüm mimariyi tekrar yazma.
Sonra "ARCH-DESIGN: ONAY|ŞARTLI|RET" ver.
```

## 5. Sun

```
## Mimari Özeti
Yaklaşım: <tek cümle — örn. "Tek servis (modüler monolit) + PostgreSQL + SPA">

Yığın
| Katman | Seçim | Neden | Elenen alternatif |

Konteynerler
| Ad | Sorumluluk | NFR |

NFR karşılıkları: <N>/<M> karşılandı  ⚠ Açık: <liste>

ADR gerekenler: <başlık listesi>

Kapılar: CTO-STACK <verdikt> | ARCH-DESIGN <verdikt>
```

`AskUserQuestion`: `Onayla ve yaz (Önerilen)` / `Yığını değiştireceğim` /
`Daha basit bir mimari istiyorum`

## 6. Yaz

- `docs/architecture/ARCHITECTURE.md`
- `docs/architecture/TECH-STRATEGY.md`
- `docs/architecture/adr/index.md` — ADR gerekenler listesi (henüz yazılmadı, `Önerilen` durumda)
- `docs/CONTEXT.md` → "Teknoloji yığını" tablosu doldurulur
- `.state/project.json` → `stack` alanı + `phase: "design"`
- `.state/gates.jsonl` → iki kapı satırı
- `docs/DECISIONS.md` → yığın kararı tek satır

## 7. Kapat

```
✓ Mimari belirlendi.
  Yığın: <özet> | ADR gereken: <N> karar

▶ Sonraki adımlar (sırayla):
   /adr "<ilk kritik karar>"     — kritik kararları kayda geçir
   /data-model                    — ER + şema
   /api-contract                  — OpenAPI sözleşmesi
   /ux-flow                       — kullanıcı akışları  (paralel yapılabilir)
```

---

## Token notu

- **2 paralel agent çağrısı** + en fazla 1 kısa düzeltme turu.
- NFR'ler tam gömülür (mimariyi belirler), REQ'ler sadece başlık olarak.
- Çakışma çözümünü model yapar, üçüncü agent açma.
- Tüm ADR'leri burada yazma — sadece listesini çıkar. `/adr` tek tek yazar.
