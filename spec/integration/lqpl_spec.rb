puts $LOAD_PATH
require 'lqpl_controller'
require 'swing_runner'

# local class to run items in event thread
class Drunner < GuiQuery
  # Launch the app in the Event Dispatch Thread (EDT),
  # which is the thread reserved for user interfaces.
  # FEST will call this method for us before the test.
  #
  def initialize(lqplinst)
    super()
    @l = lqplinst
  end

  def execute_in_edt
    @l.load
    @l.file_compile_action_performed
  end
  alias executeInEDT execute_in_edt
end

describe LqplController do
  before :each do
    SwingRunner.on_edt do
      @l = LqplController.instance
    end
  end
  describe 'after load' do
    before :each do
      SwingRunner.on_edt do
        @l.load
      end
    end
    context 'sub_controllers' do
      specify { expect(@l.sub_controllers_handler).not_to be_nil }
    end
    context 'dialogs' do
      specify { expect(@l.dialogs_handler).not_to be_nil }
    end
    context 'the compiler server' do
      specify { expect(@l.cmp).not_to be_nil }
      # specify { expect(@l.cmp).to be_connected }
      # Does not work when run in a full run. Does when run individually.
    end
    context 'the emulator server' do
      specify { expect(@l.lqpl_emulator_server_connection).to be_connected }
    end
  end
  describe 'file_exit' do
    it 'closes the server connection' do
      SwingRunner.on_edt do
        @l.load
        @l.file_exit_action_performed
      end
      expect(@l.cmp).not_to be_connected
      expect(@l.lqpl_emulator_server_connection(connect: false)).not_to be_connected
    end
  end
  describe 'sub handlers' do
    let(:dh) { double('dh') }
    let(:sh) { double('sh') }
    subject { @l }
    before :each do
      subject.sub_controllers_handler = sh
      subject.dialogs_handler = dh
      allow(dh).to receive(:dispose_all)
      allow(sh).to receive(:dispose_all)
    end
    after :each do
      subject.sub_controllers_handler = nil
      subject.dialogs_handler = nil
    end
    describe 'close' do
      it 'closes the server connection' do
        subject.load
        subject.close
        expect(subject.cmp).not_to be_connected
        expect(subject.lqpl_emulator_server_connection(connect: false)).not_to be_connected
      end
    end
    describe 'initialize_sub_controllers' do
      it 'should call update_and_open on subs' do
        expect(dh).to_not receive(:update_and_open)
        expect(sh).to receive(:update_and_open)
        subject.initialize_sub_controllers
      end
    end
  end
end
