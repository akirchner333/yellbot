class WellKnownController < ApplicationController
	include ActivityPubHelper

	def webfinger
		if acct = params[:resource].match(/acct:(.)@#{ENV['URL']}/)
			letter = acct[1]
			render :json => {
				subject: "acct:#{letter}@#{ENV['URL']}",
				links: [
					{
						rel: "self",
						type: "application/activity+json",
						href: "#{full_url}/letters/#{letter}"
					},{
						rel: "http://webfinger.net/rel/profile-page",
						type: "text/html",
						href: "#{full_url}"
					}
				]
			} and return
		end

		render plain: '', status: 400
	end
end
