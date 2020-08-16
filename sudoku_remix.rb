#!/usr/bin/env ruby
# 16x16 sudoku solver - assumes the 16 tokens are [1-9] and [A-G]
# This sudoku solver absolutely sucks and needs to be rethought

#index ranges for rows/columns. this gets used a lot, easier to type
$PUZZLE_RANGE = (0..15).to_a

#reads input file of unsolved sudoku puzzle, saves in 2D array of integers, denotes blank cells as 0
def readPuzzle(file)
	grid = Array.new(16) { Array.new(16) }
        input = Array.new

        f = File.read(file).split
        f.each do |a|
                if a.match(/\./)
                  input << 0.to_s 
                elsif a.match(/\d/)
                  input << a.to_s
                elsif a.match(/[A-Ga-g]/)
                  input << a.to_s
                end
        end

        $PUZZLE_RANGE.each do |a|
            grid[a] = input.slice(0,16)
            input.shift(16)
        end
	
	return grid
end

def possibleValues(grid, i, j) 
        tokens = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F", "G"]
        boxVals = []

	rowVals = 16.times.collect { |col| grid[i][col] }
	colVals = 16.times.collect { |row| grid[row][j] }

	#eliminate values in 3x3 box
	boxX = i / 4
        boxY = j / 4

        ((boxX * 4)..((boxX * 4) + 3)).each do |i|
                ((boxY * 4)..((boxY * 4) + 3)).each do |j|
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
                  if grid[i][j] == 0.to_s
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
                                        temp[i][j] = 0.to_s
				end
			return nil
			end
		end
	end
	return grid
end
				

#janky sudoku print
def prettyPrint(grid)
        print " --------------------------------------- \n"
        $PUZZLE_RANGE.each do |i|
                if i % 4 == 0 and i != 0
                        print "|---------+---------+---------+---------|\n"
                end
                print "| "

                $PUZZLE_RANGE.each do |j|
                        if j % 4 == 0 and j != 0
                                print "| "
                        end
                        print "#{grid[i][j]} "
                end
                print "|\n"
        end
        print " --------------------------------------- \n"
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
