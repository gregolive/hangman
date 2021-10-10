# frozen_string_literal: true

# Display output to the console
module Display
  def introduction
    <<~HEREDOC

      \e[4;1mCOMMAND LINE HANGMAN\e[0m

      In this verison of the classic pen and pencil game you have \e[31m9 strikes\e[0m to guess the computer's randomly generated word.

      When the shrug emoji \e[31m¯\\_(ツ)_/¯\e[0m is complete its \e[3mGAME OVER\e[23m.

      Enter \e[34m'1'\e[0m start a new game or \e[34m'2'\e[0m to continue a saved game.
    HEREDOC
  end

  def loading_message
    [
      "\n\e[33mSave files:\e[0m\n",
      "\nChoose a save file to load."
    ]
  end

  def error_message
    [
      "\e[31mPlease enter '1' to start a new game or '2' to continue a saved game.\e[0m",
      "\e[31mPlease enter one letter.\e[0m",
      "\e[31mYou have already guessed this letter.\e[0m",
      "\e[31mThis file doesn't exist. Please enter valid filename.\e[0m",
      "\e[31mThis filename is taken or includes invalid characters. Please enter a different name.\e[0m",
      "\e[31m\nERROR: This save file can't be loaded. Please select a different file.\e[0m"
    ]
  end

  def display_round(round)
    puts "\n\e[33m═══════════════ ROUND #{round} ═══════════════\e[0m\n\n"
  end

  def display_blanks(word)
    puts "\t\e[34m#{word.join(' ')}\e[0m\n"
  end

  def display_guesses(guesses)
    puts "\nGuessed letters: #{guesses.join(', ')}"
  end

  def display_prompt
    puts "\nWhat letter would you like to guess?\n"
  end

  def display_game_over
    puts "\n\e[33m═══════════════ GAME OVER ══════════════\e[0m\n\n"
  end

  def display_filename_prompt
    puts 'Enter save file name.'
  end

  def display_answer(word, word_cue)
    word_cue.each_with_index do |element, index|
      word_cue[index] = if element == '_'
                          "\e[31m#{word[index]}\e[0m"
                        else
                          "\e[34m#{word[index]}\e[0m"
                        end
    end
    puts "\t#{word_cue.join(' ')}\n"
  end

  def result
    [
      "\n\e[32mNice guesses. You win!\e[0m",
      "\n\e[31mYou are out of guesses. Better luck next time!\e[0m"
    ]
  end
end
