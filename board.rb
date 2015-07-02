require 'colorize'
require_relative 'piece'
require_relative 'emptysquare'

class Board
	attr_accessor :cursor_pos, :grid

	def initialize
		@grid = Array.new(8) { Array.new(8) { EmptySquare.new } }
		@cursor_pos = [0,0]
		populate_starting_grid
	end


	def move!(start_pos, end_pos)
		#move and capture
	end
		
	def cursor_new_loc(pos)
		r, c = pos
		@cursor_pos = [@cursor_pos[0] + r, @cursor_pos[1] + c]
		@cursor_pos
	end

	def current_piece(pos)
		@grid[pos[0]][pos[1]]
	end
	
	######## render & populate board ###########

	def render
		#system "clear"
		puts
		puts "          Checkers"
		puts
		@grid.each_with_index do |row, row_idx|
			print "      "
			row.each_with_index do |sqr, sqr_idx|
				current_pos = [row_idx, sqr_idx]
				if @cursor_pos == current_pos && sqr.color != :black
					print "#{sqr.icon} ".colorize(:color => :red, :background => :light_yellow)
				elsif @cursor_pos == current_pos && sqr.color != :red
					print "#{sqr.icon} ".colorize(:color => :black, :background => :light_yellow)
				elsif (sqr_idx + row_idx).even?
					if sqr.color != :red
						print "#{sqr.icon} ".colorize(:color => :black, :background => :light_white)
					else
						print "#{sqr.icon} ".colorize(:color => :red, :background => :light_white)
					end
				elsif (sqr_idx + row_idx).odd?
					if sqr.color != :black
						print "#{sqr.icon} ".colorize(:color => :red, :background => :green)
					else
						print "#{sqr.icon} ".colorize(:color => :black, :background => :green)
					end
				end
			end
			puts
		end
		puts
	end

	def populate_starting_grid
		@grid.each_with_index do |row, row_idx|
			row.each_with_index do |sqr, sqr_idx|
				if row_idx <= 2
					if (row_idx + sqr_idx).odd?
						@grid[row_idx][sqr_idx] = Piece.new(:black, [row_idx,sqr_idx])
					end
				elsif row_idx >= 5
					@grid[row_idx][sqr_idx] = Piece.new(:white, [row_idx,sqr_idx]) if (row_idx + sqr_idx).odd?
				end
			end
		end
	end		


	######## duplicate the board itself (not just grid) #######
  def dupe
    new_board = Board.new
    copy_grid = new_board.grid
    @grid.each_with_index do |row, row_idx|
      row.each_with_index do |square, col_idx|
        if !square.empty?
          copy_grid[row_idx][col_idx] = square.class.new([row_idx, col_idx], square.color, Board.new)
        else
          copy_grid[row_idx][col_idx] = square.class.new
        end
      end
    end
    new_board
  end



end
