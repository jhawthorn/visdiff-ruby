require 'visdiff/test_run'

module Visdiff::Minitest
  def self.included(klass)
    visdiff = Visdiff::TestRun.new
    mod = Module.new
    mod.send(:define_method, :visdiff) { visdiff }
    klass.send(:extend, mod)
    klass.send(:include, mod)

    submit_proc = lambda do
      visduff.submit!
    end

    if Minitest.respond_to?(:after_run)
      Minitest.after_run(&submit_proc)
    else
      # old, issues a warning on new versions of minitest
      MiniTest::Unit.after_tests(&submit_proc)
    end
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

