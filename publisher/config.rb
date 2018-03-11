# frozen_string_literal: true

class Config
  def self.fetch_env_var(name, default)
    ENV.fetch(name.to_s.upcase, default)
  end

  # creates attribute and set values from `ENV`,
  # falls back to `default` value when not set
  def self.register(name, default: nil)
    define_singleton_method(name) { instance_variable_get("@#{name}") }
    set(name, fetch_env_var(name, default))
  end

  def self.set(name, value)
    instance_variable_set("@#{name}", value)
  end

  # compare the String value of a Config.setting
  # with the String value of another parameter
  # to avoid mis-comparisons of Boolean or Number with String
  def self.is?(class_var, other_value)
    send(class_var.to_sym).to_s == other_value.to_s
  end

  register :rack_env,   default: "development"
  register :root,       default: __dir__
  register :rabbit_url, default: "amqp://guest:guest@localhost:5672/%2F"
end
