#Blackjack
#By Ricardo Rojo.
#04/03/2015.

# configuration
number_of_decks = 2
# variables
playing_deck = []
player_cards = []
computer_cards = []
end_game = false

def ask_for_name
  puts "Ready to play Blackjack!!"
  puts "========================="
  puts "What´s your name?"
  name = gets.chomp.capitalize
end
# initialization methods
def initialize_deck
  suits = %w(spades hearts clubs diamonds)
  card_value = []
  suits.each do |suit|
    card_value = card_value + get_suit(suit)
  end
  shuffle_deck(card_value)
  return card_value
end

def get_suit(suit)
  full_suit = []
  (2..10).each {|value| full_suit << [suit, value.to_s, value]}
  add_ace_and_face_cards(full_suit, suit)
  return full_suit
end

def add_ace_and_face_cards(card_value,suit)
  card_value << [suit, "Ace", 1]
  ["Jack","Queen","King"].each {|face_card| card_value << [suit, face_card, 10]}
end

def shuffle_deck(deck)
  3.times{deck.shuffle!}
end

def reset_player_and_computer_decks(player_cards, computer_cards)
  player_cards.clear
  computer_cards.clear
end
# playing methods
def give_starting_cards(player_cards, computer_cards, playing_deck)
  2.times{player_cards << playing_deck.shift}
  2.times{computer_cards << playing_deck.shift}
  puts playing_deck.count.to_s + "cards"
end

def get_card(playing_deck, hand)
  hand << playing_deck.shift
end
# check and count methods
def count_cards(cards)
  number_aces = 0
  sum = 0
  # count aces and sum the cards
  cards.each do |card|
    if card[1] == "Ace"
      number_aces += 1
    else
      sum += card[2]
    end
  end
  # check win or lose. If any aces in the hand check again the sum
  if number_aces == 0
    return sum
  else
    return check_punctuation(sum, number_aces)
  end
end

def check_punctuation(sum, aces)
  aces_values = [0,11,12,13,14] # added 0 for clarity. Never used.
  total_sum_1 = sum + (aces * 1)
  total_sum_11 = sum + (aces_values[aces])

  if total_sum_11 <= 21
    return total_sum_11
  else
    return total_sum_1
  end
end

def check_win_lose(sum, player)
  if sum == 21
    puts "#{player} Wins!!"
    return true
  elsif sum > 21
    puts "#{player} is been defeated"
    return true
  end
end

def get_winner(player_sum, computer_sum, name)
  if player_sum > computer_sum
    puts "#{name} Wins!!"
  elsif computer_sum > player_sum
    puts "Computer Wins!!"
  else
    puts "It´s a draw"
  end
end

# printing methods
def print_card(card)
  puts "---------------"
  print "|"
  print "#{card[1]}".center(15)
  puts "|"
  print "|"
  print "#{card[0]}".center(15)
  puts "|"
  puts "---------------"
end

def print_full_hand(player_cards, computer_cards, name, card_hidden = false)
  system('clear')
  hidden_card = [" "," "," "]
  puts "#{name} cards"
  player_cards.each {|card| print_card(card)}
  puts "Computer cards"
  if card_hidden
    print_card(computer_cards.first)
    print_card(hidden_card)
  else
    computer_cards.each {|card| print_card(card)}
  end
end

def print_hands_sum(player_cards, computer_cards, computer_hand_hidden = true)
  puts "The sum of the player cards is:  #{count_cards(player_cards)}"
  if computer_hand_hidden
    puts "The sum of the computer cards is unknown"
  else
    puts "The sum of the computer cards is: #{count_cards(computer_cards)}"
  end
end
#### Program execution starts
name = ask_for_name
name = "Smith" unless !name.empty?
number_of_decks.times {playing_deck = playing_deck + initialize_deck}
loop do # main loop
  system('clear')
  reset_player_and_computer_decks(player_cards, computer_cards)
  give_starting_cards(player_cards, computer_cards, playing_deck)
  print_full_hand(player_cards, computer_cards, name, true) # last parameter true = computer card hidden
  game_ends = false

  begin # player's turn
    print_hands_sum(player_cards, computer_cards)
    if check_win_lose(count_cards(player_cards), name)
      game_ends = true
      break
    end

    begin # loop until Hit or Stay is selected
      puts "hit or stay(H/S)?"
      choice = gets.chomp.upcase
    end until choice == "H" || choice == "S"

    get_card(playing_deck,player_cards) unless choice == "S"
    print_full_hand(player_cards, computer_cards, name, true) # last parameter true = computer card hidden
  end while choice != "S"

  while !game_ends do # computer's turn unless player has win or lose before
    print_full_hand(player_cards, computer_cards, name)  
    print_hands_sum(player_cards, computer_cards, false) # last parameter false = dont hide computer's hand sum

    if check_win_lose(count_cards(computer_cards), "computer")
      game_ends = true
      break
    elsif count_cards(computer_cards) >= 17
      get_winner(count_cards(player_cards), count_cards(computer_cards), name)
      game_ends = true
    else
      get_card(playing_deck,computer_cards)
    end
  end
  puts "play again?(Y/N)"
  end_game = gets.chomp
  exit if end_game.upcase == "N"
  if playing_deck.size <= 8 # recreates the playing_deck discarding the remaining cards
    playing_deck = initialize_deck
  end
end