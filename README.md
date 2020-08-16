# Sudoku
Messing around with Ruby.  These are sudoku solvers that run on a command line interface, working on an input file of space-separated characters representing the puzzle.  Blank spaces in the puzzle are represented by a period. I put up a sample file called 'string' to illustrate the needed input.  

The solution is printed in a more accessible ASCII representation of a sudoku puzzle.

CLI Usage: ./sudoku.rb string
 
I might make a friendlier interface one day if I feel like it.

sudoku.rb: 3x3 sudoku solver. Supports puzzles with character ranges [1-9], [a-i], and [A-I].

sudoku_remix.rb: 4x4 sudoku solver.  This one is presently very flawed because I am a fat stupid idiot.
