# frozen_string_literal: true

class Controller
  attr_accessor :player, :diller, :players, :current_player,
                :card_deck, :bank, :winner, :is_draw

  def initialize(player_name)
    @player = Player.new(player_name)
    @diller = Player.new('Diller')

    @players = [player, diller]
    @current_player = player
    @card_deck = nil
  end

  # rubocop:disable Metrics/AbcSize
  def check_players_state
    check_winner if players.all?(&:passed)
    check_winner if players.all? { |player| player.cards.count.eql?(3) }
    check_winner if diller.passed && player.cards.count.eql?(3)
  end
  # rubocop:enable Metrics/AbcSize

  def prepare_stuff
    clear_players_state
    self.bank = 0
    prepare_deck
    init_players_hands
    make_bets
    self.winner = nil
    self.is_draw = false
  end

  # rubocop:disable Style/DoubleNegation
  def winner?
    !!winner
  end
  # rubocop:enable Style/DoubleNegation

  def player_turn(input)
    case input
    when 1 then pass
    when 2 then take_card
    when 3 then check_winner
    end
  end

  def computer_turn
    if current_player.score < 17
      take_card
    else
      pass
    end
  end

  def award
    if winner.is_a?(Array)
      draw
    else
      assign_win
    end
  end

  def assign_win
    winner.assign_money(bank)
  end

  def draw
    self.is_draw = true
    players.each do |player|
      player.assign_money(bank / players.count)
    end
  end

  def current_player_human?
    current_player.eql?(player)
  end

  private

  def clear_players_state
    players.each(&:clear_state)
  end

  def prepare_deck
    self.card_deck = Deck.new
  end

  def init_players_hands
    players.each do |player|
      2.times { player.take_card(card_deck.take_card) }
    end
  end

  def make_bets
    players.each do |player|
      self.bank += player.make_bet
    end
  end

  def pass
    current_player.pass
    change_player
  end

  def change_player
    self.current_player = players.reject { |player| player == current_player }
                                 .first
  end

  def take_card
    current_player.take_card(card_deck.take_card)
    change_player
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
end
