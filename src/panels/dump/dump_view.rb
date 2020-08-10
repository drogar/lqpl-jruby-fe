require 'dump_form'
require 'application_view'

# View for the Dump
class DumpView < ApplicationView
  set_java_class DumpForm
  map view: 'dump_text', model: :text
end
