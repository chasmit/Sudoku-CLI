# Sudoku
Messing around with Ruby.  These are sudoku solvers that run on a command line interface, working on an input file of space-separated characters representing the puzzle.  Blank spaces in the puzzle are represented by a period. Sample file 'string' illustrates.  

The solution is printed in a more accessible ASCII representation of a sudoku puzzle.

CLI Usage: ./sudoku.rb string
 
I might make a friendlier interface one day if I feel like it.

sudoku.rb: standard 9x9 sudoku solver. Supports puzzles with character ranges [1-9], [a-i], and [A-I].

sudoku_remix.rb: 16x16 sudoku solver.  This one is highly flawed in its present state because I am a stupid idiot.
