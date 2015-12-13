/** Groovy code. Welcome to the Java ecosystem.
 *
 * advent of code 2015. kannix68 (@github).
 * Day 13: Knights of the Dinner Table
 * Part [B]
 *
 * This is a variant of the day 9 Traveling Salesman problem,
 *   with a directed graph taken into account in both directions.
 * Brute force solution.
 */

//evaluate(new File("../tools/Tools.groovy")) // currently not working

/**
 * Advent of code day 13 Part B solver (our algorithm).
 * Contains day specific fields and methods.
 */
class Day13Solver extends AocBase {
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
      deblog "readfn >${it}<"
      // "Alice would gain 54 happiness units by sitting next to Bob."
      // "Alice would lose 79 happiness units by sitting next to Carol."
      def match = ( it =~ /^(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\.$/ )
      match.find()
      assert match.groupCount() == 4
      String p1 = match.group(1)
      String p2 =  match.group(4)
      int dist = match.group(3).toInteger()
      if ( match.group(2) == 'lose') {
        dist *= -1
      }
      deblog "${p1} -> ${p2} := ${dist}"
      if ( !places.contains(p1) ) {
        places << p1
      }
      if ( !places.contains(p2) ) {
        places << p2
      }
      //def k = [p1, p2].sort()
      def k = [p1, p2]
      pathDists[k] = dist
    }
  }

  // Add "me" to the table.
  def enrichPlaces() {
    places.each() {
      def k = [it, 'me']
      pathDists[k] = 0
      pathDists[k.reverse()] = 0
    }
    places.push('me')
  }

  //** Calculate distance for a given path; with side effects.
  def calcDist(List lst) {
    // add circular table last entry sitting next to start person
    lst.push(lst[0])
    long dist = 0
    for (int i = 0; i < lst.size-1; i++) {
      def k = [lst[i], lst[i+1]]
      dist += pathDists[k] + pathDists[k.reverse()]
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
    enrichPlaces()
    infolog "places (##${places.size()})=${places}"
    infolog "pathDists (##${pathDists.size()})=${pathDists}"

    places.eachPermutation {
      iters++
      if ( !placePermuts.contains(it.reverse()) ) {
        placePermuts << it
        calcDist(it)
      }
    }
    println "result: maxLen=${maxPathLen} for path=${maxPath};\n" +
      "  calculated ${placePermuts.size()} paths of ${iters} permutations"
  }
} // end class

//!* "MAIN"
if ( args.size() != 1 ) {
  println "ABORT: exactly one commandline script argument required: filename"
  System.exit(-1)
}
Day13Solver.newInstance().solve(args[0])

//!* Helpers

/**
 * Advent of code base class.
 */
abstract class AocBase {
  protected int DEBLOG = 1  // 0|1|2

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

// ###################################
/*
Alice would gain 54 happiness units by sitting next to Bob.
Alice would lose 79 happiness units by sitting next to Carol.
Alice would lose 2 happiness units by sitting next to David.
Bob would gain 83 happiness units by sitting next to Alice.
Bob would lose 7 happiness units by sitting next to Carol.
Bob would lose 63 happiness units by sitting next to David.
Carol would lose 62 happiness units by sitting next to Alice.
Carol would gain 60 happiness units by sitting next to Bob.
Carol would gain 55 happiness units by sitting next to David.
David would gain 46 happiness units by sitting next to Alice.
David would lose 7 happiness units by sitting next to Bob.
David would gain 41 happiness units by sitting next to Carol.
*/