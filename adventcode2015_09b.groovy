/** Groovy code.
 * advent of code 2015. kannix68 (@github).
 * Day 9: All in a Single Night
 *
 * Traveling Salesman Problem (shortest path).
 * Brute force solution, only omitting mirrored sets
 *   (backwards travel is same distance as forwards travel).
 */

//evaluate(new File("../tools/Tools.groovy")) // currently not working

/**
 * Advent of code day 09 Part A solver (our algorithm).
 * Contains day specific fields and methods.
 */
class Day09bSolver extends AocBase {
  List places = []
  List placePermuts = []
  Map pathDists = [:]
  Long maxPathLen = -1
  String maxPath = ""
  Long iters = 0L

  //** Read in path distances from file; with side effects.
  def readFile(String fn) {
    //String fileContents = new File('/path/to/file').text
    File f = new File(fn)
    f.eachLine() {
      def match = ( it =~ /^(\w+) to (\w+) = (\d+)$/ )
      match.find()
      assert match.groupCount() == 3
      String p1 = match.group(1)
      String p2 =  match.group(2)
      int dist = match.group(3).toInteger()
      deblog "${p1} -> ${p2} := ${dist}"
      if ( !places.contains(p1) ) {
        places << p1
      }
      if ( !places.contains(p2) ) {
        places << p2
      }
      def k = [p1, p2].sort()
      pathDists[k] = dist
    }
  }

  //** Calculate distance for a given path; with side effects.
  def calcDist(List lst) {
    long dist = 0
    for (int i = 0; i < lst.size-1; i++) {
      def k = [lst[i], lst[i+1]].sort()
      dist += pathDists[k]
    }
    tracelog "path=${lst} pathLen=${dist} calculated"
    if ( dist > maxPathLen ) {
      infolog "new maxPathLen=${dist} for path ${lst} @iter #${placePermuts.size()}c of ${iters}p"
      maxPathLen = dist
      maxPath = "${lst}"
    }
  }

  //** Do solution and analysis.
  def solve(String fn) {
    readFile(fn)
    infolog "places (##${places.size()})=${places}"
    infolog "pathDists (##${pathDists.size()})=${pathDists}"

    places.eachPermutation {
      iters++
      if ( !placePermuts.contains(it.reverse()) ) {
        placePermuts << it
        calcDist(it)
      }
    }
    println "result:  maxLen=${maxPathLen} for path=${maxPath};\n" +
      "  calculated ${placePermuts.size()} paths of ${iters} permutations"
  }
} // end class

//!* "MAIN"
if ( args.size() != 1 ) {
  println "ABORT: exactly one commandline script argument required: filename"
  System.exit(-1)
}
Day09bSolver.newInstance().solve(args[0])

//!* Helpers

/**
 * Advent of code base class.
 */
abstract class AocBase {
  protected int DEBLOG = 0  // 0|1|2

  //!* Helpers

  //** Trace level logging.
  def tracelog(String s) {
    if ( DEBLOG > 1 ) {
      System.err.println "T: ${s}"
    }
  }

  //** Debug level logging.
  def deblog(String s) {
    if ( DEBLOG > 0 ) {
      System.err.println "D: ${s}"
    }
  }

  //** Info level logging.
  def infolog(String s) {
    System.err.println "I: ${s}"
  }

} // end base class

