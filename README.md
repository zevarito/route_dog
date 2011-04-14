RouteDog for Ruby on Rails
==========================

**It only works in Rails 3 for now, Rails 2.3 support is comming.**

RouteDog does the following things for you:

* Identify routes that has been defined in config/routes.rb but hasn't been implemented.

* Identify which routes of your application were never hitted by a Integration Test.

* Notify you which actions hasn't been tested while you are using your application by injecting html on the top of the page.


For What This Is Useful?
------------------------

* Suppose that you get a contract to work in a project but that was not started by you, you know that it has some tests, also you have seen
the coverage results but you want to live the experience using the application and seeing which route is actually tested and which route don't.

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

Run your **Integration Tests** and then ask for a report

    rake route_dog:report

![Route Report Example](http://img.skitch.com/20101103-p79s1css147a6tymt1i6mcanm7.jpg "Route Report Example")


### Browsing your application in Development ###

Create a file called route_dog.yml under your config directory.

    ---
    watcher:
      env:
        - test
    notifier:
      env:
        - test
        - development


This will be appended to your application response

![Notifier Example](http://img.skitch.com/20101103-trxeweg66jh931qtpunh9u91gk.jpg "Notifier Example")


### Clean collected tested routes ###

This is useful if you had a test passing and then you remove the test from your codebase,
*very uncommon*, and it should not be treated as a passing test anymore, here is the command.

    rake route_dog:clean


Notes
-----

* Watcher middleware don't work with Controller Tests, it only works with Integration Tests.

Development
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
