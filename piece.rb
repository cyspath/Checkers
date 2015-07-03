
class Piece
	attr_accessor :king, :current_pos
	attr_reader :icon, :color

	def initialize(color, starting_pos, king = false)
		@king = king
		@color = color # :black on top, :white on bottom
		@icon = "x"
		@current_pos = starting_pos
		set_icon # which will set it to circles
	end

	def all_stepping_moves
		r, c = @current_pos
		arr = [[r - 1, c - 1], [r - 1, c + 1], [r + 1, c + 1], [r + 1, c - 1]]
		if @king 
			return arr
		elsif @color == :black
			return arr.drop(2)
		elsif @color == :white
			return arr.take(2)
		end
		# returns [[r,c],[pos],[pos],[pos]]
	end

	def all_jumping_moves
		r,c = @current_pos
		arr = [[r - 2, c - 2], [r - 2, c + 2], [r + 2, c + 2], [r + 2, c - 2]]
		if @king
			return arr
		elsif @color == :black
			return arr.drop(2)
		elsif @color == :white
			return arr.take(2)
		end
		# returns [[r,c],[pos],[pos],[pos]]
	end

	def check_stepping_moves(end_pos, board_obj)
		arr = all_stepping_moves

		if arr.include?(end_pos) &&
			board_obj.grid[end_pos[0]][end_pos[1]].empty?
			# puts "stepping check true"
			return true
		end
		# puts "step check false"
		false
	end

	def check_jumping_moves(end_pos, board_obj)
		arr = all_jumping_moves
		middle_piece = board_obj.grid[(end_pos[0] + @current_pos[0])/2][(end_pos[1] + @current_pos[1])/2]

		if arr.include?(end_pos) &&
			board_obj.grid[end_pos[0]][end_pos[1]].empty? &&
			(end_pos[0] - @current_pos[0]).abs == 2 &&
			(end_pos[1] - @current_pos[1]).abs == 2 &&
			!middle_piece.empty? &&
			middle_piece.color != @color

			# puts "jumping check true"
			return true
		end
		# puts "jumping check false"
		false
	end

	def valid_moves(end_pos, board_obj)
		# if checks of stepping moves or jumping moves returned true, go ahead and call the methods that can move the pieces in this method (board.step_move! and board.jump_move!)
		if check_stepping_moves(end_pos, board_obj)
			board_obj.step_move!(@current_pos, end_pos)
			return true
		elsif check_jumping_moves(end_pos, board_obj)
			board_obj.jump_move!(@current_pos, end_pos)

			multiple_jumps(end_pos, board_obj)

			return true
		else
			return false
		end

	end

	def multiple_jumps(end_pos, board_obj)
	end



	def crown_king
		@king = true
	end

	# def maybe_king?
	# 	self.position == back_row[self.color]
	# end

	def set_icon
		if @color == :black
			@icon = "⚫"
		elsif @color == :white
			@icon = "⚪"
		end
		
		if @king == true
			if @color == :white
				@icon = "♕" 
			end
			if @color == :black
				@icon = "♛" 
			end
		end

	end

	def empty?
		false
	end

end


# ⚪
# ⚫