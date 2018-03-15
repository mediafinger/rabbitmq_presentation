# Hutch app

Simple example to demonstrate publishing and consuming messages from RabbitMQ with the Hutch framework.

## Install and run RabbitMQ

Install RabbitMQ: https://www.rabbitmq.com/download.html

Configure the management plugin

    rabbitmq-plugins enable rabbitmq_management

Start the RabbitMQ broker

    rabbitmq-server

In a new terminal check the status (optional, for debugging)

    rabbitmqctl status

Open the management **WebUI** in the browser and log in as **guest / guest**

**http://localhost:15672/**

## Install and run the app

* `git clone` to your computer
* `bundle install` the gems
* `rake hutch` to create queues and start consumers

> You can check, handle and add messages to the queue in the RabbitMQ's WebUI

To publish open: `bundle exec rake console` which loads _app.rb_

### Consumer setup

Check _hutch_consumer_config.rb_ which should be loaded before publishing in the separate hutch process

### Publisher setup

Check _hutch_publisher_config.rb_ which will be loaded in the app

### Shared hutch setup

Check _hutch_shared_config.rb_ which has to be the same for all publishers and all consumers

## Rake Tasks

    rake console

Opens IRB with `awesome_print` and the application loaded.

    rake hutch

Runs `hutch --require hutch_consumer_config.rb`. Without this there won't be any queues defined! Consumers only start consuming after hutch is started.
