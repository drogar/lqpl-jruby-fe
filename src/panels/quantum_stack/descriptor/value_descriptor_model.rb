require 'abstract_descriptor_model'

# value node model
class ValueDescriptorModel < AbstractDescriptorModel
  def self.validate_substacks_count(substacks)
    return unless substacks
    raise ModelCreateError, 'Value element should not have substacks' unless substacks.empty?
  end

  def initialize(in_string)
    super()
    value_hash = EnsureJSON.new(in_string).as_json
    @value = value_hash[:value]
    raise ModelCreateError, "Bad VALUE: #{in_string}" unless @value&.is_a?(Numeric)

    @name = nil
  end

  def length
    0
  end

  def scalar?
    true
  end
end
