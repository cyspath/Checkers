
class Piece
	attr_accessor :king, :current_pos
	attr_reader :icon, :color

	def initialize(color, start_pos)
		@king = false
		@color = color # :black on top, :white on bottom
		@icon = "x"
		@current_pos = start_pos
		set_icon # which will set it to circles
	end

	def all_possible_moves #directions \(1) /(2) \(3) /(4)
		r, c = @current_pos

		u_l = []
		u_r = []
		d_r = []
		d_l = []
		all_directions_arr = [u_l, u_r, d_r, d_l]

		(1..7).each do |n|
			u_l << [r - n, c - n]
			u_r << [r - n, c + n]
			d_r << [r + n, c + n]
			d_l << [r + n, c - n]
		end

		all_directions_arr.each do |direction_arr|
			direction_arr.select! do |pos|
				(0..7).include?(pos[0]) && (0..7).include?(pos[1])
			end
		end
		all_directions_arr
	end

	def all_stepping_moves
		r, c = @current_pos
		arr = [[r - 1, c - 1], [r - 1, c + 1], [r + 1, c + 1], [r + 1, c - 1]]
		if @king = true
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
		if @king = true
			return arr
		elsif @color == :black
			return arr.drop(2)
		elsif @color == :white
			return arr.take(2)
		end
		# returns [[r,c],[pos],[pos],[pos]]
	end



	def valid_move?(pos)
		
	end

	def crown_king
		@king = true
	end

	def set_icon
		if @color == :black
			@icon = "⚫"
		else
			@icon = "⚪"
		end
	end

	def empty?
		false
	end

end


# ⚪
# ⚫