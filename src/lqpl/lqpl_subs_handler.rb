java_import java.awt.event.WindowEvent
require 'about_controller'
require 'exit_handler'

# Handle the dialogs in lqpl
class LqplSubsHandler
  attr_accessor :subs

  def initialize(controllers)
    @subs = controllers.reduce([]) { |acc, elem| acc << elem.instance }
  end

  def dispose_all
    @subs&.each(&:dispose)
  end

  def open
    @subs.each(&:open)
  end

  def update_and_open(model)
    @subs.each do |sc|
      sc.update_data_from_lqpl_model(model)
      sc.open
    end
  end

  def update_all(model)
    @subs.each { |sc| sc.update_data_from_lqpl_model(model) }
  end

  def update_on_trim(model)
    @subs.each do |sc|
      sc.update_data_from_lqpl_model(model) if sc.update_on_lqpl_model_trim
    end
  end
end
