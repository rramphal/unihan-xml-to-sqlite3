unihan = File.open("ucd.unihan.flat copy.xml").read

class Character
  def initialize()
    @kCantonese = String.new
    @kDefinition = String.new
    @kMandarin = String.new
    @kCangjie = String.new
    @kRSUnicode = String.new
  end

  def split_pinyin(pinyin)
    
  end