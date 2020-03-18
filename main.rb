require_relative './lib/player.rb'
require 'pry'

class Main

  ACTIONS = <<-LIST
    1 - Pass
    2 - Take card
    3 - Show cards
  LIST

  CARDS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  POINTS = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
  SUITES = %w(♠ ♡ ♣ ♢)

  attr_accessor :player, :diller, :players, :current_player, :card_deck, :bank, :winner

  def initialize
    puts 'Input username:'
    @player = Player.new(gets.chomp)
    @diller = Player.new('Diller')

    @players = [player, diller]
    @current_player = player
    puts 'Welcome to Casino Royale!'
    @card_deck = []
  end

  def start_game
    prepare_stuff
    loop do
      check_players_state
      break if have_winner?
      #binding.pry
      if current_player.eql?(player)
        player_turn
      else
        computer_turn
      end
    end
  end

  private

  def check_players_state
    open_cards if players.all? { |player| player.passed }
    open_cards if players.all? { |player| player.cards.count.eql?(3) }
  end

  def prepare_stuff
    @bank = 0
    prepare_deck
    init_players_hands
    make_bets
    @winner = nil
  end

  def prepare_deck
    SUITES.each do |suite|
      CARDS.each do |card|
        card_deck << { "#{card}#{suite}" => POINTS[CARDS.index(card)] }
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
    puts 'Make your turn', ACTIONS
      input = gets.chomp.to_i
      case input
      when 1 then pass
      when 2 then take_card
      when 3 then open_cards
      end
  end

  def computer_turn
    if current_player.score < 17
      take_card
    else
      pass
    end
  end

  def have_winner?
    !!winner
  end

  def pass
    current_player.pass
    change_player
  end

  def change_player
    self.current_player = players.select { |player| player != current_player }.first
  end

  def take_card
    current_player.take_card(card_from_deck)
    change_player
  end

  def open_cards
    players.each do |player|
      puts "#{player.name} #{player.show_cards} - score: #{player.score}"
    end
    check_winner
    puts "Winner is #{winner}!"
  end

  def check_winner
    if player.score.eql?(21)
      self.winner = player
    elsif player.score > 21
      self.winner = diller
    elsif player.score > diller.score
      self.winner = player
    elsif player.score < diller.score
      self.winner = diller
    else
      draw
      return
    end
    award(winner, bank)
  end

  def award(winner, bank)
    winner.assign_money(bank)
  end

  def draw
    players.each do |player|
      player.assign_money(bank / players.count)
    end
  end

end


Main.new.start_game
