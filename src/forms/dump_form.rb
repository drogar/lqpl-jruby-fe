require 'scrollable_label'
require 'import_java'

ImportJava.do_imports(context: self, awt: ['Rectangle'])

# Swing component to display the dump data
class DumpForm < ScrollableLabel
  def initialize
    super('Dump', Rectangle.new(430, 670, 600, 215))
  end

  def dump_text=(new_text)
    the_scrolling_label.text = new_text
  end

  def dump_text
    the_scrolling_label.text
  end
end
