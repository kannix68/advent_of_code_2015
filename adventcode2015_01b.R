##
#

# sorry, please currently set your directory 
setwd('~/devel/advent_of_code_2015')
inFileName = 'adventcode2015_in01.txt'
#print(commandArgs())

#** our algorithm
algo <- function(s) {
  floor_num = 0
  pos = 0;
  for(c in unlist(strsplit(s, ''))) {
    pos <- pos + 1
    #print(c);
    if ('('== c) {
      #print("inc")
      floor_num <- floor_num + 1
    } else if (')' == c) {
      #print("dec")
      floor_num <- floor_num - 1
    }
    if (floor_num == -1) {
      #print(paste("break at",pos))
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
#print(getwd())
ins = gsub("[\r\n]", "", readChar(inFileName, file.info(inFileName)$size) )
#singleString <- paste(readLines(fileName), collapse=" ")
#print(ins)
print('input string was read')

res = algo(ins)
print(paste("result=", res, sep=''))
