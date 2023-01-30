up:
	docker compose up -d
down:
	docker compose down
rails-install:
	docker compose exec app rails new . --api --force --no-deps --database=postgresql
init:
	@make up
	docker compose exec app rake db:create
	@make migrate
migrate:
	docker compose exec app rake db:migrate
console:
	docker compose exec app rails console
test:
	docker compose exec app rspec spec/models -f documentation
routes:
	docker compose exec app rails routes
bundle-install:
	docker compose exec app bundle install
rspec:
	docker compose exec app rspec -f documentation
