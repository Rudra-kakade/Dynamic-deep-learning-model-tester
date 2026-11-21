# AI Model Vulnerability & Robustness Testing Platform

An adaptive, model-agnostic framework for adversarial, shortcut, and
distribution-shift testing of trained ML models. See `docs/prd_reference.md`
for the full PRD this scaffold was generated from.

## Core idea

Upload a trained model (PyTorch / TensorFlow / ONNX / scikit-learn) plus a
small reference dataset. The platform runs it through:

1. **Module 1 - Ingestion & Sandboxed Execution** - loads any supported
   format behind one `predict()`/`gradient()` interface, inside a
   network-isolated Docker sandbox.
2. **Module 2 - Adversarial Robustness** - white-box (FGSM, PGD/BIM, C&W)
   and black-box (Boundary, HopSkipJump, ZOO) attacks, plus edge-case /
   confidence-calibration checks.
3. **Module 3 - Shortcut Detection & Distribution Shift** - SHAP/Grad-CAM/
   Integrated Gradients attribution, counterfactual swaps, and KS/MMD/PSI
   shift tests via alibi-detect.
4. **Module 4 - Adaptive Orchestration, Scoring & Reporting** - a
   multi-armed bandit (UCB / Thompson sampling) adaptively allocates a
   fixed query budget across test categories, subject to a coverage floor.
   This is the project's original contribution (see `docs/architecture.md`).

## Quickstart

```bash
cp .env.example .env
docker compose up -d postgres redis minio
pip install -r backend/requirements.txt
alembic -c backend/alembic.ini upgrade head   # after `alembic init` (see migrations/README.md)
uvicorn app.main:app --reload --app-dir backend
celery -A app.services.celery_app worker --workdir backend --loglevel=info
streamlit run frontend/streamlit_app/app.py
```

## Layout

```
backend/     FastAPI API, Celery workers, Modules 1-4, tests
frontend/    Streamlit MVP dashboard (React "polish" option stubbed)
data/        Bundled default reference datasets per modality
reference_models/  Sample models (multiple serialization formats) for dev/testing
notebooks/   Bandit vs. static-baseline research notebooks (the novelty evidence)
scripts/     Dev/ops helper scripts (seeding data, malicious-pickle sandbox test)
docs/        Architecture notes and PRD reference
infra/       Deployment notes (future work - out of scope for capstone)
```

## Team role -> code mapping

| Role (PRD Sec. 16)                     | Primary directories                                    |
| --------------------------------------- | ------------------------------------------------------- |
| Backend / Orchestration Engineer        | `backend/app/module1_ingestion`, `backend/app/api`, `backend/app/services` |
| Adversarial ML Engineer                 | `backend/app/module2_adversarial`                        |
| Explainability & Shift Engineer         | `backend/app/module3_shortcut_shift`                     |
| Adaptive Selection / Research Lead      | `backend/app/module4_orchestration/bandit`, `notebooks/` |
| Frontend / Reporting Engineer           | `frontend/`, `backend/app/module4_orchestration/scoring` |
