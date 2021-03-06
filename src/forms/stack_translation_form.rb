require 'scrollable_label'
require 'import_java'

ImportJava.do_imports(context: self, awt: ['Rectangle'])

# Swing component to display the stack translation structure
class StackTranslationForm < ScrollableLabel
  def initialize
    super('Stack Translation', Rectangle.new(10, 740, 400, 150))
  end

  def stack_translation_text=(new_text)
    the_scrolling_label.text = new_text
  end

  def stack_translation_text
    the_scrolling_label.text
  end
end
