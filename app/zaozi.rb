#!/usr/bin/env ruby
require 'json'

class ZaoZi  
  attr_reader :scales
  
  def initialize
    @scales = JSON.parse(File.read('scales.json'))
    @scales.each do |k,v|
      @scales[k] = v.map { |h| split_keys(h) }
    end
    @opcodes = {
      'LR' => '⿰',
      'UD' => '⿱',
      'LCR' => '⿲',
      'UCD' => '⿳',
      'S' => '⿴',
      'SU' => '⿵',
      'SD' => '⿶',
      'SL' => '⿷',
      'SLU' => '⿸',
      'SRU' => '⿹',
      'SLD' => '⿺',
      'OV' => '⿻',
      'TR' => '△'
    }
  end
  
  def compose(verb, args, fontsize="64", fontfamily="sans-serif", embedded=false)
    raise ArgumentError.new("wrong font size") unless fontsize.positive_numeric?
    # This is an adjustment to move the <g>roup slightly up so that the
    # character fits into SVG borders.
    # It is a magic number, but it works.
    args = substitute_alternative_keys(verb, args)
    output = ''
    output << '<?xml version="1.0" encoding="UTF-8" standalone="no"?>' unless embedded
    output << %Q{<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" 
  "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg xmlns="http://www.w3.org/2000/svg"
  version="1.1" width="#{fontsize}pt" height="#{fontsize}pt">
  <g style="font-family: #{fontfamily};">}
    scaledata(verb, args).each_with_index {|s, i| output << apply_mask_if_necessary(verb, args, s, i, fontsize) }
    return output << '</g></svg>'
  end
  
  # This is an absolutely crazy addition. Here we stepped on the slippery path of cryptic and unclear code.
  # The logic is as follows:
  # If the key in question has '&' appended, it means it should be masked.
  # The corresponding mask lies in the same slot but with '&' prepended.
  # Otherwise we just construct a text element without magic.
  def apply_mask_if_necessary(verb, args, s, i, fontsize)
    if args[i].chars[1]=='&'
      return %Q{<text x="#{s[0]}em" y="#{s[1]}em" transform="scale(#{s[2]}, #{s[3]})" font-size="#{fontsize}pt" clip-path="url(##{args[i][0]}clip)" dominant-baseline="hanging">#{args[i][0]}</text>} <<
        %Q{<clipPath id="#{args[i][0]}clip">#{@scales[verb][i]['&'+args[i][0]]}</clipPath>}
    else
      return %Q{<text x="#{s[0]}em" y="#{s[1]}em" transform="scale(#{s[2]}, #{s[3]})" font-size="#{fontsize}pt">#{args[i]}</text>}
    end
  end
  
  def substitute_alternative_keys(verb, args)
    brgs = []
    args.each_with_index do |a, i|
      scale = @scales[verb][i]
      a = scale["#{a}>"] unless scale["#{a}>"].nil?
      brgs << a
    end
    return brgs
  end
  
  def scaledata(verb, args)
    scales = @scales[verb]
    raise ArgumentError.new("wrong number of arguments") unless scales.length==args.length
    scaledata = []
    args.each_with_index do |a, i|
      scale = scales[i]
      # TODO: This solution should be rewritten to account
      # for the third character in a non-kludgy way.
      keys = [a, '*']
      keys.unshift "#{a}#{args[1]}", "*#{args[1]}" if i==0
      keys.unshift "#{args[0]}#{a}", "#{args[0]}*" if i==1
      key = (keys & scale.keys)[0]      
      scaledata << scale[key]      
    end
    return scaledata
  end

  def scaledatajson(cmd)
    scaledata(*normalize_command(cmd)).to_json
  end
  
  # Parses the command and returns verb and list of arguments in normalized form
  def normalize_command(cmd)
    if @opcodes.has_value? cmd[0]
      verb = cmd[0]
      args = cmd[1..cmd.length]
    else
      @opcodes.keys.sort.reverse.each do |o|
        if (cmd=~/#{o}/) == 0
          verb = @opcodes[o]
          args = cmd[o.length..cmd.chars.length]
          break
        end
      end
    end
    args = args.scan(/\+([1234567890abcdef]+)|(.)/).map{|a| a[0].nil? ? a[1] : [a[0].hex].pack("U")}
    # As there are no unary operators, unary form is an abbreviated binary or ternary form only.
    # Thus, if a unary form is given, i expand it into appropriate binary or ternary form.
    args = args * @scales[verb].length if args.length==1  
    return verb, args
  end
  
  protected
  
  # Returns a copy of the Hash with every key containing several characters
  # replaces with several one-characters keys (while keeping the value).
  def split_keys(h)
    i = {}
    h.each do |k,v|
      if k =~ /,/
        k.split(',').each {|c| i[c] = v}
      else
        i[k] = v
      end
    end
    return i
  end
end

# A method to know if a string is a valid number
class String
  def positive_numeric?
    Float(self) > 0 rescue false
  end
end

def main
  fontsize = ARGV[1] || "64"
  fontfamily = ARGV[2] || "serif"
  z = ZaoZi.new()
  verb, args = z.normalize_command(ARGV[0])
  puts z.compose(verb, args, fontsize, fontfamily)
end

if __FILE__==$0
  main
end