# Definition of Done (DoD)

"Bitti" bir histir değil, **kanıttır**. `/dod-check` bu dosyayı kontrol listesi
olarak kullanır ve eksik kanıt varsa story kapanmaz.

---

## Story tipleri ve zorunlu kanıt

Her story `/stories` sırasında bir tip alır. Tip, gereken kanıtı belirler.

| Tip | Ne zaman atanır | Zorunlu kanıt |
|---|---|---|
| **Logic** | İş kuralı, hesaplama, durum geçişi, validasyon | Geçen unit test: `tests/**/<slug>.test.*` |
| **Integration** | 2+ bileşen etkileşimi, API çağrısı, kuyruk, dış servis | Geçen integration test + kontrat uyum kanıtı |
| **Data** | Şema, migration, index, veri dönüşümü | Migration up+down çalıştı + `db/schema.sql` güncel + örnek sorgu planı |
| **UI** | Ekran, komponent, form, navigasyon | Geçen komponent testi **veya** `docs/qa/evidence/<slug>.md` (adım+beklenen+sonuç) |
| **Infra** | CI/CD, ortam, IaC, izleme | Pipeline yeşil çıktı kanıtı + rollback adımı yazılı |
| **Config** | Sadece ayar/veri değişikliği, yeni mantık yok | Smoke test kaydı |

Karma story'lerde **en yüksek riskli tip** geçerlidir.

---

## Her story için ortak kontrol listesi

```
[ ] Tüm kabul kriterleri işaretli (story dosyasındaki checkbox'lar)
[ ] İzlenebilirlik tam: story → REQ-* → GOAL-* ve varsa ADR-* bağlı
[ ] Tip'e göre zorunlu kanıt mevcut ve geçiyor
[ ] Kapsam dışı bölümüne dokunulmamış (komşu story'lerin işi yapılmamış)
[ ] İlgili path kuralları ihlal edilmemiş (.claude/rules/)
[ ] Yeni bağımlılık eklendiyse ADR var
[ ] Hata durumları ele alınmış (mutlu yol dışı en az 2 senaryo)
[ ] Gizli bilgi sızıntısı yok (log, hata mesajı, response)
[ ] Kod incelemesi verdikti: ONAY veya ŞARTLI-kapatıldı
[ ] Dokümantasyon etkisi işlenmiş (API değiştiyse openapi.yaml, davranış değiştiyse guides/)
[ ] docs/DECISIONS.md'ye yeni karar eklendiyse tek satır olarak yazılmış
```

---

## Sprint DoD

Sprint kapanmadan önce:

```
[ ] Sprint hedefi karşılandı veya sapma gerekçesi yazıldı
[ ] Tüm story'ler ya DONE ya da gerekçeli olarak backlog'a döndü
[ ] Regresyon paketi yeşil
[ ] Açık ŞARTLI kapı maddesi kalmadı (.state/gates.jsonl)
[ ] docs/CONTEXT.md güncellendi (aşama, devam eden, borç)
[ ] product/risks.md gözden geçirildi
[ ] Retro yapıldı, aksiyonlar sahiplendirildi
```

---

## Sürüm DoD (release)

```
[ ] Sürümdeki tüm story'ler DONE
[ ] Regresyon + smoke test paketi hedef ortamda yeşil
[ ] SEC-REVIEW: ONAY (veya kabul edilen risk yazılı)
[ ] PERF-BUDGET: ONAY (NFR hedefleri ölçülmüş)
[ ] Migration planı + geri alma (rollback) adımları test edilmiş
[ ] Gözlemlenebilirlik: log, metrik, alarm tanımlı
[ ] CHANGELOG.md güncel, sürüm etiketi hazır
[ ] Kullanıcı/operasyon dokümanı güncel
[ ] OPS-READY: ONAY
[ ] CEO-GONOGO: ONAY
```

---

## Kabul kriteri kalitesi

`business-analyst` ve `qa-lead` şunları reddeder:

| Kötü | Neden | İyi |
|---|---|---|
| "Sistem hızlı olmalı" | Ölçülemez | "Liste 1000 kayıtta p95 < 400 ms döner" |
| "Kullanıcı dostu olmalı" | Doğrulanamaz | "Yeni kullanıcı kaydı 3 adımda, yardım almadan tamamlar" |
| "Hatalar yönetilmeli" | Belirsiz | "Geçersiz e-postada alan altında `E-posta formatı geçersiz` görünür, form gönderilmez" |
| "Güvenli olmalı" | Kapsamsız | "Yetkisiz kullanıcı `/admin/*` çağrısında 403 alır ve olay `audit_log`'a yazılır" |

Format tercih edilen: **Given / When / Then**.

```
Given: <önkoşul>
When: <eylem>
Then: <gözlemlenebilir sonuç>
Sınır durumları: <boundary / hata senaryoları>
```
