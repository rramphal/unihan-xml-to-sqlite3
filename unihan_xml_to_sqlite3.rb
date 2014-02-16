require 'sqlite3'

@db = SQLite3::Database.new( "unihan.db" )

characters = Hash.new

unihan_file = File.readlines("ucd.unihan.flat copy.xml")

unihan_file.each do |line|
  kSimplifiedVariant = line[/ kSimplifiedVariant="(.*?)"/] ? / kSimplifiedVariant="(.*?)"/.match(line)[1] : nil # simplfied
  kMandarin          = line[/ kMandarin="(.*?)"/]          ? / kMandarin="(.*?)"/.match(line)[1]          : nil # most common pinyin
  kDefinition        = line[/ kDefinition="(.*?)"/]        ? / kDefinition="(.*?)"/.match(line)[1]        : nil # gloss
  kHanyuPinyin       = line[/ kHanyuPinyin="(.*?)"/]       ? / kHanyuPinyin="(.*?)"/.match(line)[1]       : nil # pinyin
  kCantonese         = line[/ kCantonese="(.*?)"/]         ? / kCantonese="(.*?)"/.match(line)[1]         : nil # jyutping
  kRSUnicode         = line[/ kRSUnicode="(.*?)"/]         ? / kRSUnicode="(.*?)"/.match(line)[1].to_i    : nil # radical
  kCangjie           = line[/ kCangjie="(.*?)"/]           ? / kCangjie="(.*?)"/.match(line)[1]           : nil # cangjie
  cp                 = line[/ cp="(.*?)"/]                 ? / cp="(.*?)"/.match(line)[1]                 : nil # codepoint

  if not cp.nil?
    character = cp.to_i(16).chr('UTF-8')
  end
end