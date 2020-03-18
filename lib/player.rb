# frozen_string_literal: true

class Player
  BET_SIZE = 10

  attr_accessor :cards, :account, :passed
  attr_reader :name

  def initialize(name)
    @name = name
    @account = 100
    @cards = {}
    @passed = false
  end

  def make_bet
    self.account -= BET_SIZE
    BET_SIZE
  end

  def assign_money(summ)
    self.account += summ
  end

  def take_card(card)
    cards.merge!(card)
  end

  def pass
    self.passed = true
  end

  def show_cards
    cards.keys.join(', ')
  end

  def score
    cards.values.sum
  end

  def to_s
    name
  end
end
