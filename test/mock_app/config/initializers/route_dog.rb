Rails.application.config.middleware.use RouteDog::Middleware::Watcher if Rails.env.test?
