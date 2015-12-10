## R (R-language)
# advent of code 2015. kannix68 (@github).
# Day 1: Not Quite Lisp.
# Part [A and B] **with graphics**. Saves a PDF file `[outfilename]`.

# sorry, please currently set your directory 
setwd('~/devel/advent_of_code_2015')
inFileName = 'adventcode2015_in01.txt'
outfilename = 'adventcode2015_out01.pdf'

#** our algorithm
algo <- function(s) {
  gv = c() # rep(NA,10)
  floor_num = 0
  pos = 0;
  for(c in unlist(strsplit(s, ''))) {
    pos <- pos + 1
    if ('('== c) {
      floor_num <- floor_num + 1
    } else if (')' == c) {
      floor_num <- floor_num - 1
    }
    gv = append(gv, floor_num)
  }
  return(gv)
}

#** "MAIN"
ins = gsub("[\r\n]", "", readChar(inFileName, file.info(inFileName)$size) )
print('input string was read')

resv = algo(ins)
#print(paste("result=", res, sep=''))
ybase = -1
xbase = which(resv == ybase)[1]
print(xbase)
xlen = length(resv)
ylast = resv[length(resv)]

#print(resv)
#plot(resv)
#barplot(resv)
#plot(resv, type='o')
plot(resv, type='l', xlab='# of steps', ylab='floor #')
print(paste("first time in basement at move #", xbase))
print(paste("floor # after last move", ylast, "; # of moves:", xlen))
points(xbase, -1, type='o', col='red')
points(xlen, ylast, type='o', col='red', pch=6)
text( xbase, ybase, labels=paste("(", xbase, ",", ybase,")", sep=""), adj=c(-0.1,-0.1) )
text( xlen, ylast, labels=paste("(", xlen, ",", ylast,")", sep=""), adj=c(+1.1,-0.1) )

dev.print(pdf, outfilename)