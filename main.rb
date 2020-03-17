Dir['./lib/*.rb'].sort.each { |file| require file }

class Main

  ACTIONS = <<-LIST
    1 - Pass
    2 - Take card
    3 - Show cards
  LIST

  CARDS = %w(A 2 3 4 5 6 7 8 9 10 J Q K)
  POINTS = [11, 2, 3, 4, 5, 6, 7, 8, 9, 10, 10, 10, 10]
  SUITES = %w(♠ ♡ ♣ ♢)

  def initialize
    @player = HumanPlayer.new('Name')
    @diller = ComputerPlayer.new

    @players = [player, diller]
    @current_player = player
    puts 'Welcome to Casino Royale!'
    @card_deck = []
  end

  def start_game
    prepare_deck
    loop do
      if current_player.eql?(player)
        player_turn
      else
        computer_turn
      end
      break if have_winner?      
    end
  end

  private

  attr_accessor :player, :diller, :players, :current_player, :card_deck

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

  end

  def prepare_deck
    SUITES.each do |suite|
      CARDS.each do |card|
        card_deck << { "#{card}#{suite}" => POINTS[CARDS.index(card)] }
      end
    end
  end

  def pass
    current_player.pass
    change_player
  end

  def change_player

  end

  def take_card
    card = card_deck.sample
    card_deck.delete(card)

    current_player.take_card(card)
    change_player
  end

  def open_cards
    players.each do |player|
      puts "#{player.show_cards} - score: #{player.score}"
    end
  end
end


Main.new.start_game
