# Makefile for project management

.PHONY: setup build test deploy clean

setup:
	@echo "Setting up development environment..."
	pip install -r requirements.txt

build:
	@echo "Building Docker containers..."
	docker-compose build

test:
	@echo "Running tests..."
	pytest

deploy:
	@echo "Deploying with Docker..."
	docker-compose up -d

clean:
	@echo "Cleaning up..."
	docker-compose down
	find . -type d -name "__pycache__" -exec rm -r {} +

logs:
	@echo "Showing logs..."
	docker-compose logs -f

stop:
	@echo "Stopping services..."
	docker-compose down
