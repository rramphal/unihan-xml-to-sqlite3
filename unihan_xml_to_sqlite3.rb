require 'sqlite3'

@db = SQLite3::Database.new( "unihan.sqlite" )

@db.execute( "DROP TABLE IF EXISTS characters" )

@db.execute( "CREATE TABLE characters
                ( character VARCHAR,
                  simplified VARCHAR,
                  pinyin VARCHAR,
                  kDefinition TEXT,
                  readings TEXT,
                  jyutping VARCHAR,
                  radical INT,
                  cangjie VARCHAR,
                  codepoint VARCHAR )" )

unihan_file = File.readlines("ucd.unihan.flat.xml")

unihan_file.each do |line|
  # RAW UNICODE RESULTS
  kSimplifiedVariant = line[/ kSimplifiedVariant="(.*?)"/] ? / kSimplifiedVariant="(.*?)"/.match(line)[1] : nil # simplfied
  kMandarin          = line[/ kMandarin="(.*?)"/]          ? / kMandarin="(.*?)"/.match(line)[1]          : nil # most common pinyin
  kDefinition        = line[/ kDefinition="(.*?)"/]        ? / kDefinition="(.*?)"/.match(line)[1]        : nil # gloss
  kHanyuPinyin       = line[/ kHanyuPinyin="(.*?)"/]       ? / kHanyuPinyin="(.*?)"/.match(line)[1]       : nil # pinyin
  kCantonese         = line[/ kCantonese="(.*?)"/]         ? / kCantonese="(.*?)"/.match(line)[1]         : nil # jyutping
  kRSUnicode         = line[/ kRSUnicode="(.*?)"/]         ? / kRSUnicode="(.*?)"/.match(line)[1]         : nil # radical
  kCangjie           = line[/ kCangjie="(.*?)"/]           ? / kCangjie="(.*?)"/.match(line)[1]           : nil # cangjie
  cp                 = line[/ cp="(.*?)"/]                 ? / cp="(.*?)"/.match(line)[1]                 : nil # codepoint

  # TRANSFORMATIONS
  kSimplifiedVariant = kSimplifiedVariant.nil? ? nil       : (/^U+(.*)$/.match(kSimplifiedVariant)[1]).to_i(16).chr('UTF-8')
  kRSUnicode         = kRSUnicode.nil?         ? nil       : kRSUnicode.to_i
  kHanyuPinyin       = kHanyuPinyin.nil?       ? kMandarin : /^.*?:(.*)$/.match(kHanyuPinyin)[1]

  # INSERT INTO DATABASE
  if not cp.nil?
    character = cp.to_i(16).chr('UTF-8') # generates character from codepoint
     @db.execute( "INSERT INTO characters (character, simplified, pinyin, kDefinition, readings, jyutping, radical, cangjie, codepoint)
                    VALUES ( ? , ? , ? , ? , ? , ? , ? , ? , ? )",
                      character, kSimplifiedVariant, kMandarin, kDefinition, kHanyuPinyin, kCantonese, kRSUnicode, kCangjie, cp )
    print character
  end
end