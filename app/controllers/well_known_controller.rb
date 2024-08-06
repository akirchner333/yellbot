class WellKnownController < ApplicationController
	include ActivityPubHelper

	def webfinger
		if acct = params[:resource].match(/acct:(.*)@#{ENV['URL']}/)
			handle = acct[1]
			if handle && LetterHandler.get_letter(handle)
				render :json => {
					subject: "acct:#{handle}@#{ENV['URL']}",
					links: [
						{
							rel: "self",
							type: "application/activity+json",
							href: "#{full_url}/letters/#{handle}"
						},{
							rel: "http://webfinger.net/rel/profile-page",
							type: "text/html",
							href: "#{full_url}"
						}
					]
				} and return
			end
		end

		render plain: '', status: 400
	end
end
