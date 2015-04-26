require 'visdiff/test_run'

module Visdiff::Minitest
  def self.included(klass)
    visdiff = Visdiff::TestRun.new
    mod = Module.new
    mod.send(:define_method, :visdiff) { visdiff }
    klass.send(:extend, mod)
    klass.send(:include, mod)
  end

  def observe!(identifier)
    visdiff.observe_page(identifier, page)
  end

  def after_teardown
    if !passed? && visdiff.enabled?
      warn "Disabling visdiff due to test failure"
      visdiff.enabled = false
    end
    super
  end
end

