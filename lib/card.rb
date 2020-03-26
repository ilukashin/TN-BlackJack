# frozen_string_literal: true

class Card
  CARDS = %w[A 2 3 4 5 6 7 8 9 10 J Q K].freeze
  POINTS = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10].freeze
  SUITES = %w[♠ ♡ ♣ ♢].freeze

  attr_accessor :value
  attr_reader :name

  def initialize(name, value)
    @name = name
    @value = value
  end
end
