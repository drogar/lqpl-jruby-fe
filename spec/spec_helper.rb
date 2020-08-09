# require_relative '../GUI/src/config/manifest'
require 'java'
require 'english'
require 'simplecov'

SimpleCov.merge_timeout 1200

SimpleCov.start do
  add_filter 'spec/'
  add_group 'DevLib', 'devlib'
  add_group 'Lib', 'lib'
  add_group 'Communications', 'src/communications'
  add_group 'Config', 'src/config'
  add_group 'Dialogs', 'src/dialogs'
  add_group 'Drawing', 'src/drawing'
  add_group 'Forms', 'src/forms'
  add_group 'Exceptions', 'src/exceptions'
  add_group 'Forms', 'src/forms'
  add_group 'Main', 'src/lqpl'
  add_group 'Painting', 'src/painting'
  add_group 'Panels', 'src/panels'
  add_group 'Utility', 'src/utility'
  add_filter 'features/'
  nocov_token 'nocov'
end

# Override at_exit so that rspec actually terminates properly.
# puts did not seem to work consistently, so using err.println
# result.format! sometimes prints a line as well, but not always.

SimpleCov.at_exit do
  status = $ERROR_INFO.is_a?(::SystemExit) ? $ERROR_INFO.status : 0
  SimpleCov.result.format!
  java.lang.System.err.println "SimpleCov report generated,
          covered #{SimpleCov.result.covered_lines} lines of
          #{SimpleCov.result.total_lines} for a coverage of
          %#{SimpleCov.result.covered_percent}."
  begin
    # SwingRunner::on_edt do
    LqplController.instance.close
    # end
  rescue NameError
    puts("No lqpl controller defined yet")
  end

  java.lang.System.exit(status)
end

project_dir_array = __dir__.split(File::SEPARATOR)

project_dir = project_dir_array.reverse.drop(1).reverse.join(File::SEPARATOR)

$LOAD_PATH << project_dir

%w[src lib/java lib/ruby devlib/java devlib/ruby].each do |dir|
  $LOAD_PATH << project_dir + '/' + dir
end

# java classpath
$CLASSPATH << project_dir + '/lib/java/jruby-complete.jar'
$CLASSPATH << project_dir + '/lib/java/foxtrot-core-4.0.jar'
$CLASSPATH << project_dir
$CLASSPATH << project_dir + '/out/lqpl_gui/'

# testing jars
%w[fest-swing-1.2 fest-assert-1.2 fest-reflect-1.2
   fest-util-1.1.2 jcip-annotations-1.0].each do |jar|
  $CLASSPATH << project_dir + '/devlib/java/' + jar + '.jar'
end

require 'java'
require 'fest-swing-1.2.jar'

# $CLASSPATH << project_dir + '/lib/java/monkeybars-3.3.3.jar'

require 'fest_testing_imports'
require 'monkeybars'

require 'config/manifest'
require 'utility/logger'
require 'config/pathing'
require 'swing_runner'
require 'lqpl_controller'

#require_relative '../src/config/manifest'

TEST_QP_PATH = project_dir + '/testdata/qplprograms'

# require 'config/platform_configuration'

#    require 'component_query'
#    require 'drawing_extensions'
#    require 'raster_queries'

RSpec.configure do |conf|
  conf.mock_with :rspec do |c|
    c.syntax = :expect
  end
end

def last(arr)
  arr[arr.size - 1]
end
