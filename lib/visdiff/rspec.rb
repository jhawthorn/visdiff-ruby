require 'visdiff/test_run'

require 'rspec/core'

module Visdiff::RSpec
  def observe!(identifier)
    visdiff.observe_page(identifier, page)
  end

  def visdiff
    RSpec.configuration.visdiff
  end
end

RSpec.configure do |c|
  visdiff = Visdiff::TestRun.new

  c.add_setting :visdiff
  c.visdiff = visdiff

  c.after(:each) do |example|
    if example.exception && visdiff.enabled
      warn "Disabling visdiff due to test failure"
      visdiff.enabled = false
    end
  end

  c.after(:suite) do
    visdiff.submit!
  end

  c.include Visdiff::RSpec
end
