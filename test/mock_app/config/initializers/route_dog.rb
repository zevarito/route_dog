# Insert this middleware to know from tests what routes aren't tested
Rails.application.config.middleware.use RouteDog::Middleware::Watcher  if Rails.env.test?

# Insert this middleware in development to append html to let the user know if the route is not tested
# Also we add this middleware to test env so that way we can test the whole thing :D
Rails.application.config.middleware.use RouteDog::Middleware::Notifier if Rails.env.test? || Rails.env.development?
