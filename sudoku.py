import re
import string
import sys

PUZZLE_RANGE = [*range(0,9,1)]  # index ranges for individual rows/columns.
CELL_NUMBER = 81                # number of cells
HEIGHT = 9                      # height of grid
WIDTH = 9                       # width of grid


# take 81-char string representing sudoku puzzle, transform into 9x9 grid
# determine appropriate character set based on input
def parse_puzzle(input):
    print("Reading puzzle...")
    char_type = 1
    grid = [[0] * HEIGHT] * WIDTH
    arr = []

    f = list(input)
    for a in f:
        if re.match(r'\.', a):
            arr.append(a)
        elif re.match(r'\d', a):
            char_type = 1
            arr.append(int(a))
        elif re.match(r'[A-I]', a):
            char_type = 2    
            arr.append(a)
        elif re.match(r'[a-i]', a):
            char_type = 3     
            arr.append(a)

    for i in PUZZLE_RANGE:
        grid[i] = arr[i*9:i*9+9]
    
    return grid, char_type


# based on input string, assign possible values for individual squares on grid
def set_tokens(char_type):
    if char_type == 1:
        return [*range(1,10,1)]
    elif char_type == 2:
        return list(string.ascii_uppercase[:9])
    elif char_type == 3:
        return list(string.ascii_lowercase[:9])


# determine possible values for a given square based on basic game logic
# exclude values in same row, column and neighboring 3x3 grid
def possible_values(char_type, grid, i, j):
    tokens = set_tokens(char_type)
    
    col_vals, row_vals, box_vals = [], [], []

    for y in range(HEIGHT):
        if grid[y][j] != ".":
            col_vals.append(grid[y][j])

    for x in range(WIDTH):
        if grid[i][x] != ".":
            row_vals.append(grid[i][x])

    boxX = i//3
    boxY = j//3

    for x in range(boxX*3,boxX*3+3):
        for y in range(boxY*3,boxY*3+3):
            if grid[x][y] != ".":
                box_vals.append(grid[x][y])

    tokens = [item for item in tokens if item not in col_vals]
    tokens = [item for item in tokens if item not in row_vals]
    tokens = [item for item in tokens if item not in box_vals]

    return tokens


# recursive backtracking solving algorithm
# i don't feel like explaining it in a comment
def solve(char_type, grid):
    tokens = []
    temp = [[0] * HEIGHT] * WIDTH

    for i in PUZZLE_RANGE:
        for j in PUZZLE_RANGE:
            if grid[i][j] == '.':
                temp = grid
                tokens = possible_values(char_type, grid, i, j)
                if not tokens:
                    return None

                for a in tokens:
                    temp[i][j] = a
                    if solve(char_type, temp):
                        return temp
                    temp[i][j] = '.'
                return None              
    return grid


# command-line printing of a sudoku board of indescribable beauty
def pretty_print(grid):
    print (" ----------------------- ")
    for i in PUZZLE_RANGE:
        if i % 3 == 0 and i != 0:
            print("|-------+-------+-------|")
        print("| ", end='')

        for j in PUZZLE_RANGE:
            if j % 3 == 0 and j != 0:
                print("| ", end='')
            print(str(grid[i][j]) + " ", end='')
        print("|")
    print(" ----------------------- ")


# driving main function.  read puzzle, print, solve, print
def main():
    if len(sys.argv) == 1 or len(sys.argv[1]) != CELL_NUMBER:
        print("Error getting puzzle information")
        quit()

    grid, char_type = parse_puzzle(sys.argv[-1])
    pretty_print(grid)
    print("\nSolving puzzle...")
    solution = solve(char_type, grid)
    pretty_print(solution)


# python name-checking bullshit
if __name__=="__main__":
    main()