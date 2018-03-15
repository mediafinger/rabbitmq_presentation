# frozen_string_literal: true

require_relative "../config.rb"

RSpec.describe Config do
  before do
    described_class.register :some_test_rack_env,    default: ENV["RACK_ENV"] || "development"
    described_class.register :some_test_root,        default: __dir__
    described_class.register :some_test_url,         default: "amqp://guest:guest@localhost:5672/%2F"

    described_class.register :some_test_default,     default: "development" || ENV["RACK_ENV"]
    described_class.register :some_test_bootup_time, default: Time.now
    described_class.register :some_test_false,       default: false
    described_class.register :some_test_true,        default: true
    described_class.register :some_test_number,      default: 5
    described_class.register :some_test_string,      default: "This is a test"
  end

  it "tests some current setup values", :aggregate_failures do
    expect(described_class.some_test_rack_env).to    eq("test")
    expect(described_class.some_test_root).to        match %r{.+/hutch_publisher/spec}
    expect(described_class.some_test_url).to         eq("amqp://guest:guest@localhost:5672/%2F")

    expect(described_class.some_test_default).to     eq("development")
    expect(described_class.some_test_bootup_time).to be_an_instance_of(Time)
    expect(described_class.some_test_false).to       eq(false)
    expect(described_class.some_test_true).to        eq(true)
    expect(described_class.some_test_number).to      eq(5)
    expect(described_class.some_test_string).to      eq("This is a test")

    expect(described_class.some_test_bootup_time).to be_a(Time)
    expect(described_class.some_test_false).to       be_a(FalseClass)
    expect(described_class.some_test_true).to        be_a(TrueClass)
    expect(described_class.some_test_number).to      be_a(Integer)
    expect(described_class.some_test_string).to      be_a(String)

    expect(described_class.is?(:some_test_false, false)).to   eq true
    expect(described_class.is?(:some_test_false, "false")).to eq true
    expect(described_class.is?(:some_test_true, true)).to     eq true
    expect(described_class.is?(:some_test_true, "true")).to   eq true
    expect(described_class.is?(:some_test_number, 5)).to      eq true
    expect(described_class.is?(:some_test_number, "5")).to    eq true
  end
end
