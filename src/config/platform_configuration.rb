# Platform specific operations, feel free to remove or override any of these
# that don't work for your platform/application

require 'config/architecture_category'
require 'config/testing_fest'

class PlatformConfiguration
  attr_reader :arch, :tester

  def initialize(arch = ArchitectureCategory.new, tester = TestingFest.new)
    @arch = arch
    @tester = tester
    set_menubar_if_not_testing
  end

  def on_mac
    yield if arch.mac?
  end

  def on_win
    yield if arch.windows?
  end

  def on_linux
    yield if arch.linux?
  end

  def not_on_mac
    yield if !arch.mac? || tester.testing?
  end

  private

  def set_menubar_if_not_testing
    return if tester.testing?

    on_mac do
      java.lang.System.set_property('apple.laf.useScreenMenuBar', 'true')
    end
  end
end
