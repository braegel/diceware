#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#
# Simple diceware tool for creating passwords.
#
# This tool takes all words in /usr/share/dict and randomly
# (/dev/random) selects some of them.
# /dev/random needs time to create entropy. Therefore it
# will take some time to find random words.
# Use ./diceware -v for a more verbose output.
#
# Take at least five words to create your password.
# Five words correspond to a password strength (entropy) of 64 bits.
# For 128 bits password entropy you need 10 words.
# For 256 bits you would need 20 words.
#
# For more on diceware have a look here:
# https://en.wikipedia.org/wiki/Diceware
# https://en.wikipedia.org/wiki/Password_strength#Random_passwords
#
# Creative Commons License:
# https://creativecommons.org/licenses/by/4.0/deed.en_US
#
# Author: Bernd Brägelmann - http://www.braegelmann.net/bernd

require 'optparse'

wordlist_path="/usr/share/dict"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: ./diceware.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    options[:verbose] = true
  end

end.parse!

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

needed_bytes=(Math.log2(words.length)/8+1).to_i

while (true) do
  if `cat /proc/sys/kernel/random/entropy_avail`.chomp.to_i > needed_bytes*8
    random = `od -An -N#{needed_bytes} -i /dev/random`.scan(/\d+/).first.to_i
    if random < words.length
      puts "#{words[random]} (#{random})"
    else
      if options[:verbose] 
        puts "Random number exceeded number of words. Trying again";
      end
    end
  else
      if options[:verbose]
        puts "Entropy to low (#{`cat /proc/sys/kernel/random/entropy_avail`.chomp} <= #{needed_bytes*8}). Waiting 10 seconds";
      end
    sleep(10)
  end
end


