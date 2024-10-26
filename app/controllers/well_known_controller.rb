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

	def nodeinfo
		render :json => {links: [
			{
				rel: "http://nodeinfo.diaspora.software/ns/schema/2.1",
				href: "#{full_url}/nodeinfo/2.1"
			},
			{
				rel: "http://nodeinfo.diaspora.software/ns/schema/2.0",
				href: "#{full_url}/nodeinfo/2.0"
			}
		]}
	end

	def hostmeta
		xml = <<~XML
		<XRD>
			<Link rel="lrdd" template="#{full_url}/.well-known/webfinger?resource={uri}" />
		</XRD>
		XML

		render content_type: "application/xrd+xml", xml: xml
	end
end
