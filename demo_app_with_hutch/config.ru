# frozen_string_literal: true

require_relative "settings.rb" unless defined? Settings
require File.join(Settings.root, "app")

run App
