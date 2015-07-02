require 'io/console'
require_relative 'board'
require_relative 'player'

class Checkers

	def initialize
		@board = Board.new
		@players = [Player.new(:white), Player.new(:black)]
	end

	def run

		until game_over || draw
			render_board

			select_and_move

			switch_players
		end

	end

	def render_board
		puts
		@board.render
		puts
	end

	def select_and_move
		start_pos = select_piece
		
		move_to_loc(start_pos)
	end

	def move_to_loc(start_pos)
		while true
			puts "Where to move the piece?"
			output = cursor_movement #gives desired coordinate, enter pressed
			#check if its a valid move
			piece_to_be_moved = @board.current_piece(start_pos) #piece

			if piece_to_be_moved.valid_move?(start_pos) == true
				@board.move!(start_pos, output)
				puts "Your piece is moved to #{output}"
				break
			else
				##### maybe check for DRAW here?
				puts "Unable to move there!"
			end
		end

	end

	def select_piece	# spits out pos of selected piece
		while true

			output = cursor_movement #gives coordinate when press enter

			current_piece = @board.current_piece(output) 

			if !current_piece.empty? && current_piece.color == @players.first.color
				break
			end

			puts "Please choose your own piece."

		end

		puts "chosen piece is #{current_piece.icon} a pos of #{output}"
		output #chosen piece's loc after hit enter

	end

	def moving_piece
	end

	def game_over
		false
	end

	def draw
		false
	end

	def cursor_movement
		
		while true
			string = STDIN.getch
			output = key_press_coordinate(string)

			new_cursor_pos = @board.cursor_new_loc(output)#also updates board's @cursor pos, currentpiece is a object
			render_board
			puts "Current cursor position is #{@board.cursor_pos}"

			if output == [0,0]
				break
			end

		end
		new_cursor_pos # [r,c]
	end

  def key_press_coordinate(string)

  	cursor_move_loc = [[-1,0], [0,1], [1, 0], [0,-1], [0,0]]

    case string
    when "w"
      return cursor_move_loc[0]
    when "d"
      return cursor_move_loc[1]
    when "s"
      return cursor_move_loc[2]
    when "a"
      return cursor_move_loc[3]
    when "\r"
      return cursor_move_loc[4]
    end
  end

  def switch_players
  	@players.reverse!
  end

end
