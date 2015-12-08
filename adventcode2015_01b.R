## R (R-language)
# advent of code 2015. kannix68 (@github).
# Day 1: Not Quite Lisp.
# Part [B].

# sorry, please currently set your directory 
setwd('~/devel/advent_of_code_2015')
inFileName = 'adventcode2015_in01.txt'

#** our algorithm
algo <- function(s) {
  floor_num = 0
  pos = 0;
  for(c in unlist(strsplit(s, ''))) {
    pos <- pos + 1
    if ('('== c) {
      floor_num <- floor_num + 1
    } else if (')' == c) {
      floor_num <- floor_num - 1
    }
    if (floor_num == -1) {
      break;
    }
  }
  return(pos)
}

#** TESTING
s = ')'
res = algo(s);
stopifnot(1 == res)

s = '()()))'
res = algo(s);
stopifnot(5 == res)

#** "MAIN"
ins = gsub("[\r\n]", "", readChar(inFileName, file.info(inFileName)$size) )
print('input string was read')

res = algo(ins)
print(paste("result=", res, sep=''))
