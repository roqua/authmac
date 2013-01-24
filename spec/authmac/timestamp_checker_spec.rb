require 'authmac/timestamp_checker'

module Authmac
  describe TimestampChecker do
    let(:checker) { TimestampChecker.new(15*60, 5*60) }

    it 'returns true if timestamp is recent' do
      checker.validate(Time.now.to_i).should be_true
    end

    it 'returns false if timestamp is too old' do
      checker.validate(Time.now.to_i - (15*60 + 1)).should be_false
    end

    it 'returns false if timestamp is too far in the future' do
      checker.validate(Time.now.to_i + (5*60 + 1)).should be_false
    end
  end
end