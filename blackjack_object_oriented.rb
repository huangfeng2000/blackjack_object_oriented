# coding: utf-8

# san' object oriented blackjack game

class Card
  attr_accessor :suit, :point

  def initialize(suit, point)
    @suit = suit
    @point = point
  end

  def to_s
    "[#{suit}, #{point}]"
  end
end

class Deck
  attr_reader :cards

  def initialize
    @cards = []
    %w(S H C D).each do |suit|
      %w(2 3 4 5 6 7 8 9 10 J Q K A).each do |point|
        @cards << Card.new(suit, point)
      end
    end

    @cards.shuffle!
  end
    
  def deal(gamer)
    gamer.cards << cards.pop
  end

  def who_win?(dealer, player)
    player_points = player.calculate_points
    dealer_points = dealer.calculate_points
    if player_points > dealer_points
      puts "you win! your score is greater!"
    elsif player_points < dealer_points
      puts "sorry, dealer win."
    else
      puts "it's a tie."
    end    
  end
end

class Gamer
  attr_accessor :cards
  attr_accessor :deck

  def initialize(deck)
    @cards = []
    @deck = deck
  end

  def calculate_points
    sum = 0

    cards.each do |card|
      if card.point == 'A'
        score = 11
      else
        score = card.point.to_i
        if score == 0
          # J, Q, K
          score = 10
        end
      end
      sum += score
    end

    cards.select { | card | card.point == 'A' }.size.times { sum -=10 if sum > 21 }

    sum
  end
end

class Dealer < Gamer
  def to_s
    "Dealer's Cards is #{cards.map { |card| card.to_s } }, points is #{calculate_points}"
  end

  def turn
    points = calculate_points
    while points < 17
      deck.deal(self)
      points = calculate_points
      puts self
      if points == 21
        puts "sorry, dealer hit blackjack, dealer win."
        exit
      elsif points > 21
        puts "dealer busted, congratinations, you win!"
        exit
      end
    end
  end
end

class Player < Gamer
  def to_s
    "Player's Cards is #{cards.map { |card| card.to_s } }, points is #{calculate_points}"
  end

  def turn
    points = calculate_points
    while points < 21
      # ask whether need a card
      puts "Do you want a card? 1) yes 2) no"
      choose = gets.chomp

      if choose == '2'
        break
      else
        deck.deal(self)
        points = calculate_points

        puts self
      end
    end

    if points == 21
      puts "you win! you hit blackjack!"
      exit
    elsif points > 21
      puts "sorry, you busted."
      exit
    end
  end
end

class Blackjack
  attr_reader :deck, :dealer, :player

  def initialize
    @deck = Deck.new
    @dealer = Dealer.new(deck)
    @player = Player.new(deck)
  end

  def run
    deck.deal(dealer)
    deck.deal(player)
    deck.deal(dealer)
    deck.deal(player)

    puts dealer
    puts player

    player.turn

    dealer.turn

    deck.who_win?(dealer, player)
  end
end

game = Blackjack.new
game.run

