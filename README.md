# Hangman

Can you guess the word before the shrug emoji ¯\\\_(ツ)_/¯ is complete?

Live demo on [Replit](https://replit.com/@gregolive/Hangman) 👈

## Functionality

A command version of the pen paper and pencil guessing game, hangman. Players have the option to save their game at any point during play and a savefile with their chosen name is created. On launch, the player can then choose to start a new game or continue a saved game.

A new 5-12 character word is randomly selected at the start of any new game. Words are picked from the 5desk list on [scrapmaker.com](https://www.scrapmaker.com/view/twelve-dicts/5desk.txt).

## Reflection

This project was a nice introduction to file I/O and serialization in Ruby. Input of the word list txt file was straightforward, however, I struggled at first with the savefile implementation.

Learning that it is possible to serialize entire classes in Ruby was extremely helpful when it came to saving the state of an in progress game. Using YAML is also very intuitive for this application since it adapts almost seamlessly with Ruby and the simplicity of the project regates YAML's speed limitations.

The main issue I had was when it came time to load the savefile. At first I initialized the Game class variables in the initialize method, but when the savefile was loaded in, the serialized variables would not overwrite the initialized variables and the game started from scratch. I was able to fix this by moving the vaiable initialization into a seperate method that is only called when a new game is selected.

-Greg Olive