---
name: discovery
description: Product Owner ve Business Analyst'i paralel çalıştırıp projeyi detaylandırır. İki farklı mercekten bakar, anlaşma ve çelişkileri ayırır, çelişkileri kullanıcıya karar olarak sunar. PRD öncesi zorunlu adım.
---

# /discovery

Faz 1'in ilk adımı. **PO ve BA'nın kafa kafaya verdiği** yer.
Çıktı: `product/discovery.md` + netleşmiş kapsam + açık soru listesi.

Ön koşul: `product/00-brief.md` mevcut olmalı. Yoksa `/kickoff` öner ve dur.

---

## 1. Girdiyi hazırla

`product/00-brief.md` oku. Şu **bağlam bloğunu** oluştur (her iki agent'a birebir
aynısı gidecek — dosya okutma, içeriği göm):

```
PROJE: <ad> — <tek cümle>
HEDEFLER: GOAL-01 <...> | GOAL-02 <...>
KULLANICI: <persona özeti>
KISIT: <kritik kısıt>
MVP DIŞI: <liste>
RİSKLİ VARSAYIMLAR: <liste>
```

## 2. Paralel round-table (tek mesajda iki Agent çağrısı)

İki agent **aynı bağlamı, farklı mercekle** alır ve **birbirini görmez**.
Bu kasıtlıdır — grup düşüncesini engeller.

### Çağrı A — `product-owner`

```
<BAĞLAM BLOĞU>

Mercek: DEĞER ve ÖNCELİK.

Üret:
1. Problem tanımı — kimin, hangi durumda, ne acısı. Kanıt mı varsayım mı işaretle.
2. En fazla 3 persona: rol, hedef, bugün nasıl çözüyor, neden yetersiz.
3. Yetenek listesi (capability): kullanıcının yapabilmesi gereken şeyler.
   Her biri MoSCoW ile: Olmalı / Olmalıydı / Olabilir / Olmayacak.
   Her "Olmalı" bir GOAL'a bağlanmalı — bağlanmıyorsa "Olmayacak"a taşı.
4. En küçük kullanılabilir ürün: hangi 3-5 yetenek olmadan bu ürün anlamsız?
5. Rakip/alternatif: kullanıcı bugün ne kullanıyor, biz neden daha iyiyiz.
6. Ölçüm: her GOAL için ürün içinde hangi olay ölçülecek.

Kısa ve maddeli yaz. Belirsizlik varsa "SORU:" satırı aç, varsayım yapma.
```

### Çağrı B — `business-analyst`

```
<BAĞLAM BLOĞU>

Mercek: EKSİKLİK, ÇELİŞKİ ve BELİRSİZLİK.

Üret:
1. Bu tanımdan iki farklı sistem yazılabilir mi? Nerede? (belirsizlik listesi)
2. Aktörler ve yetkiler: kim var, kim neyi yapabilir, kim yapamaz.
3. Ana iş süreçleri: uçtan uca akışlar (Mermaid). Her karar noktasını işaretle.
4. Veri kavramları: hangi varlıklar var, aralarındaki ilişki, sahiplik.
   Aynı kavrama iki isim veriliyorsa yakala.
5. Sorulmamış sorular — en az 10 madde. Örnek kategoriler:
   yetki/rol, çoklu kullanıcı, eşzamanlılık, silme/arşivleme, geçmiş veri,
   bildirim, çevrimdışı, para birimi/vergi/yerelleştirme, dosya/ek,
   dış sistem entegrasyonu, denetim izi, veri saklama süresi.
6. Kaçırılan sınır durumları: boş, çok fazla, eşzamanlı, geri alma, hata.

Kısa ve maddeli yaz. Karar verme — belirsizliği görünür kıl.
```

## 3. Sentez (sen yaparsın, agent çağırma)

İki çıktıyı karşılaştır ve üç kovaya ayır:

**ANLAŞMA** — ikisinin de aynı şekilde gördüğü. Doğrudan dokümana gider.

**ÇELİŞKİ** — biri X der, diğeri Y ima eder. Her çelişki için:
```
Ç-N: <konu>
  PO görüşü: <...>
  BA görüşü / ima ettiği: <...>
  Neden önemli: <hangi kararı etkiler>
  Seçenekler: A) <...>  B) <...>
```

**AÇIK SORU** — ikisinin de cevabını bilmediği, kullanıcıdan gelmesi gereken bilgi.
Bloke edici olanları işaretle (bunlar cevaplanmadan `/requirements` çalışamaz).

## 4. Kullanıcıya sun

Önce sentezi metin olarak yaz (yukarıdaki üç başlık).

Sonra `AskUserQuestion` ile **kararları topla**. Kurallar:
- Tek çağrıda en fazla 4 soru
- Önce **bloke edici** çelişkiler, sonra açık sorular
- Her seçeneğin tek cümlelik sonucu yazılı
- Önerilen seçenek ilk sırada, etiketinde "(Önerilen)"
- 4'ten fazla varsa ikinci tur yap; ama toplamda 8 soruyu geçme —
  gerisi `/requirements` sırasında sorulur

## 5. Dosyaya yaz

Onay sonrası `product/discovery.md`:

```markdown
# Keşif — <proje>
**Tarih:** <bugün> | **Katılımcılar:** product-owner, business-analyst

## Problem
<mutabık kalınan tanım> (kanıt: <var/varsayım>)

## Personalar
### <ad> — <rol>
Hedef: | Bugün nasıl çözüyor: | Acı noktası: | Başarı:

## Yetenekler (MoSCoW)
| # | Yetenek | Öncelik | GOAL | Not |

## En küçük kullanılabilir ürün
<3-5 yetenek>

## Aktörler ve yetkiler
| Aktör | Yapabilir | Yapamaz |

## Ana süreçler
<Mermaid akışlar>

## Veri kavramları
| Kavram | Tanım | İlişkili | Sahibi |

## Alınan kararlar
| # | Konu | Seçenekler | Karar | Gerekçe |

## Açık sorular
| # | Soru | Bloke eder mi | Sahip | Durum |

## Kapsam dışı (bu turda netleşen)
- <madde> — <neden>
```

Ayrıca:
- Alınan kararları `docs/DECISIONS.md`'ye tek satır olarak ekle
- `docs/CONTEXT.md`'nin "Ne inşa ediyoruz" ve "Kapsam dışı" bölümlerini güncelle
- `.state/project.json` → `phase: "discovery"` (değişmez, sonraki adım PRD)

## 6. Kapat

```
✓ Keşif tamamlandı.
  <N> yetenek | <M> karar alındı | <K> açık soru (<B> bloke edici)

<bloke edici varsa:>
⚠ Şu sorular cevaplanmadan gereksinim yazılamaz:
  - <soru>

▶ Sonraki: /prd
```

---

## Token notu

- **2 agent çağrısı** (paralel, tek mesaj). İkinci tur yok.
- Sentezi model yapar, agent'a yaptırma.
- Bağlam bloğu ≤ 40 satır. Brief'in tamamını gömme.
- Kullanıcı sorularını toplu sor; her soru için ayrı tur açma.
