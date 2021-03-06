require 'application_model'

# model to handle the code pointer
class CodePointer < ApplicationModel
  attr_accessor :qpo_method, :line_number

  def initialize(in_string)
    super()
    cp_match = EnsureJSON.new(in_string).as_json
    initialize_method_and_line(cp_match)
  rescue JSON::ParserError => e
    raise e unless in_string == ''

    @qpo_method = ''
    @line_number = 0
  end

  def initialize_method_and_line(cp_match)
    @qpo_method = cp_match[:codepointer][0].to_sym
    @line_number = cp_match[:codepointer][1]
  end

  def normalize(max_plus_one)
    @line_number = if max_plus_one
                     [[@line_number, max_plus_one - 1].min, 0].max
                   else
                     0
                   end
  end

  def mangle_to_selection_key
    "#{@qpo_method}--#{@line_number}"
  end
end
