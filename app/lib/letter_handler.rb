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
		char.ord.to_s(16).upcase.rjust(2, "0")
	end

	def self.hex_to_char(hex)
		hex.to_i(16).chr
	end

	def self.hex_code?(input)
		return false if !/^[0-9A-Fa-f]{1,6}$/.match?(input)

		input.to_i(16) < 1114112
	end
end