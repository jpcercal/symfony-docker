# Executables (local)
DOCKER_COMPOSE = docker compose

# Docker containers
PHP_CONTAINER = $(DOCKER_COMPOSE) exec php

# Executables
PHP      = $(PHP_CONTAINER) php
COMPOSER = $(PHP_CONTAINER) composer

# Misc
.DEFAULT_GOAL = help

## —— 🎵 🐳 The Symfony Docker Makefile 🐳 🎵 ——————————————————————————————————
.PHONY: help
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9\./_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker 🐳 ————————————————————————————————————————————————————————————————
.PHONY: build
build: ## Builds the Docker images
	@$(DOCKER_COMPOSE) build --pull --no-cache

.PHONY: up
up: ## Start the Docker containers in detached mode (no logs)
	@$(DOCKER_COMPOSE) up --detach

.PHONY: start
start: build up ## Build and start the containers

.PHONY: down
down: ## Stop the Docker containers
	@$(DOCKER_COMPOSE) down --remove-orphans

.PHONY: stop
stop: down ## Alias for down

.PHONY: restart
restart: down up ## Restart the Docker containers

.PHONY: logs
logs: ## Show live logs
	@$(DOCKER_COMPOSE) logs --tail=0 --follow

.PHONY: sh
sh: ## Connect to the PHP container
	@$(PHP_CONTAINER) sh

.PHONY: bash
bash: ## Connect to the PHP container via bash
	@$(PHP_CONTAINER) bash

.PHONY: exec
exec: ## Execute a command in the PHP container, example: `make exec -- ls -la .` or `make exec -- php -v"
	@$(PHP_CONTAINER) bash -c "$(filter-out $@,$(MAKECMDGOALS))"

.PHONY: test
test: ## Run tests with PHPUnit
	@$(DOCKER_COMPOSE) exec -e APP_ENV=test php bin/phpunit $(filter-out $@,$(MAKECMDGOALS))

## —— Composer 🧙 ——————————————————————————————————————————————————————————————
.PHONY: composer
composer: ## Run composer
	@$(COMPOSER) $(filter-out $@,$(MAKECMDGOALS))

.PHONY: vendor
vendor: ## Install vendors according to the current composer.lock file
	@$(COMPOSER) install --prefer-dist --no-dev --no-progress --no-scripts --no-interaction

.PHONY: phpcs-check
phpcs-check: ## Check for PHP code style violations using PHP-CS-Fixer
	@$(PHP) ./vendor/bin/php-cs-fixer check --config=.php-cs-fixer.dist.php -v --stop-on-violation --using-cache=no ./src/

.PHONY: phpcs-fix
phpcs-fix: ## Fix PHP code style violations using PHP-CS-Fixer
	@$(PHP) ./vendor/bin/php-cs-fixer fix --config=.php-cs-fixer.dist.php -v --stop-on-violation --using-cache=no ./src/

.PHONY: phpstan-analyse
phpstan-analyse: ## Analyse PHP code using PHPStan
	@$(PHP) ./vendor/bin/phpstan analyse

.PHONY: phpmd
phpmd: ## PHP Mess Detector
	@$(PHP) ./vendor/bin/phpmd ./src/ github cleancode,codesize,design,naming,unusedcode

## —— PHP 🐘 ———————————————————————————————————————————————————————————————
.PHONY: php
php: ## Run PHP commands, example: `make php -- --version`
	@$(PHP) $(filter-out $@,$(MAKECMDGOALS))

## —— Symfony 🎵 ———————————————————————————————————————————————————————————————
.PHONY: symfony
symfony: ## List all Symfony commands or pass a command to run, example: `make symfony -- about --help`
	@$(PHP) bin/console $(filter-out $@,$(MAKECMDGOALS))

# Ensure that targets that can take arguments don't error out due to missing commands
%:
	@:
