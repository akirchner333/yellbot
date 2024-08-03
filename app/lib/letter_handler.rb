class LetterHandler
	def self.get_letter(input)
		BanLetter.banned?(resolve_handle(input))
	end

	def self.resolve_handle(input)
		return input if basic_letter?(input)

		return hex_to_char(input) if hex_code?(input)
	end

	def self.get_handle(input)
		return input if basic_letter?(input)

		return char_to_hex(input) if input.length == 1
	end

	def self.basic_letter?(letter)
		/^[A-Za-z0-9_]$/.match?(letter)
	end

	def self.char_to_hex(char)
		char.ord.to_s(16).upcase.rjust(5, "0")
	end

	def self.hex_to_char(hex)
		hex.to_i(16).chr
	end

	def self.hex_code?(input)
		/^[0-9A-F]{5}$/.match?(input)
	end
end