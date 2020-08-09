file 'Manifest' do
  File.open 'Manifest', 'w' do |f|
    f.puts 'Class-Path: . lib/java/jruby-complete.jar lib/java/monkeybars-1.3.3.jar lib/java/foxtrot-core-4.0.jar'
    f.puts 'Main-Class: com.drogar.lqpl.Main'
  end
end
