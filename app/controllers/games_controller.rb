require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @alphabet = [('A'..'Z')].map{ |i| i.to_a }[0]
    @game_letters = []
    @random_letters = 10.times { @game_letters << @alphabet.sample }
  end

  def score
    @word = params[:word].upcase
    word_array = @word.split('')
    game_letters = params[:letters].split(' ')
    inclusion = true
    word_array.each do |letter|
      inclusion = inclusion && (game_letters.count(letter) >= word_array.count(letter))
    end
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    @english_word = JSON.parse(open(url).read)['found']
    if @english_word && inclusion
      @response = "Congratulations! #{@word} is an english word!"
    elsif @english_word && !inclusion
      @response = "#{@word} cannot be made up from #{game_letters.join(",")}"
    elsif !@english_word && inclusion
      @response = "#{@word} is not an english word"
    else
      @response = "#{@word} is not an english word, nor can it be made up from #{game_letters.join(",")}"
    end
  end
end
