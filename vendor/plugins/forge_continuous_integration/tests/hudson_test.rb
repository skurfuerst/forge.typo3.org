require 'test/unit'
require "vendor/plugins/forge_continuous_integration/app/models/hudson"

class HudsonTest <  Test::Unit::TestCase

  def test_readwrite
    hudson = Hudson.new('bla')
    assert hudson.disabled
    hudson.enabled = true
    assert (! hudson.disabled)
  end
end
