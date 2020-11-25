require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = random_letters
  end

  def score
    @word = params[:word]
    @letters_list = params[:letters_list].split(' ')
    @letters_list.class

    # The word cant be built out of the original grid
    @word.split('').each do |letter|
      index_at_grid = @letters_list.rindex(letter.downcase)
      return @response = "Sorry but '#{@word.upcase}' can't be built out of #{@letters_list}" if index_at_grid.nil?

      @letters_list.delete_at(index_at_grid)
    end

    # The word is valid according to the grid, but is not a valid English word
    word_json = fetch_word(@word)
    return @response = "Sorry but '#{@word.upcase}' does not seem to be a valid English Word" unless english?(word_json)

    # The word is valid according to the grid and is an English word
    @response = "Congratulations - '#{@word.upcase}' is a valid english word."
    # raise
  end

  private

  def random_letters
    (1..9).map { ('a'..'z').to_a.sample }
  end

  def english?(user_word)
    user_word['found']
  end

  def fetch_word(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    JSON.parse(response) # format SRING into JSON
  end
end
