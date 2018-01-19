require 'minitest/autorun'
require 'minitest/colorize'
require './zaozi'

describe ZaoZi do
  before do
    @z = ZaoZi.new
  end
  
  describe 'compose' do
    it 'should accept unary form for binary operators' do
      skip
      @z.compose('⿰',['胡']).must_equal @z.compose('⿰',['胡','胡'])
    end
    
    it 'should accept unary form for ternary operators' do
      skip
      @z.compose('△',['胡']).must_equal @z.compose('△',['胡','胡','胡'])
    end
    
    it 'should replace radicals with alternative form' do
      @z.compose('⿰',['王','元']).must_equal @z.compose('⿰',['⺩','元'])
    end
  end
  
  describe 'normalize command' do
    
    it 'should leave normal command intact' do
      @z.normalize_command('△羊小胡').must_equal ['△', ['羊','小','胡']]      
    end
    
    it 'should normalize mnemonics' do
      @z.normalize_command('TR羊小胡').must_equal ['△', ['羊','小','胡']]      
    end
    
    it 'should normalize codepoints' do
      @z.normalize_command('△+7f8a+5c0f+80e1').must_equal ['△', ['羊','小','胡']]      
    end
    
    it 'should normalize codepoints with mnemonics' do
      @z.normalize_command('TR+7f8a+5c0f+80e1').must_equal ['△', ['羊','小','胡']]      
    end  
    
    it 'should normalize a mix of codepoints and characters' do
      @z.normalize_command('△羊小+80e1').must_equal ['△', ['羊','小','胡']]      
    end
    
    it 'should normalize a mix of codepoints and characters with mnemonics' do
      @z.normalize_command('TR羊+5c0f胡').must_equal ['△', ['羊','小','胡']]
    end
  end
end