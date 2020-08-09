require 'ant'
$LOAD_PATH << Dir.pwd
require 'src/lqpl_version'
require 'config/build_config'
require 'rspec/core/rake_task'

directory 'out/bin'
directory 'out/lqpl_gui'
directory 'out/lib/java'

redist_jars = FileList.new('lib/java/*')

build = namespace :build do
  desc 'Copy JRuby files in preparation for JAR'
  task copy_jruby: 'out/lqpl_gui' do
    ant.copy todir: 'out/lqpl_gui' do
      fileset dir: 'src', excludes: '**/*.java'
      fileset dir: 'lib/ruby'
    end
  end
  desc 'Compile java files in preparation for JAR'
  task compile: 'out/lqpl_gui' do
    ant.javac srcdir: 'src', destdir: 'out/lqpl_gui', includeAntRuntime: 'no',
              classpath: 'lib/java/jruby-complete.jar:lib/java/monkeybars-1.1.1.jar'
  end
  desc 'Make a jar'
  task jar: ['out', 'Manifest', :compile, :copy_jruby] do
    ant.jar destfile: 'out/lqpl_gui.jar', basedir: 'out/lqpl_gui', manifest: 'Manifest'
  end
  desc 'Build the lqpl system'
  task all: [:jar, :server, 'out/lib/java'] do
    redist_jars.each { |jar| cp jar, 'out/lib/java/', preserve: true }
  end
end
mac = false
case RbConfig::CONFIG['host_os']
when /darwin/i # OSX specific code
  tech = 'x86_64-apple-darwin'
  tar_options = '--disable-copyfile'
  mac = true
when /^win|mswin/i # Windows specific code
  tech = 'x86_32-mswin'
  tar_options = ''
when /linux/i # Linux specific code
  tech = 'x86_64-linux'
  tar_options = ''
end

directory 'out'
directory "out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}/bin"
directory "out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}/lib/java"
directory "out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-source"

directory 'out/LQPLEmulator.app/Contents/MacOS'
directory 'out/LQPLEmulator.app/Contents/PkgInfo'
directory 'out/LQPLEmulator.app/Contents/Resources/Java/bin'
directory 'out/LQPLEmulator.app/Contents/Resources/Java/lib'

namespace :dist do
  bin_dist_includes = FileList.new
  DIST_INCLUDES.each { |incf| bin_dist_includes.include(incf) }

  source_dist_files = FileList.new('./*', './.*')
  EXCLUDE_FROM_SOURCE_DIST.each { |exf| source_dist_files.exclude(exf) }

  desc "Make a #{tech} binary distribution"
  task binary: ["out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}/bin",
                "out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}/lib/java",
                build[:all]] do
    cp 'out/lqpl_gui.jar', "out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}/",
       preserve: true

    redist_jars.each do |jar|
      cp jar, "out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}/lib/java", preserve: true
    end
    bin_dist_includes.each do |f|
      cp_r f.to_s, "out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}/", preserve: true
    end
    copy_server_bin "out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}/bin/"
    $stdout << "Creating tar file: lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}.tgz\n"
    sh "(cd out ; tar #{tar_options} -czf lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech}.tgz "\
       " lqpl-#{LqplVersion::LQPL_GUI_VERSION}-bin-#{tech})"
  end

  desc 'Make a source distribution'
  task source: ["out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-source"] do
    source_dist_files.each do |gsource|
      cp_r(gsource.to_s, "out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-source", preserve: true)
    end
    $stdout << "Creating tar file: out/lqpl-#{LqplVersion::LQPL_GUI_VERSION}-source.tgz\n"
    sh "(cd out ; tar #{tar_options} -czf lqpl-#{LqplVersion::LQPL_GUI_VERSION}-source.tgz"\
       " lqpl-#{LqplVersion::LQPL_GUI_VERSION}-source)"
  end

  if mac
    task mac_dirs: ['out/LQPLEmulator.app/Contents/MacOS',
                    'out/LQPLEmulator.app/Contents/PkgInfo',
                    'out/LQPLEmulator.app/Contents/Resources/Java/bin',
                    'out/LQPLEmulator.app/Contents/Resources/Java/lib']
    desc 'make a mac app'
    task mac_app: [:mac_dirs, build[:all]] do
      cp '/System/Library/Frameworks/JavaVM.framework/'\
         'Versions/A/Resources/MacOS/JavaApplicationStub',
         'out/LQPLEmulator.app/Contents/MacOS/'
      sh 'chmod +x out/LQPLEmulator.app/Contents/MacOS/JavaApplicationStub'
      cp 'config/Info.plist', 'out/LQPLEmulator.app/Contents/'
      cp 'icons/lqpl.icns', 'out/LQPLEmulator.app/Contents/Resources'
      cp 'out/lqpl_gui.jar', 'out/LQPLEmulator.app/Contents/Resources/Java'
      cp_r 'lib/java', 'out/LQPLEmulator.app/Contents/Resources/Java/lib/'
      copy_server_bin 'out/LQPLEmulator.app/Contents/Resources/Java/bin/'
    end
  end
end

namespace :test do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.rspec_opts = '--color'
    t.ruby_opts = '--debug -I.'
  end

  desc 'Run specs after ensuring jar is built'
  task spec: [build[:jar]]

  desc 'Run all tests'
  task all: %i[features spec]

  begin
    require 'cucumber'
    require 'cucumber/rake/task'
    Cucumber::Rake::Task.new(:features) do |t|
      t.cucumber_opts = '--format pretty'
      t.profile = 'all'
    end
    task features: [build[:all]]
  rescue LoadError
    desc 'Cucumber rake task not available'
    task :features do
      abort 'Cucumber rake task is not available. Install cucumber as a gem.'
    end
  end
end

namespace :run do
  desc 'Run lqpl, ensuring all built'
  task lqpl: [build[:all]] do
    sh '(cd out; java -Xdock:name=LQPL -Xdock:icon=../icons/lqpl_icon.tiff -Xmx1G'\
       " -Xms256M -jar lqpl_gui.jar -cp #{redist_jars.to_s.tr!(' ', ':')})"
  end
end

def copy_executable_dir(from_dir, to_dir)
  %w[lqpl lqpl-emulator lqpl-compiler-server].each do |subdir|
    cp "#{from_dir}/#{subdir}", to_dir.to_s
    sh "chmod +x #{to_dir}/#{subdir}"
  end
end
