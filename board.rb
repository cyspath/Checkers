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


	def step_move!(start_pos, end_pos)
		#move and capture
		start_piece = @grid[start_pos[0]][start_pos[1]]
		@grid[end_pos[0]][end_pos[1]] = start_piece
		@grid[end_pos[0]][end_pos[1]].current_pos = end_pos
		@grid[start_pos[0]][start_pos[1]] = EmptySquare.new
	end

	def jump_move!(start_pos, end_pos)
		#middle square is now empty by..
		@grid[(start_pos[0] + end_pos[0])/2][(start_pos[1] + end_pos[1])/2] = EmptySquare.new

		#now endpos is piece, and start pos is empty
		start_piece = @grid[start_pos[0]][start_pos[1]]
		@grid[end_pos[0]][end_pos[1]] = start_piece
		@grid[end_pos[0]][end_pos[1]].current_pos = end_pos
		@grid[start_pos[0]][start_pos[1]] = EmptySquare.new
	end
		
	def check_king
		@grid[0].each_with_index do |sqr, sqr_idx|
			if sqr.color == :white
				@grid[0][sqr_idx].king = true
				@grid[0][sqr_idx].set_icon
			end
		end
		@grid[7].each_with_index do |sqr, sqr_idx|
			if sqr.color == :black
				@grid[7][sqr_idx].king = true
				@grid[7][sqr_idx].set_icon
			end
		end
	end

	def winner_found
		white = false
		black = false
		@grid.each do |row|
			row.each do |sqr|
				if sqr.color == :white
					white = true
				elsif sqr.color == :black
					black = true
				end
			end
		end

		if white == true && black == false
			puts "Congrats, player ⚪ won!"
			return true
		elsif white == false && black == true
			puts "Congrats, player ⚫ won!"
			return true
		end
		false		
	end

	def cursor_new_loc(pos)
		r, c = pos
		new_pos = [@cursor_pos[0] + r, @cursor_pos[1] + c]
		new_pos
	end

	def set_new_cursor_pos(pos)
		@cursor_pos = pos
	end

	def current_piece(pos)
		@grid[pos[0]][pos[1]]
	end

	######## render & populate board ###########

	def render
		system "clear"
		puts
		puts "          Checkers"
		puts
		@grid.each_with_index do |row, row_idx|
			print "      "
			row.each_with_index do |sqr, sqr_idx|
				current_pos = [row_idx, sqr_idx]
				if @cursor_pos == current_pos && sqr.color != :black
					print "#{sqr.icon} ".colorize(:color => :light_white, :background => :light_yellow)
				elsif @cursor_pos == current_pos && sqr.color != :light_white
					print "#{sqr.icon} ".colorize(:color => :black, :background => :light_yellow)
				elsif (sqr_idx + row_idx).even?
					if sqr.color != :light_white
						print "#{sqr.icon} ".colorize(:color => :black, :background => :light_white)
					else
						print "#{sqr.icon} ".colorize(:color => :light_white, :background => :light_white)
					end
				elsif (sqr_idx + row_idx).odd?
					if sqr.color != :black
						print "#{sqr.icon} ".colorize(:color => :light_white, :background => :green)
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
						@grid[row_idx][sqr_idx].set_icon
					end
				elsif row_idx >= 5
					@grid[row_idx][sqr_idx] = Piece.new(:white, [row_idx,sqr_idx]) if (row_idx + sqr_idx).odd?
					@grid[row_idx][sqr_idx].set_icon
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
