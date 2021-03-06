require 'simplecov'

SimpleCov.merge_timeout 1200

SimpleCov.start do
  add_filter 'GUI/spec/'
  add_filter 'spec/'
  add_group 'DevLib', 'GUI/devlib'
  add_group 'Lib', 'GUI/lib'
  add_group 'Communications', 'GUI/src/communications'
  add_group 'Config', 'GUI/src/config'
  add_group 'Dialogs', 'GUI/src/dialogs'
  add_group 'Drawing', 'GUI/src/drawing'
  add_group 'Forms', 'GUI/src/forms'
  add_group 'Exceptions', 'GUI/src/exceptions'
  add_group 'Forms', 'GUI/src/forms'
  add_group 'Main', 'GUI/src/lqpl'
  add_group 'Painting', 'GUI/src/painting'
  add_group 'Panels', 'GUI/src/panels'
  add_group 'Utility', 'GUI/src/utility'
  add_filter 'features/'
  nocov_token ':nocov:'
end

unless defined? RUBY_ENGINE && RUBY_ENGINE == 'jruby'
  abort 'Sorry - Feature tests of LQPL requires JRuby. '\
        'You appear to be running or defaulted to some other ruby engine.'
end

project_dir_array = __dir__.split(File::SEPARATOR)

project_dir = project_dir_array.reverse.drop(2).reverse.join(File::SEPARATOR)

%w[/src /lqpl_gui /lib/java /lib/ruby /devlib/java /devlib/ruby /out/lqpl_gui].each do |dir|
  $LOAD_PATH << project_dir + dir
end

require 'java'

$CLASSPATH << "#{project_dir}/out/lqpl_gui"

# runtime  and testing
%w[jruby-complete monkeybars-1.3.3 foxtrot-core-4.0].each do |jar|
  $CLASSPATH << "#{project_dir}/lib/java/#{jar}.jar"
end

%w[fest-swing-1.2 fest-assert-1.2 fest-reflect-1.2
   fest-util-1.1.2
   jcip-annotations-1.0].each do |jar|
  $CLASSPATH << "#{project_dir}/devlib/java/#{jar}.jar"
end

require 'fest-swing-1.2.jar'

require 'monkeybars-1.3.3.jar'

ENV['PATH'] = "#{project_dir}/out/bin#{File::PATH_SEPARATOR}#{ENV['PATH']}"

require 'fest_testing_imports'

require 'config/platform_configuration'

require 'config/manifest'

java_import java.util.regex.Pattern

java_import java.awt.Component

require 'component_query'
