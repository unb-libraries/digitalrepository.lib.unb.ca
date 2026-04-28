# https://github.com/sidekiq-cron/sidekiq-cron
Sidekiq::Cron.configure do |config|
  config.cron_poll_interval = 60
  config.cron_schedule_file = "config/cron.yml"
end
