# Koordinasyon Kuralları

Agent'lar iki eksende iletişir: **dikey delegasyon** (yukarıdan aşağı iş dağıtımı)
ve **yatay danışma** (aynı seviyede uzlaşma). Bu dosya ikisinin de kurallarını verir.

---

## 1. Dikey delegasyon

```
                    ceo ─────────────── cto
                     │                   │
        ┌────────────┴─────────┐         │
   product-owner        delivery-manager │
        │                      │         │
  business-analyst             │  solution-architect
        │                      │         │
        └──────────┬───────────┴─────────┘
                   │
    ┌──────┬───────┼────────┬────────┬─────────┐
   ux/ui   FE      BE      SQL     DevOps    data
                   │
              qa-lead ── test-engineer / code-reviewer
                      ── security-engineer / performance-engineer
```

Kurallar:

- Bir agent **sadece bir alt seviyeye** delege eder. `ceo` doğrudan
  `frontend-developer`'a iş vermez; `product-owner` → `delivery-manager` → geliştirici.
- Delege edilen iş **görev paketi** formatında verilir (bkz. `token-budget.md` §5).
- Bir agent aynı anda birden fazla sahibi olan iş almaz. Bir story = bir sahip.

---

## 2. Yatay danışma (round-table)

Aynı katmandaki agent'lar birbirine danışabilir. Kilit çiftler:

| Çift | Ne zaman | Çıktı |
|---|---|---|
| `product-owner` ↔ `business-analyst` | Keşif ve gereksinim netleştirme | PRD + FRD tutarlılığı |
| `solution-architect` ↔ `sql-developer` | Veri modeli mimariye uyuyor mu | ER + ADR |
| `solution-architect` ↔ `devops-engineer` | Dağıtım topolojisi, NFR karşılığı | ADR + ortam planı |
| `ux-designer` ↔ `ui-designer` | Akış ↔ komponent uyumu | Ekran spesifikasyonu |
| `frontend-developer` ↔ `backend-developer` | API sözleşmesi kullanımı | OpenAPI değişiklik talebi |
| `qa-lead` ↔ `business-analyst` | Kabul kriteri test edilebilir mi | Revize kriterler |

**Round-table protokolü** (`/roundtable` skill'i bunu uygular):

1. Her katılımcıya **aynı girdi**, **farklı mercek** verilir.
2. Katılımcılar **paralel** çalışır — birbirinin çıktısını görmez (grup düşüncesi engellenir).
3. Çağıran agent yanıtları toplar, **anlaşma / anlaşmazlık** olarak ayırır.
4. Anlaşmazlıklar kullanıcıya `AskUserQuestion` ile karar olarak sunulur.
5. Karar `docs/DECISIONS.md`'ye tek satır olarak eklenir.

---

## 3. Escalation (yukarı taşıma)

Bir agent şu durumlarda **durur** ve yukarı taşır:

| Durum | Kime |
|---|---|
| Gereksinim belirsiz / çelişkili | `business-analyst` → `product-owner` |
| Kapsam büyüyor, takvim riskte | `delivery-manager` → `product-owner` → `ceo` |
| Mimari kural iş gereksinimini engelliyor | geliştirici → `solution-architect` → `cto` |
| Yeni teknoloji/kütüphane gerekiyor | geliştirici → `solution-architect` → `cto` (ADR) |
| API sözleşmesi değişmeli | FE/BE → `solution-architect` |
| Veri modeli değişmeli | BE → `sql-developer` → `solution-architect` |
| Kabul kriteri test edilemez | `test-engineer` → `qa-lead` → `business-analyst` |
| Güvenlik bulgusu (yüksek) | herkes → `security-engineer` → `cto` |
| İki agent aynı dosyada çakışıyor | ikisi de → `delivery-manager` |

**Escalation formatı:**

```
ESCALATION → <hedef rol>
SORUN: <tek cümle>
NEDEN BEN ÇÖZEMİYORUM: <yetki/bilgi sınırı>
SEÇENEKLER: <2-3 seçenek, trade-off'larıyla>
ÖNERİM: <tercih + gerekçe>
BLOKE İŞ: <bekleyen story'ler>
```

---

## 4. Paralel çalışma kuralları

`delivery-manager` sprint planlarken şunu garanti eder:

- **Aynı dosyaya** iki agent aynı sprintte yazmaz. Yazacaksa sıralanır.
- Sözleşme üreten iş (API, şema) tüketen işten **önce** biter.
- Bağımsız dikey dilimler paralel yürür: `[BE + SQL]` ‖ `[FE + UI]` ‖ `[DevOps]`
- Entegrasyon noktası sprint sonunda değil, **ortasında** planlanır.

Tipik paralel şablon (bir özellik için):

```
Gün 1     : solution-architect → API sözleşmesi + ADR (kilit)
Gün 1-2   : sql-developer → şema + migration      ‖  ux/ui → ekran spesifikasyonu
Gün 2-4   : backend-developer → servis + testler   ‖  frontend-developer → mock ile UI
Gün 4     : entegrasyon (FE gerçek API'ye geçer)
Gün 5     : test-engineer → e2e + regresyon        ‖  code-reviewer → inceleme
Gün 5     : qa-lead → DoD kapısı
```

---

## 5. Konuşma disiplini

- Agent'lar birbirine **övgü/nezaket paragrafı** yazmaz. Sadece veri.
- Alt-agent yanıtı `token-budget.md` §3'teki formatı kullanır.
- Bir agent kendi görevinin dışında bir şey fark ederse **düzeltmez**, `NOT:` olarak
  raporlar. Kapsam kayması token ve regresyon riskidir.
- Bir agent varsayım yapmak zorunda kaldıysa çıktısının başında `VARSAYIM:` satırı açar.

---

## 6. Kullanıcının rolü

Kullanıcı bu şirketin **kurucusu ve nihai karar vericisidir**. Agent'lar:

- Stratejik seçimlerde **seçenek sunar**, karar vermez.
- Dosya yazmadan önce **onay ister** (istisna: onaylanmış story kapsamındaki kod).
- Kullanıcı kararını verdikten sonra **tartışmayı kapatır** ve tam uygular.
- Kullanıcı bir endişeyi ikinci kez reddederse, endişe `docs/DECISIONS.md`'ye
  "kabul edilen risk" olarak yazılır ve bir daha gündeme getirilmez.
