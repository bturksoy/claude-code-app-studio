---
name: roundtable
description: Herhangi bir konuda birden fazla rolü paralel çalıştırıp farklı merceklerden analiz alır, anlaşma ve çelişkileri ayırır, kararı kullanıcıya sunar. Zor kararlar ve çok disiplinli konular için genel amaçlı tartışma aracı.
---

# /roundtable "<konu>"

Genel amaçlı çok-rollü tartışma. `/discovery` bunun özelleşmiş halidir.

---

## 1. Konuyu ve katılımcıları belirle

Argüman yoksa sor: *"Hangi konuyu tartışalım?"*

Konuya göre katılımcı öner (`AskUserQuestion` ile onayla, **en fazla 4 rol**):

| Konu tipi | Önerilen katılımcılar |
|---|---|
| Kapsam / öncelik | `product-owner`, `business-analyst`, `delivery-manager` |
| Teknoloji seçimi | `cto`, `solution-architect`, `devops-engineer` |
| Veri modeli | `solution-architect`, `sql-developer`, `business-analyst` |
| Kullanıcı deneyimi | `ux-designer`, `product-owner`, `frontend-developer` |
| Performans sorunu | `performance-engineer`, `solution-architect`, `sql-developer` |
| Güvenlik yaklaşımı | `security-engineer`, `solution-architect`, `backend-developer` |
| Kalite / "bitti" tanımı | `qa-lead`, `business-analyst`, `delivery-manager` |
| Yayın kararı | `ceo`, `qa-lead`, `devops-engineer` |

**4'ten fazla rol çağırma.** Marjinal fayda düşer, maliyet doğrusal artar.

## 2. Ortak bağlam bloğu hazırla

Tek bir bağlam bloğu yaz (≤ 50 satır) ve **herkese aynısını** gönder:

```
KONU: <konu>
BAĞLAM: <ilgili proje bilgisi — CONTEXT.md'den özet>
KISITLAR: <bilinen sınırlar>
KARAR VERİLECEK: <net soru>
ŞU AN NE VAR: <mevcut durum>
```

Dosya yolu verme — içeriği göm. Alt-agent arama yapmamalı.

## 3. Paralel çağrı (tek mesajda hepsi)

Her role **kendi merceğini** ver:

```
<BAĞLAM BLOĞU>

Mercek: <role özgü açı — aşağıdaki tablodan>

Üret:
1. Bu konuya kendi alanından bakınca ne görüyorsun (en fazla 5 madde)
2. En büyük risk / kaçırılan şey nedir
3. Önerin ve gerekçesi
4. Öneriyle birlikte kabul ettiğin maliyet
5. Bu kararın yanlış olduğunu ne zaman anlarız

En fazla 25 satır. Diğer rollerin ne diyeceğini tahmin etme, kendi alanında kal.
```

Mercekler:

| Rol | Mercek |
|---|---|
| `ceo` | İş değeri, maliyet, geri dönülebilirlik |
| `cto` | Teknoloji riski, operasyon maliyeti, kilitlenme |
| `product-owner` | Kullanıcı değeri, öncelik, kapsam etkisi |
| `business-analyst` | Belirsizlik, çelişki, eksik senaryo |
| `solution-architect` | Bileşen sınırları, bağlantı, NFR karşılığı |
| `delivery-manager` | Takvim, bağımlılık, kapasite, risk |
| `ux-designer` | Kullanıcının yaşayacağı deneyim, adım sayısı |
| `sql-developer` | Veri bütünlüğü, sorgu maliyeti, migration riski |
| `devops-engineer` | Dağıtım, geri alma, izlenebilirlik, maliyet |
| `qa-lead` | Test edilebilirlik, regresyon riski |
| `security-engineer` | Saldırı yüzeyi, veri maruziyeti |
| `performance-engineer` | Ölçek davranışı, darboğaz |

## 4. Sentez (sen yaparsın)

```markdown
## Round-table: <konu>
Katılımcılar: <roller>

### Ortak görüş
<hepsinin hemfikir olduğu — madde madde>

### Ayrışma
| # | Konu | <Rol A> | <Rol B> | Neden önemli |

### Kimsenin söylemediği
<sentez sırasında fark ettiğin boşluk — varsa>

### Karar seçenekleri
**A) <ad>** — <ne demek> | Kazanç: <...> | Maliyet: <...> | Geri dönüş: <kolay/zor>
**B) <ad>** — ...

**Öneri:** <A veya B> — <tek cümle gerekçe>
```

## 5. Kararı al ve kaydet

`AskUserQuestion` ile seçenekleri sun (öneri ilk sırada, "(Önerilen)" etiketiyle).

Karar sonrası:
- `docs/DECISIONS.md`'ye tek satır ekle:
  `| <tarih> | <karar> | kullanıcı | <gerekçe> | /roundtable |`
- Karar mimari nitelikteyse `/adr` çalıştırmayı öner
- Karar kapsamı etkiliyorsa `/scope-check` öner
- Etkilenen rollere ne değiştiğini tek satırda bildir (raporda yaz)

---

## Token notu

- Katılımcı sayısı **maliyeti doğrusal artırır**. 3 ideal, 4 üst sınır.
- Herkes aynı bağlam bloğunu alır → prompt cache dostu.
- Tek tur. İkinci tur sadece kullanıcı yeni bilgi verirse yapılır.
- Sentez ve karar modelin işi — bunun için ayrı agent açma.
