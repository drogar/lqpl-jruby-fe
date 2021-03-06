require 'panel_controller'
require 'stack_translation_controller'
require 'quantum_stack_model'
require 'quantum_stack_view'

#  controls the drawing of the tree to do the quantum stack
class QuantumStackController < PanelController
  set_model 'QuantumStackModel'
  set_view 'QuantumStackView'

  def update_data_from_lqpl_model(lqpl_model)
    set_quantum_stack(lqpl_model.tree_depth_spinner.int_value,
                      lqpl_model.recursion_spinner.int_value,
                      StackTranslationController.instance.stack_translation)
  end

  def update_on_lqpl_model_trim
    true
  end

  private

  def set_quantum_stack(tree_depth, recursion_depth, stack_trans)
    model.stack_translation = stack_trans
    model.quantum_stack =
      lqpl_emulator_server_connection.get_qstack(recursion_depth, tree_depth)
    update_view
  end
end
