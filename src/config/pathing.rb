class Pathing
  JAR_PREFIX = 'uri:classloader:'.freeze

  DIRECTORIES = %w[communications config dialogs dialogs/about dialogs/simulate_results drawing exceptions forms lqpl
                   painting panels panels/classical_stack panels/dump panels/executing_code
                   panels/quantum_stack panels/quantumstack/descriptor panels/stack_translation
                   panels/utility].freeze


  attr_reader :pathing_location

  def self.add_to_loadpath
    return if @loadpath_set

    @loadpth_set = true
    base_path = File.realpath(__dir__ + '/..')
    DIRECTORIES.each { |d| $LOAD_PATH.unshift(File.join(base_path, d)) }
  end

  def initialize
    @pathing_location = __dir__
  end

  def base_path
    File.expand_path(__dir__ + '/..')
  end
end
