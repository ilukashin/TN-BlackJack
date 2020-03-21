# frozen_string_literal: true

require_relative './lib/player.rb'
require_relative './lib/card.rb'

class Main
  ACTIONS = <<-LIST
    1 - Pass
    2 - Take card
    3 - Show cards
  LIST

  WELCOME_MESSAGE = "\nWelcome to Casino Royale!\n"
  GOODBYE_MESSAGE = "\nThanks for playing!\n"

  CARDS = %w[A 2 3 4 5 6 7 8 9 10 J Q K].freeze
  POINTS = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10].freeze
  SUITES = %w[♠ ♡ ♣ ♢].freeze

  attr_accessor :player, :diller, :players, :current_player,
                :card_deck, :bank, :winner

  def initialize
    puts 'Input username:'
    @player = Player.new(gets.chomp)
    @diller = Player.new('Diller')

    @players = [player, diller]
    @current_player = player
    @card_deck = []
  end

  def run
    puts WELCOME_MESSAGE
    loop do
      start_game
      break unless play_again?
    end
    puts GOODBYE_MESSAGE
  end

  private

  def start_game
    prepare_stuff
    loop do
      check_players_state
      break if winner?

      current_player.eql?(player) ? player_turn : computer_turn
    end
    open_cards
  end

  def play_again?
    puts 'Play again? [y/n]'
    gets.chomp.eql?('y')
  end

  # rubocop:disable Metrics/AbcSize
  def check_players_state
    check_winner if players.all?(&:passed)
    check_winner if players.all? { |player| player.cards.count.eql?(3) }
    check_winner if diller.passed && player.cards.count.eql?(3)
  end
  # rubocop:enable Metrics/AbcSize

  def prepare_stuff
    puts '=' * 30, 'Game started!'
    clear_players_state
    @bank = 0
    prepare_deck
    init_players_hands
    make_bets
    @winner = nil
  end

  def clear_players_state
    players.each(&:clear_state)
  end

  def prepare_deck
    card_deck.clear
    SUITES.each do |suite|
      CARDS.each do |card|
        # card_deck << { "#{card}#{suite}" => POINTS[CARDS.index(card)] }
        card_deck << Card.new("#{card}#{suite}", POINTS[CARDS.index(card)])
      end
    end
  end

  def init_players_hands
    players.each do |player|
      2.times { player.take_card(card_from_deck) }
    end
  end

  def make_bets
    players.each do |player|
      self.bank += player.make_bet
    end
  end

  def card_from_deck
    card = card_deck.sample
    card_deck.delete(card)
    card
  end

  def player_turn
    turn_message
    puts 'Make your turn:', ACTIONS
    input = gets.chomp.to_i
    case input
    when 1 then pass
    when 2 then take_card
    when 3 then check_winner
    end
  end

  def turn_message
    puts '-' * 20,
         "#{diller.name} cards: #{'*' * diller.cards.count}",
         "#{player} cards: #{player.show_cards} - score: #{player.score}"
  end
  # rubocop:enable

  def computer_turn
    if current_player.score < 17
      take_card
    else
      pass
    end
  end

  # rubocop:disable Style/DoubleNegation
  def winner?
    !!winner
  end
  # rubocop:enable Style/DoubleNegation

  def pass
    current_player.pass
    change_player
  end

  def change_player
    self.current_player = players.reject { |player| player == current_player }
                                 .first
  end

  def take_card
    current_player.take_card(card_from_deck)
    change_player
  end

  def open_cards
    players.each do |player|
      puts "#{player} #{player.show_cards} - score: #{player.score}"
    end
    award(winner, bank)
  end

  # rubocop:disable all
  def check_winner
    self.winner = if player.score.eql?(diller.score)
                    players
                  elsif player.score.eql?(21)
                    player
                  elsif player.score > 21
                    diller
                  elsif player.score > diller.score
                    player
                  elsif player.score < diller.score && diller.score <= 21
                    diller
                  elsif player.score < diller.score && diller.score > 21
                    player
                  end
  end
  # rubocop:enable all

  def award(winner, bank)
    puts '*' * 20
    if winner.is_a?(Array)
      draw
    else
      winner.assign_money(bank)
      puts "Winner is #{winner}!"
    end
    puts '*' * 20,
         "Your account is #{player.account}"
  end

  def draw
    puts 'It\'s a draw!'
    players.each do |player|
      player.assign_money(bank / players.count)
    end
  end
end

Main.new.run
