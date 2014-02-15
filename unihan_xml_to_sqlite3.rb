class Character
  def initialize(kCantonese, kDefinition, kMandarin, kHanyuPinyin, kCangjie, kRSKangXi)
    @kCantonese = kCantonese # Jyutping
    @kDefinition = kDefinition # Gloss
    @kMandarin = kMandarin # Most common pinyin
    @kHanyuPinyin = split_pinyin(kHanyuPinyin) # Pinyin
    @kCangjie = kCangjie # Cangjie
    @kRSKangXi = split_radical(kRSKangXi) # Radical
  end

  def split_pinyin(pinyin)

  end

  def split_radical(kangxi)
    kangxi.matches(/(\D)+\..*/)
  end
end

unihan = Array.new

unihan_file = File.open("ucd.unihan.flat copy.xml").read