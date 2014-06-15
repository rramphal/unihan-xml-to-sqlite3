require 'sqlite3'

db = SQLite3::Database.new( "unihan.sqlite" )

db.execute( "DROP TABLE IF EXISTS characters" )

db.execute( "CREATE TABLE characters
                ( character VARCHAR,
                  simplified VARCHAR,
                  kDefinition TEXT,
                  readings TEXT,
                  jyutping VARCHAR,
                  radical INT,
                  cangjie VARCHAR,
                  code VARCHAR )" )

unihan_file = File.readlines("ucd.unihan.flat.xml")

unihan_file.each do |line|
  # RAW UNICODE RESULTS
  kSimplifiedVariant = line.include?("kSimplifiedVariant") ? / kSimplifiedVariant="(.*?)"/.match(line)[1] : nil # simplfied
  kMandarin          = line.include?("kMandarin")          ? / kMandarin="(.*?)"/.match(line)[1]          : nil # most common pinyin
  kDefinition        = line.include?("kDefinition")        ? / kDefinition="(.*?)"/.match(line)[1]        : nil # gloss
  kHanyuPinyin       = line.include?("kHanyuPinyin")       ? / kHanyuPinyin="(.*?)"/.match(line)[1]       : nil # pinyin
  kCantonese         = line.include?("kCantonese")         ? / kCantonese="(.*?)"/.match(line)[1]         : nil # jyutping
  kRSUnicode         = line.include?("kRSUnicode")         ? / kRSUnicode="(.*?)"/.match(line)[1]         : nil # radical
  kCangjie           = line.include?("kCangjie")           ? / kCangjie="(.*?)"/.match(line)[1]           : nil # cangjie
  cp                 = line.include?("cp")                 ? / cp="(.*?)"/.match(line)[1]                 : nil # codepoint

  # TRANSFORMATIONS
  kSimplifiedVariant = kSimplifiedVariant.nil? ? nil : (/^U+(.*)$/.match(kSimplifiedVariant)[1]).to_i(16).chr('UTF-8')
    # this parses out the codepoint of the simplified version and converts it from hex to decimal and then to the character
  kRSUnicode         = kRSUnicode.nil?         ? nil : kRSUnicode.to_i
    # this converts the radical.stroke string to an integer, cutting off the decimal (the strokes)

  kHanyuPinyin = kMandarin if kHanyuPinyin.nil?
    # if kHanyuPinyin is empty, copy kMandarin into it (even if kMandarin is nil itself)

  if not kHanyuPinyin.nil? # as long as there is something to work with in kHanyuPinyin
    # this accounts for readings listed as "10585.010:kuáng 10589.110:chéng,chěng"
    kHanyuPinyin.gsub!(/ /, ',')
    # replace spaces with commas
    kHanyuPinyin.gsub!(/(?<=\d),(?=\d)/, '')
    # remove commas between digits as in readings like "20961.010,20961.020:yì"
    kHanyuPinyin.gsub!(/[\d\.:]/, '')
    # remove digits, periods, and colons
    kHanyuPinyin.gsub(/ /, '')
    # remove any spaces (just in case)
    kHanyuPinyin = kHanyuPinyin.split(',')
    # split the string into an array based on the commas
    kHanyuPinyin.unshift(kMandarin) unless kMandarin.include?(',')
    # push kMandarin to the beginning of kHanyuPinyin (unless is just in case)
    kHanyuPinyin.compact!
    # remove any nils (just in case)
    kHanyuPinyin.uniq!
    # remove any duplicates (will be many since we added kMandarin to kHanyuPinyin)
    kHanyuPinyin = kHanyuPinyin.join(",")
  end

  # INSERT INTO DATABASE
  if not cp.nil?
    character = cp.to_i(16).chr('UTF-8') # generates character from codepoint
     db.execute( "INSERT INTO characters (character, simplified, kDefinition, readings, jyutping, radical, cangjie, code)
                    VALUES ( ? , ? , ? , ? , ? , ? , ? , ? )",
                      character, kSimplifiedVariant, kDefinition, kHanyuPinyin, kCantonese, kRSUnicode, kCangjie, cp )
    print character
  end
end

print "\n"