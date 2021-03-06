require 'panel_controller'
require 'classical_stack_model'
require 'classical_stack_view'
# classical stack controller -
class ClassicalStackController < PanelController
  set_model 'ClassicalStackModel'
  set_view 'ClassicalStackView'
  set_close_action :hide

  def update_data_from_lqpl_model(lqpl_model)
    update_classical_stack(lqpl_model.tree_depth_spinner.int_value,
                           lqpl_model.recursion_spinner.int_value)
  end

  def update_classical_stack(tree_depth, recursion_level)
    update_classical_stack_data(lqpl_emulator_server_connection
                             .get_classical_stack(recursion_level, tree_depth))
  end

  def update_classical_stack_data(cs_data)
    model.classical_stack = cs_data
    update_view
  end

  def classical_stack_data
    model.classical_stack_text
  end
end
