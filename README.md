## Hamro Bazar Scraper

### Technology stack

- Rails 6.0.2
- Ruby 2.6.5
- PostgreSQL
- Angular cli 8
- node v13
- redis server
- Sidekiq 6.2.0

### Local development setup

```
git clone https://github.com/Pralish/hamro_bazar_scraper.git
cd hamro_bazar_scraper
bundle install
rails db:create
rails db:migrate db:seed
cd client
npm install
```

##### Running frontend, backend and sidekiq

- Frontend (from client folder): `ng serve`
- API: `rails s`
- Sidekiq: `sidekiq -q default`

Now you can visit the site with the URL http://localhost:4200

#### Testing

## RSpec guidelines

- To run all the test cases in 'spec' folder;
  `rspec`
