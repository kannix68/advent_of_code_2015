/* JavaScript code for node.js
 **
 * advent of code 2015. kannix68 (@github).
 * Day 8: Day 8: Matchsticks
 * Part [B].
 */

var fs = require('fs');
var assert = require('assert');
var DEBLOG = 0;  // 0|1|2

//** Helpers

function tracelog(s) {
  if ( DEBLOG > 1 ) {
    console.log("T: " + s);
  }
}
function deblog(s) {
  if ( DEBLOG > 0 ) {
    console.log("D: " + s);
  }
}
function infolog(s) {
  console.log("I: " + s);
}

 //** our algorithm
function algo_exec(ins) {
  ains = ins.split(/\r?\n/);
  tracelog("input array=" + ains);
  var ailen = ains.length;
  var dsum = 0;
  for (var i = 0; i < ailen; i++) {
    s = ains[i];
    t = s
    s = s.replace(/\s+/g,'');
    if ( s === '' ) {
      continue;
    }
    //keep surrounding quotes //res = s.match(/^"(.*)"$/);
    s = s.replace(/\\/g, "\\\\");  // \\ => backslash .
    s = s.replace(/"/g, '\\"');  // \quote => quote .
    s = '"' + s + '"'

    d = s.length - t.length;
    dsum = dsum + d;
    deblog(
      i + "=" + t + " : >" + s + "< " + s.length + "-" + t.length + "=" + d
    );
  }
  return(dsum);
}

//** "MAIN"
deblog("argv0=" + process.argv[0]);
deblog("argv1=" + process.argv[1]);
deblog("argv2=" + process.argv[2]);
var infile = process.argv[2];

if ( typeof infile === 'undefined' ||  !infile ) {
  console.log("ABORT: please give input filename as cmdline argument");
  exit(-1);
}

var ins = '';
fs.readFile(infile, 'ascii', function (err,data) {
  if (err) {
    return console.log(err);
  }
  //console.log(data);
  ins = ins + data;
  deblog("read done");
  var res = algo_exec(ins);
  infolog("result for " + infile + " =" + res);
  assert(res > 0, "result is > 0");
});

