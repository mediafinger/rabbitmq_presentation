# frozen_string_literal: true

ENV["RACK_ENV"] ||= "test"

require_relative "../config.rb" unless defined? Config

require File.expand_path("#{Config.root}/app.rb", __FILE__)
