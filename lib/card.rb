# frozen_string_literal: true

class Card
  attr_accessor :value
  attr_reader :name

  def initialize(name, value)
    @name = name
    @value = value
  end
end
