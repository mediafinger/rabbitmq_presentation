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

To publish either start the UI with `rake server` or start `rake console` (which loads _app.rb_) and send a message like this:

    publish(routing_key: "barcelona.ruby.event", message: { message: "A man, a plan, a canal panama!"})

Then open RabbitMQ's management WebUI to check that a message was sent.

> You can also handle messages and add new messages to the queues in RabbitMQ's WebUI at http://localhost:15672/

### Consumer setup

Check _hutch_consumer_config.rb_ which should be loaded before publishing in the separate hutch process

### Publisher setup

Check _hutch_publisher_config.rb_ which will be loaded in the app

### Shared hutch setup

Check _hutch_shared_config.rb_ which has to be the same for all publishers and all consumers

## Rake Tasks

### hutch / consumer

    rake hutch

Runs `hutch --require hutch_consumer_config.rb`. Without this there won't be any queues defined! Consumers only start consuming after hutch is started **(a consumer)**. Start this first and then either `rake console` or `rake server`.  
_Alias:_ `rake consumer`

### console / publisher

    rake console

Opens IRB with `awesome_print` and the application loaded **(a publisher)**.  
_Alias:_ `rake publisher`

### server / sinatra

    rake server

Starts puma and loads the sinatra server **(a publisher)**. Open http://0.0.0.0:4500/  
_Alias:_ `rake sinatra`

### routes
    rake routes

Prints the routes in human readable form.

### rspec

    rake rspec

Executes the specs.

### rubocop

    rake rubocop

Runs `rubocop`

### rubocopa

    rake rubocopa

Runs `rubocop --auto-correct`.

### test

    rake test

Runs the tasks `rubocop` and `rspec`. This is the _default_ task.
