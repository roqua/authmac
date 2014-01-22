require 'authmac/timestamp_checker'

module Authmac
  describe TimestampChecker do
    let(:checker) { TimestampChecker.new(15*60, 5*60) }

    it 'returns true if timestamp is recent' do
      expect(checker.validate(Time.now.to_i)).to be_truthy
    end

    it 'returns false if timestamp is too old' do
      expect(checker.validate(Time.now.to_i - (15*60 + 1))).to be_falsey
    end

    it 'returns false if timestamp is too far in the future' do
      expect(checker.validate(Time.now.to_i + (5*60 + 1))).to be_falsey
    end
  end
end