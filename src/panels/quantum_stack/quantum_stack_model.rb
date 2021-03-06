require 'descriptor_model_factory'
require 'application_model'
require 'ensure_json'
#  model for the tree to do the quantum stack
class QuantumStackModel < ApplicationModel
  attr_accessor :substacks, :stack_translation, :stackaddress, :bottom
  attr_reader :descriptor
  alias bottom? bottom

  def quantum_stack; end

  def quantum_stack=(in_qstack)
    raise ModelCreateError, 'QuantumStack: Missing Stack Translation' if @stack_translation.nil?
    return unless in_qstack

    @preferred_size = nil
    decode_stack_data in_qstack
  end

  def decode_stack_data(in_qstack)
    qpp = EnsureJSON.new(in_qstack).as_json
    @bottom = qpp.key?(:bottom)
    @substacks = []
    return if bottom?

    save_values_from_stack(qpp[:qstack])
  end

  def make_substacks(qs_json)
    return nil unless qs_json[:substacks]

    qs_json[:substacks].map do |ss|
      q = QuantumStackModel.new
      q.stack_translation = @stack_translation
      q.quantum_stack = ss
      q
    end
  end

  def descriptor=(json_descriptor)
    @descriptor = DescriptorModelFactory.make_model json_descriptor
    @descriptor.class.validate_substacks_count(@substacks)
    @descriptor.name = make_name(:use_stack_address)
  end

  def make_name(formatting)
    nm = @stack_translation.reverse_lookup(@stackaddress).to_s
    nm += "(#{@stackaddress})" if nm != @stackaddress.to_s && formatting == :use_stack_address
    nm = '' if nm == '-1'
    nm
  end

  private

  def save_values_from_stack(the_stack)
    @stackaddress = the_stack[:id]
    @on_diagonal = the_stack[:diagonal]
    @substacks = make_substacks(the_stack)
    self.descriptor = the_stack[:qnode]
  end
end
