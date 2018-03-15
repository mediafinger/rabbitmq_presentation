#!/usr/bin/env puma
# frozen_string_literal: true

require_relative "config.rb" unless defined? Config
directory Config.root

# Set the environment in which the rack's app will run. The value must be a string. Default is "development"
# environment "production"

# Configure "min" to be the minimum number of threads to use to answer
# requests and "max" the maximum.
#
# The default is "0, 16".
#
threads 0, 8

# Set the port puma listens to
port 4566

# Load "path" as a rackup file
rackup "config.ru"
