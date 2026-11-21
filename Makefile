.PHONY: up down migrate test lint fmt seed

up:
	docker compose up -d

down:
	docker compose down

migrate:
	alembic -c backend/alembic.ini upgrade head

test:
	pytest backend/tests -v

lint:
	ruff check backend/app

fmt:
	ruff format backend/app

seed:
	python scripts/seed_default_datasets.py
