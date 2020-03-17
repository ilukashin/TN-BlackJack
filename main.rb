Dir['./lib/*.rb'].sort.each { |file| require file }

class Main

  ACTIONS = <<-LIST
    1 - Pass
    2 - Add card
    3 - Show cards
  LIST

  def initialize
    @player = HumanPlayer.new('Name')
    @diller = ComputerPlayer.new

    @players = [player, diller]
    @current_player = player
    puts 'Welcome to Casino Royale!'
    @card_deck = []
  end

  def start_game
    loop do
      puts 'Make your turn', ACTIONS
      input = gets.chomp.to_i
      case input
      when 1 then pass
      when 2 then add_card
      when 3 then show_cards
      end
    end
  end

  private

  def prepare_deck
    
  end

  def pass
    current_player.pass
    change_player
  end

  def change_player

  end

  def add_card
    current_player.add_card
    change_player
  end

  def show_cards

  end


  
end
