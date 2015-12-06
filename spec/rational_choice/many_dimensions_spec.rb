require_relative '../spec_helper'

describe 'RationalChoice::ManyDimensions' do
  describe '.new' do
    it 'raises a CardinalityError when no dimensions are given' do
      expect {
        RationalChoice::ManyDimensions.new
      }.to raise_error(RationalChoice::CardinalityError)
    end
  end
  
  describe '.choose' do
    it 'raises a CardinalityError if the number of values does not match the number of dimensions' do
      md = RationalChoice::ManyDimensions.new(nil, nil, nil)
      expect {
        md.choose(1, 2)
      }.to raise_error(RationalChoice::CardinalityError)
    end
    
    let(:md) {
      one_to_zero = RationalChoice::Dimension.new(0, 1)
      RationalChoice::ManyDimensions.new(one_to_zero, one_to_zero, one_to_zero)
    }
    
    it 'returns "true" when all dimensions are at or above upper bound' do
      10_000.times { expect(md.choose(1,1,1)).to eq(true) }
      10_000.times { expect(md.choose(2,2,2)).to eq(true) }
    end
    
    it 'returns "false" when all dimensions are at or below lower bound' do
      10_000.times { expect(md.choose(0,0,0)).to eq(false) }
      10_000.times { expect(md.choose(-1,-1,-1)).to eq(false) }
    end
    
    it 'returns "true" in approximately 50% of the cases when all the values are at 0.5' do
      truthy = 0
      10_000.times { truthy += 1 if md.choose(0.5, 0.5, 0.5) }
      expect(truthy).to be_within(100).of(10_000 / 2)
    end
    
    it 'returns "true" in approximately 10% of the cases when all the values are at 0.1' do
      truthy = 0
      10_000.times { truthy += 1 if md.choose(0.1, 0.1, 0.1) }
      expect(truthy).to be_within(100).of(10_000 / 10)
    end
    
    it 'creates a very uniform distribution of values with random values across the board' do
      truthy = 0
      10_000.times { truthy += 1 if md.choose(rand, rand, rand) } # default rand() is 0..1
      expect(truthy).to be_within(100).of(10_000 / 2)
    end
  end
  
end