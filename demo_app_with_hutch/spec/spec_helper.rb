# frozen_string_literal: true

ENV["RACK_ENV"] ||= "test"

require_relative "../settings.rb" unless defined? Settings

require File.expand_path("#{Settings.root}/app.rb", __FILE__)
