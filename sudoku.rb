#!/usr/bin/env ruby

#index ranges for rows/columns. 
$PUZZLE_RANGE = (0..8).to_a

#puzzle type accomodates for different potential charsets
$TYPE = 0

#reads input file of unsolved sudoku puzzle, saves in 2D array of integers, denotes blank cells as 0
def readPuzzle(file)
    grid = Array.new(9) { Array.new(9) }
    input = Array.new

    f = File.read(file).split("")
    f.each do |a|
        if a.match(/\./)
            input << "."
        elsif a.match(/\d/)
            input << a.to_i
            $TYPE = 1
        elsif a.match(/[A-I]/)
            input << a
            $TYPE = 2
        elsif a.match(/[a-i]/)
            input << a
            $TYPE = 3
        end
    end

    $PUZZLE_RANGE.each do |a|
        grid[a] = input.slice(0,9)
        input.shift(9)
    end
  
    return grid
end

def setTokens()
    if $TYPE == 1
        return (1..9).to_a
    elsif $TYPE == 2
        return ("A".."I").to_a
    elsif $TYPE == 3
        return ("a".."i").to_a
    end
end

def possibleValues(grid, x, y) 
    boxVals = []
  
    tokens = setTokens()

    rowVals = 9.times.collect { |col| grid[x][col] }
    colVals = 9.times.collect { |row| grid[row][y] }

    #checks for tokens in 3x3 box
    boxX = x / 3
    boxY = y / 3

    ((boxX * 3)..((boxX * 3) + 2)).each do |i|
        ((boxY * 3)..((boxY * 3) + 2)).each do |j|
            boxVals << grid[i][j]
        end
    end
  
    tokens -= rowVals.uniq
    tokens -= colVals.uniq	
    tokens -= boxVals.uniq
end
       
#driving solve function
def solve(grid)
    $PUZZLE_RANGE.each do |i|
        $PUZZLE_RANGE.each do |j|
            if grid[i][j] == "."
	        temp = grid.dup

	    tokens = possibleValues(grid, i, j)
	    if tokens.empty?
	        return nil
	    end
				
	    tokens.each do |token|
	        temp[i][j] = token
	        if solve(temp)
	            return temp
	    end
	    temp[i][j] = "."
	  end
          return nil
        end
     end
  end
  return grid
end
				

#janky sudoku print
def prettyPrint(grid)
    print " ----------------------- \n"
    $PUZZLE_RANGE.each do |i|
        if i % 3 == 0 and i != 0
           print "|-------+-------+-------|\n"
        end
        print "| "

        $PUZZLE_RANGE.each do |j|
        if j % 3 == 0 and j != 0
            print "| "
        end
        print "#{grid[i][j]} "
      end
    print "|\n"
    end
print " ----------------------- \n"
end

#check for an input argument, default to reading "puzzle"
if ARGV.empty?
    file = "puzzle"
else
    file = ARGV[0]
end

#read, solve, print
grid = readPuzzle(file)
prettyPrint(grid)
print "\nSolving puzzle...\n\n"
solution = solve(grid)
prettyPrint(solution)

