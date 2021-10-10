# frozen_string_literal: true

require_relative 'database'
require_relative 'display'
require 'yaml'

# rubocop:disable Metrics/ClassLength

# Play a game of hangman
class Game
  include Database
  include Display

  FINISHED_HANGMAN = ["\e[31m¯\e[0m", "\e[31m\\\e[0m", "\e[31m_\e[0m", "\e[31m(\e[0m", "\e[31mツ\e[0m", "\e[31m)\e[0m",
                      "\e[31m_\e[0m", "\e[31m/\e[0m", "\e[31m¯\e[0m"].freeze

  def initialize
    start
  end

  private

  def start
    puts introduction
    new_or_load
  end

  def new_or_load
    input = gets.chomp
    while %w[1 2].include?(input) == false
      puts error_message[0]
      input = gets.chomp
    end
    input == '1' ? new_game : load_game
  end

  def new_game
    @word = generate_word
    @word_cue = Array.new(@word.length) { |_index| '_' }
    @hangman = ['¯', '\\', '_', '(', 'ツ', ')', '_', '/', '¯']
    @strikes = 0
    @round = 1
    @guesses = []
    play_game
  end

  def generate_word
    words = File.readlines('dictionary.txt')
    list = []
    words.each do |word|
      next unless word.chomp.length.between?(5, 12)

      list.push(word.chomp.downcase)
    end
    list.sample.split('')
  end

  def play_game
    play_round while @word_cue.include?('_') && @strikes < 9
    game_over
    File.delete(@file) if defined?(@file)
  end

  def play_round
    display_board
    guess_letter
  end

  def display_board
    display_round(@round)
    print @hangman.join
    display_blanks(@word_cue)
    display_guesses(@guesses)
    display_prompt
  end

  def guess_letter
    input = gets.chomp.downcase
    while input.length > 1 || !input.match?(/\A[a-zA-Z'-]*\z/)
      save_game if input == 'save'
      puts error_message[1]
      input = gets.chomp.downcase
    end
    check_match(input)
  end

  def check_match(letter)
    if @guesses.include?("\e[32m#{letter}\e[0m") || @guesses.include?("\e[31m#{letter}\e[0m")
      puts error_message[2]
      guess_letter
    elsif @word.include?(letter)
      correct_guess(letter)
    else
      incorrect_guess(letter)
    end
    @round += 1
  end

  def correct_guess(letter)
    @guesses.push("\e[32m#{letter}\e[0m")
    add_letter(letter)
  end

  def add_letter(letter)
    @word.each_with_index do |element, index|
      @word_cue[index] = letter if element == letter
    end
  end

  def incorrect_guess(letter)
    @guesses.push("\e[31m#{letter}\e[0m")
    @hangman[@strikes] = FINISHED_HANGMAN[@strikes]
    @strikes += 1
  end

  def game_over
    display_game_over
    print @hangman.join
    @strikes < 9 ? player_win : player_lose
  end

  def player_win
    display_blanks(@word_cue)
    display_guesses(@guesses)
    puts result[0]
  end

  def player_lose
    display_answer(@word, @word_cue)
    display_guesses(@guesses)
    puts result[1]
  end
end

# rubocop:enable Metrics/ClassLength
