%w[/src /lib/java lib/ruby devlib/ruby out/lqpl_gui].each do |subdir|
  $LOAD_PATH << __dir__ + subdir
end

require 'java'

%w[/lib/java/jruby-complete.jar /lib/java/monkeybars-1.3.3.jar /lib/java/foxtrot-core-4.0.jar].each do |sub|
  $CLASSPATH <<  __dir__ + sub
end
# $CLASSPATH << File.expand_path(File.dirname(__FILE__))+"/out/production/lqpl_gui"

# test to see if running gives edt violations
# uncomment down to 'end testing of edt violations'
# %w{fest-swing-1.2 fest-assert-1.2 fest-reflect-1.2
#    fest-util-1.1.2 jcip-annotations-1.0}.each do |jar|
#   $CLASSPATH << File.expand_path(File.dirname(__FILE__))+"/devlib/java/" + jar+".jar"
# end
# puts $CLASSPATH
#
# require "devlib/java/fest-swing-1.2.jar"
#
#
# require '/Users/gilesb/programming/mixed/lqpl/GUI/devlib/ruby/fest_testing_imports'
# end testing of edt violations

require 'monkeybars-1.3.3.jar'
require 'utility/swing_runner'

ENV['PATH'] = File.expand_path("#{File.dirname(__FILE__)}/bin") +
              "#{File::PATH_SEPARATOR}#{ENV['PATH']}"

begin
  com.drogar.lqpl.Main.main([''].to_java(:string))
rescue StandardError => e
  puts "Had a problem: #{e}"
end
