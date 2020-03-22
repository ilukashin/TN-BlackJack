# frozen_string_literal: true

class CLIView
  ACTIONS = <<-LIST
    1 - Pass
    2 - Take card
    3 - Show cards
  LIST

  WELCOME_MESSAGE = "\nWelcome to Casino Royale!\n"
  GOODBYE_MESSAGE = "\nThanks for playing!\n"
  REPLAY_MESSAGE = 'Play again? [y/n]'

  attr_accessor :controller, :player, :diller, :players

  def initialize
    @controller = Controller.new(invite_player)
    @player = controller.player
    @diller = controller.diller
    @players = controller.players
  end

  def welcome
    puts WELCOME_MESSAGE
  end

  def goodbye
    puts GOODBYE_MESSAGE
  end

  def play_again?
    puts REPLAY_MESSAGE
    gets.chomp.eql?('y')
  end

  # rubocop:disable Metrics/AbcSize
  def start_game
    puts '=' * 30, 'Game started!'
    controller.prepare_stuff
    loop do
      controller.check_players_state
      break if controller.winner?

      controller.current_player_human? ? player_turn : controller.computer_turn
    end
    open_cards
  end
  # rubocop:enable Metrics/AbcSize

  private

  def player_turn
    turn_message
    puts 'Make your turn:', ACTIONS
    controller.player_turn(gets.chomp.to_i)
  end

  def turn_message
    puts '-' * 20,
         "#{diller.name} cards: #{'*' * diller.cards.count}",
         "#{player} cards: #{player.show_cards} - score: #{player.score}"
  end

  def open_cards
    players.each do |player|
      puts "#{player} #{player.show_cards} - score: #{player.score}"
    end
    award
  end

  def award
    puts '*' * 20
    controller.award
    controller.is_draw ? draw_message : winner_message
    puts '*' * 20,
         "Your account is #{player.account}"
  end

  def winner_message
    puts "Winner is #{controller.winner}!"
  end

  def draw_message
    puts 'It\'s a draw!'
  end

  def invite_player
    puts 'Input username:'
    gets.chomp
  end
end
