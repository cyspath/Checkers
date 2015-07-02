
class EmptySquare
	attr_accessor :king
	attr_reader :icon, :color

	def initialize
		@king = false
		@color = :yellow
		@icon = " "
	end

	def empty?
		true
	end

	def set_icon
	end

end