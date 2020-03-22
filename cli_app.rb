# frozen_string_literal: true

require_relative './lib/player.rb'
require_relative './lib/card.rb'
require_relative './lib/deck.rb'
require_relative './controller.rb'
require_relative './cli_view.rb'

class CLIApp
  attr_reader :view

  def initialize
    @view = CLIView.new
  end

  def run
    view.welcome
    loop do
      view.start_game
      break unless view.play_again?
    end
    view.goodbye
  end
end
