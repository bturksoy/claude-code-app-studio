# Infrastructure and CI/CD Rules

**Scope:** `infra/**`, `.github/**`, `.gitlab-ci.yml`, `Dockerfile*`, `docker-compose*`,
`*.tf`, `*.yaml` (k8s), `Jenkinsfile`

---

## Core principles

1. **Everything in code.** A change made in a console and not written back to IaC
   counts as not made.
2. **Environments come from the same definition.** Only parameters differ.
3. **Rollback is a feature.** It is written before deployment and tested.
4. **The artifact is built once** and the same one goes to every environment.

## Secret management

- `.env`, keys, certificates and credentials are **not versioned**
- `.env.example` lives in the repo with empty values (for documentation)
- Secrets are passed as references, not values
- Secrets are masked in CI logs
- Secret rotation is defined in the runbook

## Pipeline

```
1. Setup + dependency cache
2. Lint + format
3. Type check
4. Unit tests (+ coverage threshold)
5. Build
6. Integration tests (ephemeral database)
7. Security: dependency scan + secret scan
8. Artifact (version-tagged, immutable)
9. [main] staging deploy → smoke → approval → prod
```

Rules:
- Pipeline < 10 minutes. If longer, parallelize or split
- A broken main is not tolerated
- Tests cannot be skipped in the pipeline (`--skip-tests` is forbidden)
- The deploy step requires **manual approval** (for production)

## Containers

- Multi-stage build — no build tooling in the production image
- Run as a non-root user
- Pinned base image tag (`:latest` is forbidden), preferably a digest
- `.dockerignore` present and effective
- Health check defined
- Reasonable image size (no unnecessary layers or files)

## Kubernetes / orchestration (if used)

- Resource requests and limits defined
- Liveness and readiness probes are **separate and correct** (readiness checks dependencies)
- `imagePullPolicy` and labelling are consistent
- Correct separation of ConfigMap and Secret
- PodDisruptionBudget and replica count match the availability NFR

## Terraform / IaC

- Remote state with locking
- No `apply` without reviewing the `plan` output
- Module versions pinned
- Deletion protection enabled on critical resources
- `apply` **is never run without user approval**

## Observability

- Logs: structured (JSON), correlation id, secrets masked
- Metrics: RED (rate/errors/duration) + resource usage + business metrics
- Alerts: **every alert has an owner and a runbook step**. Ownerless alerts are deleted
- Health endpoints: `/health` (liveness), `/ready` (including dependencies)
- Log retention period and cost defined

## Environments

Each environment is defined in `docs/ops/environments.md`: purpose, URL, data type,
who deploys, approval requirement, scale, backups.

## Prohibitions

- **Without user approval:** deploy, `terraform apply`, `kubectl delete`,
  production migrations, DNS changes
- Reading, writing or printing secret values
- Deleting or overwriting production data
- Manual "quick fixes" — every change goes through code
- Copying production data to a test environment without anonymization
