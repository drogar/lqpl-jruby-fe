# Module for swing interfaces
module Swingtown
  # :stopdoc:
  VERSION = '0.3.0'.freeze
  LIBPATH = __dir__ + ::File::SEPARATOR
  PATH = ::File.dirname(LIBPATH) + ::File::SEPARATOR
  # :startdoc:

  # Returns the version string for the library.
  #
  def self.version
    VERSION
  end

  # Returns the library path for the module. If any arguments are given,
  # they will be joined to the end of the libray path using
  # <tt>File.join</tt>.
  #
  def self.libpath(*args)
    add_to_constant_path(LIBPATH, args)
  end

  # Returns the lpath for the module. If any arguments are given,
  # they will be joined to the end of the path using
  # <tt>File.join</tt>.
  #
  def self.path(*args)
    add_to_constant_path(PATH, args)
  end

  def self.add_to_constant_path(constant, *args)
    args.empty? ? constant : ::File.join(constant, args.flatten)
  end

  def self.copy_over
    require 'fileutils'
    copy_over_ruby
    copy_over_mig
  end

  def self.find_mig_jar(here)
    java_lib_dir = File.join(here, 'java')
    mig_jar = Dir.glob("#{java_lib_dir}/*.jar").find { |f| f =~ /(miglayout-)(.+).jar$/ }
    raise "Failed to find MiG layout jar to copy over from '#{java_lib_dir}'!" unless mig_jar

    mig_jar
  end

  def self.check_java_lib_jar
    java_lib_dir = File.join File.dirname(File.expand_path(__FILE__)), 'java'
    warn java_lib_dir
    java_lib_dir
  end

  def self.copy_over_mig(path = 'lib/java')
    here = File.dirname(File.expand_path(__FILE__))

    mig_jar = find_mig_jar(here)

    file_check_and_warn('miglayout jar', "#{path}/#{mig_jar}")

    FileUtils.mkdir_p path unless File.exist? path
    warn "Have mig jar at #{mig_jar}"
    FileUtils.cp_r mig_jar, path, verbose: true
  end

  def self.copy_over_ruby(path = 'lib/ruby')
    here = File.dirname(File.expand_path(__FILE__))

    file_check_and_warn('swingset', "#{path}/swingset")

    FileUtils.mkdir_p path unless File.exist? path
    FileUtils.cp_r "#{here}/swingset", path, verbose: true
    FileUtils.cp_r "#{here}/swingset.rb", path, verbose: true
    FileUtils.cp_r "#{here}/swingset_utils.rb", path, verbose: true
  end

  def self.file_check_and_warn(which, path)
    return unless File.exist? path

    warn "The #{which} file(s) already exists. Remove/rename it/them, and try again."
    exit
  end
end

# EOF
# :nocov:
if $PROGRAM_NAME == __FILE__
  Swingtown.check_java_lib_jar
  warn Neurogami::SwingSet.find_mig_jar "#{java_lib_dir}/*.jar"
end
# :nocov:
