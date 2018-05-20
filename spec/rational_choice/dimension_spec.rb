require_relative '../spec_helper'

describe 'RationalChoice::Dimension' do
  describe '.new' do
    it 'raises a DomainError if the bounds are the same' do
      expect {
        RationalChoice::Dimension.new(false_at_or_below: 2, true_at_or_above: 2)
      }.to raise_error(/Bounds were the same at 2/)
    end
  end

  describe 'with values at or beyound the thresholds' do
    it 'always evaluates to true for values above upper threshold' do
      d = RationalChoice::Dimension.new(false_at_or_below: 0, true_at_or_above: 1)
      10_000.times do
        expect(d.choose(1.1)).to eq(true)
      end
    end

    it 'always evaluates to true for values at upper threshold' do
      d = RationalChoice::Dimension.new(false_at_or_below: 0, true_at_or_above: 1)
      10_000.times do
        expect(d.choose(1)).to eq(true)
      end
    end

    it 'always evaluates to false for values at lower threshold' do
      d = RationalChoice::Dimension.new(false_at_or_below: 0, true_at_or_above: 1)
      10_000.times do
        expect(d.choose(0)).to eq(false)
      end
    end

    it 'always evaluates to false for values below lower threshold' do
      d = RationalChoice::Dimension.new(false_at_or_below: 0, true_at_or_above: 1)
      10_000.times do
        expect(d.choose(-0.0001)).to eq(false)
      end
    end
  end

  describe 'with values between thresholds creates a sensible choice distribution' do
    it 'for 0.5 on a continuum from 0 to 1' do
      d = RationalChoice::Dimension.new(false_at_or_below: 0, true_at_or_above: 1)
      expect(d).to be_fuzzy(0.5)

      trues = 0

      n_evaluations = 100_000
      n_evaluations.times { trues += 1 if d.choose(0.5) }

      expect(trues).to be_within(1000).of(n_evaluations / 2)
    end

    it 'for 0.1 on a continuum from 0 to 1' do
      d = RationalChoice::Dimension.new(false_at_or_below: 0, true_at_or_above: 1)
      expect(d).to be_fuzzy(0.1)

      trues = 0

      n_evaluations = 100_000
      n_evaluations.times { trues += 1 if d.choose(0.1) }

      expect(trues).to be_within(1000).of(n_evaluations / 10)
    end

    it 'for 0.5 on a continuum from 1 to 0' do
      d = RationalChoice::Dimension.new(false_at_or_below: 1, true_at_or_above: 0)
      expect(d).to be_fuzzy(0.5)

      falses = 0
      n_evaluations = 100_000
      n_evaluations.times { falses += 1 unless d.choose(0.5) }

      expect(falses).to be_within(1000).of(n_evaluations / 2)
    end

    it 'for 0.1 on a continuum from 1 to 0' do
      d = RationalChoice::Dimension.new(false_at_or_below: 1, true_at_or_above: 0)
      expect(d).to be_fuzzy(0.1)

      trues = 0

      n_evaluations = 100_000
      n_evaluations.times { trues += 1 if d.choose(0.1) }

      expect(trues).to be_within(1000).of(n_evaluations / 10 * 9) # Over 90% of the choices must be trues
    end

    it 'for -0.5 on a continuum from -1 to 0' do
      d = RationalChoice::Dimension.new(false_at_or_below: -1, true_at_or_above: 0)
      expect(d).to be_fuzzy(-0.5)

      trues = 0
      n_evaluations = 100_000
      n_evaluations.times { trues += 1 if d.choose(-0.5) }

      expect(trues).to be_within(1000).of(n_evaluations / 2)
    end

    it 'for -0.1 on a continuum from -1 to 0' do
      d = RationalChoice::Dimension.new(false_at_or_below: -1, true_at_or_above: 0)
      expect(d).to be_fuzzy(-0.1)

      trues = 0

      n_evaluations = 100_000
      n_evaluations.times { trues += 1 if d.choose(-0.1) }

      expect(trues).to be_within(1000).of(n_evaluations / 10 * 9) # Over 90% of the choices must be trues
    end

    it 'for -0.5 on a continuum from 0 to -1' do
      d = RationalChoice::Dimension.new(false_at_or_below: 0, true_at_or_above: -1)
      expect(d).to be_fuzzy(-0.5)

      trues = 0
      n_evaluations = 100_000
      n_evaluations.times { trues += 1 if d.choose(-0.5) }

      expect(trues).to be_within(1000).of(n_evaluations / 2)
    end

    it 'for -0.1 on a continuum from 0 to -1' do
      d = RationalChoice::Dimension.new(false_at_or_below: 0, true_at_or_above: -1)
      expect(d).to be_fuzzy(-0.1)

      trues = 0

      n_evaluations = 100_000
      n_evaluations.times { trues += 1 if d.choose(-0.1) }

      expect(trues).to be_within(1000).of(n_evaluations / 10) # Over 90% of the choices must be trues
    end
  end
end
