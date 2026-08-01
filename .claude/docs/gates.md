# Kalite Kapıları (Gates)

Kapı, bir fazın çıkışında ilgili yönetici agent'ın verdiği **bağlayıcı verdikttir**.
Kapıyı çağıran skill, alt-agent yanıtının **ilk satırını** okur.

---

## Verdikt formatı

Kapı çağrılan agent yanıtına **mutlaka** şununla başlar:

```
<KAPI-ID>: ONAY
```
```
<KAPI-ID>: ŞARTLI
```
```
<KAPI-ID>: RET
```

Ardından gerekçe. Verdikt paragraf içine gömülmez — çağıran skill ilk satırı parse eder.

| Verdikt | Anlamı | Akış |
|---|---|---|
| `ONAY` | Faz geçebilir | Devam |
| `ŞARTLI` | Belirtilen maddeler düzeltilirse geçer | Maddeler işlenir, kapı tekrar çağrılmaz |
| `RET` | Temel bir sorun var | Faz geri döner, kullanıcıya bildirilir |

`ŞARTLI` verdiktinde agent en fazla **5 madde** listeler; her madde tek satır ve
uygulanabilir olmalıdır ("daha iyi olabilir" gibi ifadeler yasaktır).

---

## Kapı kataloğu

| Kapı ID | Faz | Çağıran skill | Agent | Sorusu | Mod |
|---|---|---|---|---|---|
| `CEO-VISION` | 0 | `/kickoff` | `ceo` | Bu proje iş olarak anlamlı ve ölçülebilir mi? | FAZ |
| `PO-SCOPE` | 1 | `/prd` | `product-owner` | Kapsam MVP için doğru büyüklükte mi? | FAZ |
| `BA-REQ` | 1 | `/requirements` | `business-analyst` | Gereksinimler eksiksiz, çelişkisiz, test edilebilir mi? | FAZ |
| `QA-TESTABLE` | 1 | `/requirements` | `qa-lead` | Kabul kriterleri doğrulanabilir mi? | full |
| `CTO-STACK` | 2 | `/architecture` | `cto` | Teknoloji seçimi ekip/ölçek/bütçeye uygun mu? | FAZ |
| `ARCH-DESIGN` | 2 | `/architecture` | `solution-architect` | Mimari NFR'leri karşılıyor mu? | FAZ |
| `SEC-THREAT` | 2 | `/threat-model` | `security-engineer` | Kritik tehditler ele alınmış mı? | full |
| `UX-FLOW` | 2 | `/ux-flow` | `ux-designer` | Akışlar tüm REQ'leri kapsıyor mu? | full |
| `DM-PLAN` | 3 | `/sprint-plan` | `delivery-manager` | Plan kapasiteye ve bağımlılıklara uygun mu? | FAZ |
| `ARCH-STORY` | 3 | `/stories` | `solution-architect` | Story'ler mimariye uygun kırılmış mı? | full |
| `CR-CODE` | 4 | `/code-review` | `code-reviewer` | Kod doğru, okunur ve kurallara uygun mu? | lean+ |
| `QA-DONE` | 4 | `/dod-check` | `qa-lead` | Kanıt DoD'yi karşılıyor mu? | FAZ |
| `SEC-REVIEW` | 4 | `/security-review` | `security-engineer` | Yayına engel güvenlik açığı var mı? | full |
| `PERF-BUDGET` | 4 | `/perf-check` | `performance-engineer` | Performans bütçeleri tutuyor mu? | full |
| `OPS-READY` | 5 | `/release` | `devops-engineer` | Ortam, rollback, izleme hazır mı? | FAZ |
| `CEO-GONOGO` | 5 | `/release` | `ceo` | Yayına çıkıyor muyuz? | FAZ |

**Mod sütunu:**
- `FAZ` → `lean` ve `full` modda çalışır, `solo`'da atlanır
- `full` → sadece `full` modda çalışır
- `lean+` → `lean` ve `full` modda çalışır (kod incelemesi kritiktir)

---

## Kapı çağırma deseni

Her skill kapı çağırmadan önce şu bloğu uygular:

```
1. product/review-mode.txt oku (yoksa "lean" varsay)
2. Kapının Mod sütunuyla karşılaştır:
   - solo  → atla, not düş: "<KAPI-ID> atlandı — solo mod"
   - lean  → sadece FAZ ve lean+ kapılarını çalıştır
   - full  → hepsini çalıştır
3. Çalışacaksa: Agent tool ile ilgili agent'ı çağır.
   Prompt'a şunlar gömülür (dosya yolu değil, İÇERİK):
     - Kapı ID'si ve sorusu
     - Değerlendirilecek çıktının özeti (≤100 satır)
     - Değerlendirme kriterleri
   Prompt sonu: "Yanıtına '<KAPI-ID>: ONAY|ŞARTLI|RET' satırıyla başla."
4. İlk satırı parse et, verdikte göre akışa devam et.
```

---

## Kapı ekonomisi

Kapılar token maliyetinin en büyük kalemidir. Kurallar:

- Bir kapı **bir kez** çağrılır. `ŞARTLI` maddeleri düzeltildikten sonra tekrar çağrılmaz.
- Kapı prompt'una tam dosya gömülmez; **özet** gömülür.
- Aynı fazda birden fazla kapı varsa **paralel** çağrılır (tek mesaj, çoklu Agent çağrısı).
- Kullanıcı bir kapıyı el ile atlamak isterse: `/skill --gate=off`.

---

## Kapı geçmişi

Her kapı sonucu `.state/gates.jsonl` dosyasına tek satır olarak eklenir:

```json
{"gate":"ARCH-DESIGN","verdict":"ŞARTLI","phase":2,"sprint":null,"items":3}
```

`/status` bu dosyayı okuyarak açık `ŞARTLI` maddelerini raporlar.
