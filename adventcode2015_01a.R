## R (R-language)
# advent of code 2015. kannix68 (@github).
# Day 1: Not Quite Lisp.

# sorry, please currently set your directory 
setwd('~/devel/advent_of_code_2015')
inFileName = 'adventcode2015_in01.txt'

#** our algorithm
algo <- function(s){
  ups = gsub('\\)', '', s)
  n_all = nchar(s)
  n_ups = nchar(ups)
  n_downs = n_all - n_ups
  pos = n_ups - n_downs
  return(pos)
}

#** TESTING
s = '('
res = algo(s);
stopifnot(1 == res)

s = '(())'
res = algo(s);
stopifnot(0 == res)
s = '()()'
res = algo(s);
stopifnot(0 == res)

s = '((('
res = algo(s);
stopifnot(3 == res)
s = '(()(()('
res = algo(s);
stopifnot(3 == res)
s = '))((((('
res = algo(s);
stopifnot(3 == res)

s = '())'
res = algo(s);
stopifnot(-1 == res)
s = '))('
res = algo(s);
stopifnot(-1 == res)

s = ')))'
res = algo(s);
stopifnot(-3 == res)
s = ')())())'
res = algo(s);
stopifnot(-3 == res)

#** "MAIN"
print(getwd())
ins = gsub("[\r\n]", "", readChar(inFileName, file.info(inFileName)$size) )
print('input string was read')

res = algo(ins)
print(paste("result=", res, sep=''))
