up:
	docker compose up -d
down:
	docker compose down
rails-install:
	docker compose exec app rails new . --api --force --no-deps --database=postgresql
init:
	@make up
	docker compose exec app rake db:create
migrate:
	docker compose exec app rake db:migrate
