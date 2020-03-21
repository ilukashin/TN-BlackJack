# frozen_string_literal: true

class Player
  BET_SIZE = 10

  attr_accessor :cards, :account, :passed
  attr_reader :name

  def initialize(name)
    @name = name
    @account = 100
    @cards = []
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
    cards << card
  end

  def pass
    self.passed = true
  end

  def show_cards
    cards.map(&:name)
         .join(', ')
  end

  def score
    if cards_sum > 21 && show_cards.include?('A')
      cards.select { |el| el.name =~ /A/ }.first.value = 1
    end
    cards_sum
  end

  def clear_state
    cards.clear
    self.passed = false
  end

  def to_s
    name
  end

  private

  def cards_sum
    cards.map(&:value)
         .sum
  end
end
