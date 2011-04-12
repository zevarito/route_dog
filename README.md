RouteDog for Ruby on Rails
==========================

**It only works in Rails 3 for now, Rails 2.3 support is comming.**

RouteDog is a small collection of Rack middlewares to be used with your Ruby On Rails project as a helper to identify not tested routes.

The way that RouteDog knows if you are testing a route is through the Watcher middleware which only runs in Test Environment
and collects the routes that you've called from your **Integration Tests** (See Note About Integration Tests).

The way that RouteDog shows to you a warning is through a middleware called Notifier which only runs in Developement Enviroment.

Also it has a report task that give to you a resume about defined, implemented and tested routes of your application.


For What This Is Useful?
------------------------

* It is useful to me :)

* Suppose that you get a contract to work in a project but that was not started by you, you know that it has some tests, also you have seen
the coverage results but you want to live the experience using the application and seeing what route is actually tested and what not.

* You were a Rumble Guy that thought that tests were not necessary? ok, may be this is for you if you don't want to drop all your code.

* Even if you are not planning to write Integration Tests you can take advantage of the route defined, tested and used report.


Usage
-----

### Instalation ###

If you are using Bundler

    gem 'route_dog'

If you are not using Bundler

    config.gem 'route_dog'


### Get a report of defined, implemented and tested routes ###

Run your *Integration Tests* and then call a report

    rake route_dog:report

![Route Report Example](http://img.skitch.com/20101103-p79s1css147a6tymt1i6mcanm7.jpg "Route Report Example")


### Browsing your application in Development ###

This will be appended to your application response

![Notifier Example](http://img.skitch.com/20101103-trxeweg66jh931qtpunh9u91gk.jpg "Notifier Example")


### Clean collected tested routes ###

This is useful if you had a test passing and then you remove the test from your codebase,
very uncommon, but here is the command.

    rake route_dog:clean


TODO
----

* Rails 2.3 support.
* Show Notifier warnings for other than regular html responses.
* Generator to extract route_dog.yml config file, so you can disable the middlewares you don't want.

Notes
-----

* Watcher middleware don't work with Controller Tests, it only works with Integration Tests.

DEVELOPMENT
-----------

If you are planning to contribute to this gem, please read the following advice.

Once you have pulled the source code do this...

    cd test/mock_app
    bundle install

Then you can run the tests...

    rake

Copyright
---------

Copyright © 2010 Alvaro Gil. See LICENSE for details.


Thanks
------

dcadenas, foca and spastorino for beign responsive to my questions.
