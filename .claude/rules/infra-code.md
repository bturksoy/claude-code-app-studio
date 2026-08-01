# Altyapı ve CI/CD Kuralları

**Kapsam:** `infra/**`, `.github/**`, `.gitlab-ci.yml`, `Dockerfile*`, `docker-compose*`,
`*.tf`, `*.yaml` (k8s), `Jenkinsfile`

---

## Temel ilkeler

1. **Her şey kodda.** Konsoldan yapılan ve IaC'ye geri yazılmayan değişiklik
   yapılmamış sayılır.
2. **Ortamlar aynı tanımdan üretilir.** Fark sadece parametrede.
3. **Geri alma bir özelliktir.** Deploy'dan önce yazılır ve test edilir.
4. **Artefakt bir kez build edilir**, tüm ortamlara aynısı gider.

## Secret yönetimi

- `.env`, anahtar, sertifika, credential **versiyonlanmaz**
- `.env.example` boş değerlerle repoda bulunur (dokümantasyon amaçlı)
- Secret referans olarak geçer, değer olarak değil
- CI log'unda secret maskelenir
- Secret rotasyonu runbook'ta tanımlı

## Pipeline

```
1. Kurulum + bağımlılık önbelleği
2. Lint + format
3. Tip kontrolü
4. Unit testler (+ kapsam eşiği)
5. Build
6. Integration testler (geçici veritabanı)
7. Güvenlik: bağımlılık taraması + secret taraması
8. Artefakt (sürüm etiketli, değişmez)
9. [main] staging deploy → smoke → onay → prod
```

Kurallar:
- Pipeline < 10 dakika. Aşarsa paralelleştir veya böl
- Kırık main tolere edilmez
- Testler pipeline'da atlanamaz (`--skip-tests` yasak)
- Deploy adımı **manuel onay** ister (prod için)

## Container

- Çok aşamalı build (multi-stage) — üretim imajında build araçları olmaz
- Root olmayan kullanıcı ile çalıştır
- Sabit taban imaj etiketi (`:latest` yasak), tercihen digest
- `.dockerignore` mevcut ve etkin
- Sağlık kontrolü tanımlı
- İmaj boyutu makul (gereksiz katman/dosya yok)

## Kubernetes / orkestrasyon (kullanılıyorsa)

- Kaynak istekleri ve limitleri tanımlı
- Liveness ve readiness probe'ları **ayrı ve doğru** (readiness bağımlılıkları kontrol eder)
- `imagePullPolicy` ve etiketleme tutarlı
- ConfigMap ve Secret ayrımı doğru
- PodDisruptionBudget ve replika sayısı kullanılabilirlik NFR'ine uygun

## Terraform / IaC

- Uzak state, kilitlemeli
- `plan` çıktısı incelenmeden `apply` yok
- Modül sürümleri sabitlenmiş
- Kaynak silme koruması kritik kaynaklarda açık
- `apply` **kullanıcı onayı olmadan çalıştırılmaz**

## Gözlemlenebilirlik

- Log: yapılandırılmış (JSON), korelasyon kimliği, gizli veri maskeli
- Metrik: RED (istek/hata/gecikme) + kaynak kullanımı + iş metrikleri
- Alarm: **her alarmın bir sahibi ve bir runbook adımı olmalı**. Sahipsiz alarm silinir
- Sağlık uçları: `/health` (canlılık), `/ready` (bağımlılıklar dahil)
- Log saklama süresi ve maliyeti tanımlı

## Ortamlar

Her ortam için `docs/ops/environments.md` içinde tanımlı:
amaç, URL, veri tipi, kim deploy eder, onay gerekiyor mu, ölçek, yedekleme.

## Yasaklar

- **Kullanıcı onayı olmadan:** deploy, `terraform apply`, `kubectl delete`,
  üretimde migration, DNS değişikliği
- Secret değerini okumak, yazmak veya ekrana basmak
- Üretim verisini silmek veya üzerine yazmak
- Manuel "hızlı düzeltme" — her değişiklik koddan geçer
- Test ortamına üretim verisini anonimleştirmeden kopyalamak
