# frozen_string_literal: true

require_relative "config.rb" unless defined? Config
require File.join(Config.root, "app")

run App
