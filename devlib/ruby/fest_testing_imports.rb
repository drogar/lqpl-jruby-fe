java.lang.System.set_property('apple.laf.useScreenMenuBar', 'false')
java.lang.System.set_property('com.drogar.testing.fest', 'true')

%w[GuiActionRunner GuiQuery GuiTask FailOnThreadViolationRepaintManager].each do |c_name|
  java_import "org.fest.swing.edt.#{c_name}"
end

java_import org.fest.swing.core.BasicRobot
java_import org.fest.swing.finder.WindowFinder

%w[Component JMenuItem Frame JTextComponent JSpinner JLabel JButton JFileChooser].each do |fixture_name|
  java_import "org.fest.swing.fixture.#{fixture_name}Fixture"
end

%w[JButton JLabel Frame Dialog].each do |matcher_name|
  java_import "org.fest.swing.core.matcher.#{matcher_name}Matcher"
end

# FailOnThreadViolationRepaintManager.install()
