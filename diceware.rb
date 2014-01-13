#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Simple diceware tool for creating passwords.
#
# This tool takes all words in /usr/share/dict and randomly selects some of them using the Ruby securerandom class. Sadly this class uses only a PRNG and not /dev/random. Be warned! Take at least 5 words in a row to create your password.
#
# For more on diceware have a look here: https://en.wikipedia.org/wiki/Diceware
#
# Creative Commons License: https://creativecommons.org/licenses/by/4.0/deed.en_US
#
# Author: Bernd Brägelmann
# Timestamp: 20140113 224312

require 'securerandom'

wordlist_path="/usr/share/dict"

words = Array.new

Dir.entries(wordlist_path).each do |name|
  if name != ".." && name != "."
    file = File.new(wordlist_path+"/"+name,"r")
    while (line = file.gets)
      if line.chomp.encode("UTF-8").valid_encoding?
        words << line.chomp.encode("UTF-8").split('\W')
      end
    end
    puts "read "+wordlist_path+"/"+name
    file.close
  end
end

puts "words: #{words.length}"

100.times{
  puts words[SecureRandom.random_number(words.length)]
}

