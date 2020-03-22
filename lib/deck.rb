class Deck
  attr_accessor :cards
  
  CARDS = %w[A 2 3 4 5 6 7 8 9 10 J Q K].freeze
  POINTS = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10].freeze
  SUITES = %w[♠ ♡ ♣ ♢].freeze

  def initialize
    new_deck
  end

  def new_deck
    @cards = []
    SUITES.each do |suite|
      CARDS.each do |card|
        cards << Card.new("#{card}#{suite}", POINTS[CARDS.index(card)])
      end
    end
  end

  def take_card
    card = cards.sample
    cards.delete(card)
    card
  end
end
