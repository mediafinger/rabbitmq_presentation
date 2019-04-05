# Consumer app

Simple example application to demonstrate consuming messages from RabbitMQ.

## Install and run RabbitMQ

Install RabbitMQ: https://www.rabbitmq.com/download.html

Configure the management plugin

    rabbitmq-plugins enable rabbitmq_management

Start the RabbitMQ broker

    rabbitmq-server

In a new terminal check the status (optional, for debugging)

    rabbitmqctl status

Open the management WebUI in the browser and log in as **guest / guest**

**http://localhost:15672/**

## Install and run the app

* `git clone` to your computer
* `bundle install` the gems
* `rake start` the app

In your browser open: http://localhost:4568/ to consume messages.

> You can either add messages to the queue in the RabbitMQ's WebUI, or install the **Publisher** app.

## Rake Tasks

    rake console

Opens IRB with `awesome_print` and the application loaded.

    rake routes

Prints the routes in human readable form.

    rake rspec

Executes the specs.

    rake rubocop

Runs `rubocop --auo-correct`.

    rake rubocop:not_correcting

Runs `rubocop` without autocorrect

    rake start

Starts puma and loads the sinatra app.

    rake test

Runs `rake rubocop:not_correcting` and `rake rspec`. This is the default task.
