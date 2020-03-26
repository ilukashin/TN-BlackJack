# frozen_string_literal: true

class Deck
  attr_accessor :cards

  def initialize
    new_deck
  end

  def new_deck
    @cards = []
    Card::SUITES.each do |suite|
      Card::CARDS.each_with_index do |card, i|
        cards << Card.new("#{card}#{suite}", Card::POINTS[i])
      end
    end
  end

  def take_card
    card = cards.sample
    cards.delete(card)
    card
  end
end
