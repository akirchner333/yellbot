namespace :make_posts do
	desc 'Makes posts for every letter that has followers'
	task go: :environment do
		Follow.distinct.pluck(:letter).each do |letter|
			Note.generate(letter)
		end
	end
end