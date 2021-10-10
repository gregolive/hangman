# frozen_string_literal: true

require 'yaml'

# Save and load game files
module Database
  # SAVE
  def save_game
    game_data = to_yaml
    create_file(game_data)
    exit
  end

  def to_yaml
    YAML.dump({
                word: @word,
                word_cue: @word_cue,
                hangman: @hangman,
                strikes: @strikes,
                round: @round,
                guesses: @guesses
              })
  end

  def create_file(data)
    Dir.mkdir('saved') unless Dir.exist?('saved')
    filename = "saved/#{create_filename}.yml"
    File.open(filename, 'w') do |file|
      file.puts data
    end
  end

  def create_filename
    display_filename_prompt
    filename = gets.chomp
    while saved_games.include?(filename) || !filename.match?(/^[a-zA-Z\d ]*$/i)
      puts error_message[4]
      filename = gets.chomp
    end
    filename
  end

  # LOAD
  def load_game
    filename = ask_filename
    load_save_file(filename)
    play_game
  end

  def ask_filename
    puts loading_message[0]
    puts files = saved_games
    puts loading_message[1]
    filename = gets.chomp
    until files.include?(filename)
      puts error_message[3]
      filename = gets.chomp
    end
    filename
  end

  def saved_games
    files = []
    Dir.glob('./saved/*').each { |file| files.push(file[0...-4][8..-1]) }
    files
  end

  def load_save_file(string)
    data = YAML.load_file("./saved/#{string}.yml")
    begin
      pull_data(data, string)
    rescue StandardError
      puts error_message[5]
      load_game
    end
  end

  def pull_data(data, string)
    @word = data[:word]
    @word_cue = data[:word_cue]
    @hangman = data[:hangman]
    @strikes = data[:strikes]
    @round = data[:round]
    @guesses = data[:guesses]
    @file = "./saved/#{string}.yml"
  end
end
