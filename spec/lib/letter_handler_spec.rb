require 'rails_helper'

RSpec.describe LetterHandler do
  context 'get_letter' do
    it 'returns the letter for basic letters' do
      expect(LetterHandler.get_letter("a")).to eql("a")
      expect(LetterHandler.get_letter("B")).to eql("B")
      expect(LetterHandler.get_letter("_")).to eql("_")
      expect(LetterHandler.get_letter("0")).to eql("0")
    end

    it 'returns unicode characters when given a hex' do
      expect(LetterHandler.get_letter("00023")).to eql("#")
      expect(LetterHandler.get_letter("0003F")).to eql("?")
      expect(LetterHandler.get_letter("1F628")).to eql("😨")
    end

    it 'returns nil for banned letters' do
      create :ban_letter, letter: "F"
      expect(LetterHandler.get_letter("F")).to be_nil
    end

    it 'returns nil for everything else' do
      expect(LetterHandler.get_letter("aa")).to be_nil
      expect(LetterHandler.get_letter("%")).to be_nil
      expect(LetterHandler.get_letter("23")).to be_nil
    end
  end
end
