require 'rr-sweatshop'

begin
  Randexp::Dictionary.load_dictionary
rescue RuntimeError
  warn '[WARNING] Neither /usr/share/dict/words or /usr/dict/words found, skipping dm-sweatshop specs'
  exit
end
