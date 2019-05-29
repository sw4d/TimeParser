require 'rspec'
require_relative 'affiniPaySample'

describe 'Qucik test to verify time conversion funciton working', type: :unit do
  it 'Adds time to original value' do
    expect(add_minutes('2:15 PM', 65)).to eq('3:20 PM')
    expect(add_minutes('7:32 AM', 31)).to eq('8:03 AM')
  end

  it 'Converts from PM/AM, AM/PM' do
    expect(add_minutes('9:50 PM', 180)).to eq('12:50 AM')
    expect(add_minutes('11:50 AM', 20)).to eq('12:10 PM')
  end

  it 'Returns same result if no minutes added' do
    expect(add_minutes('9:50 PM', 0)).to eq('9:50 PM')
  end
end
