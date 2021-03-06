require 'application_controller'
# Controller for the about dialog
class AboutController < ApplicationController
  set_model 'AboutModel'
  set_view 'AboutView'
  set_close_action :dispose

  def handle_about(_about_event)
    open
  end

  alias handleAbout handle_about

  def ok_button_action_performed
    dispose
  end
end
