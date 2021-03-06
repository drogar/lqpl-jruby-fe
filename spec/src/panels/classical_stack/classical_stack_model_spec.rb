require 'classical_stack_model'

describe ClassicalStackModel do
  subject { ClassicalStackModel.new }
  it 'should ignore the stack text being set' do
    subject.classical_stack_text = 'junk'
    expect(subject.classical_stack_text).to eq('')
  end
  it 'should throw an error if given invalid input' do
    expect { subject.classical_stack = 'junk' }.to raise_error JSON::ParserError, /junk/
  end
  it 'should set the text to each item with line returns' do
    subject.classical_stack = '{"cstack":[-27, true, 40, false]}'
    expect(subject.classical_stack_text).to eq('<html>-27<br />true<br />40<br />false</html>')
  end
  it 'should return a list of the values' do
    subject.classical_stack = '{"cstack":[-27, true, 40, false]}'
    expect(subject.to_a).to eq([-27, true, 40, false])
  end
end
