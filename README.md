RouteDog for Ruby on Rails
==========================

RouteDog is a small collection of Rack middlewares to be used with your Ruby On Rails project as a helper to identify not tested routes.

The way that RouteDog knows if you are testing a route is through the Watcher middleware which only runs in Test Environment
and collects the routes that you've called from your Integrational Tests (See Note About Integrational Tests).

The way that RouteDog shows to you a warning is through a middleware called Notifier which only runs in Developement Enviroment.


For What This Is Useful?
------------------------

* It is useful to me :)

* Suppose that you get a contract to work in a project but that was not started by you, you know that it has some tests, also you have seen
the coverage results but you want to live the experience using the application and seeing what route is actually tested and what not.

* You were a Rumble Guy that thought that tests were not necessary? ok, may be this is for you if you don't want to drop all your code.

* Even if you are not planning to write Integrational Tests you can take advantage of the route defined, tested and used report.


Usage
-----

Fetch the gem

    sudo gem install route_dog

Create a file RAILS_ROOT/config/initializers/route_dog.rb and put the lines below (see notes)

    Rails.application.config.middleware.use RouteDog::Middleware::Watcher  if Rails.env.test?

    Rails.application.config.middleware.use RouteDog::Middleware::Notifier if Rails.env.development?

Run your Integrational Tests

Run your application in Development Mode

TODO
----

* Show Notifier warnings for other than regular html responses.
* Rake task to show stadistics about routes defined, used and tested.
* Blocker middleware to disallow not tested routes in Production Environment.
* Blocker middleware also should remove from your page response links to not tested resources.

Notes
-----

* Watcher middleware don't work with Controller Tests, it only works with Integrational Tests except if you are running RSpec, because RSpec
controller tests are an extension of Integrational Tests, but this will be not longer supported by RSpec.

* Watcher and Notifier middlewares may need be loaded after or before another middleware, that is the case if you are using Warden.

    `Rails.application.config.middleware.insert_before Warden::Manager, RouteDog::Middleware::Watcher  if Rails.env.test?`

    `Rails.application.config.middleware.insert_before Warden::Manager, RouteDog::Middleware::Notifier if Rails.env.development?`

* Be sure to call `rake route_dog:clean` once in a while to ensure that the tested route list remains updated.
