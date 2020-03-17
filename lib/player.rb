class Player

  BET_SIZE = 10

  attr_accessor :cards
  attr_reader :name, :passed

  def initialize(name)
    @name = name
    @account = 100
    @cards = {}
    @passed = false
  end

  def make_bet
    account -= BET_SIZE
    BET_SIZE
  end

  def take_card(card)
    cards.merge!(card)
  end

  def pass
    passed = true
  end

  def score
    cards.values.sum
  end

  private

  attr_accessor :account, :passed
  
end
