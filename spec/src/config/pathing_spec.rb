require 'config/pathing'

BASE_PATH = '/Users/gilesb/Dropbox/programming/mixed/lqpl-fe-jruby/src'.freeze

describe Pathing do
  it 'is valid' do
    expect(Pathing).not_to be_nil
  end
  describe 'set_loadpath' do
    %w[communications config dialogs dialogs/about dialogs/simulate_results drawing exceptions
       forms forms/components forms/dialogs forms/generic
       lqpl painting
       panels panels/classical_stack panels/dump panels/executing_code
       panels/quantum_stack panels/quantum_stack/descriptor panels/stack_translation
       utility].each do |dir|
      it "contains the #{dir} subdir" do
        Pathing.initialize_loadpath
        expect($LOAD_PATH).to include(BASE_PATH + '/' + dir)
      end
    end
  end
  describe 'instance methods' do
    subject { Pathing.new }
    let(:here) { __dir__ }
    describe :pathing_location do
      it 'is the path of the pathing.rb file' do

      end
    end
    describe :base_path do
      it 'is the path of the source co' do
        expect(subject.base_path).to(
          eq(BASE_PATH)
        )
      end
    end
  end
end
