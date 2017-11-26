class HangpersonGame

  attr_reader :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @valid = ''
    @invalid = ''
  end

  def guesses
    @guesses ||= ''
  end

  def wrong_guesses
    @wrong_guesses ||= ''
  end

  def word_with_guesses
    @output = ''
    @word.chars.each do |letter|
      @valid.include?(letter) ? @output += letter : @output += '-'
    end
    @output
  end

  def check_win_or_lose
    if word_with_guesses == @word
      :win
    elsif @invalid.length < 7
      :play
    else
      :lose
    end
  end

  def guess(letter)
    if ! letter.nil? && letter.match?(/[a-zA-Z]+/)
      letter.downcase!

      if @word.include?(letter) && ! @valid.include?(letter)
        @valid += letter
        @guesses = letter
      elsif ! @word.include?(letter) && ! @invalid.include?(letter)
        @guesses ||= ''
        @invalid += letter
        @wrong_guesses = letter
      else
        false
      end
    else
      raise ArgumentError
    end
  end


  # You can test it by running $ bundle exec irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> HangpersonGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.new('watchout4snakes.com').start { |http|
      return http.post(uri, "").body
    }
  end

end
