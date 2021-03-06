class Pathing
  JAR_PREFIX = 'uri:classloader:'.freeze

  DIRECTORIES = %w[communications config dialogs dialogs/about dialogs/simulate_results drawing exceptions
                   forms forms/components forms/dialogs forms/generic
                   lqpl painting
                   panels panels/classical_stack panels/dump panels/executing_code
                   panels/quantum_stack panels/quantum_stack/descriptor panels/stack_translation
                   utility].freeze

  attr_reader :pathing_location

  def self.initialize_loadpath
    return if @loadpath_set

    @loadpth_set = true
    base_path = File.realpath("#{__dir__}/..")
    DIRECTORIES.each { |d| $LOAD_PATH.unshift(File.join(base_path, d)) }
  end

  def initialize
    @pathing_location = __dir__
  end

  def base_path
    File.expand_path("#{__dir__}/..")
  end
end
