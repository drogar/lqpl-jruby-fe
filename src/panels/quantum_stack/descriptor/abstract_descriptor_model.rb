require 'application_model'
require 'ensure_json'
# abstract base for the descriptor models
class AbstractDescriptorModel < ApplicationModel
  attr_accessor :value, :name

  def initialize
    super()
  end

  def substack_labels
    nil
  end

  def scalar?
    false
  end
end
