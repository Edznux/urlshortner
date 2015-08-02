class UrlController < ApplicationController
	def index
		@topLinks = Url.order("views DESC").limit(10)
	end

	def new
		render plain: "ok"
	end
	
	def create
		#making random uppercase string
		h = (0...8).map { (65 + rand(26)).chr }.join

		#check if not present else, redraw
		#pre-handling duplicate entrie in db
		while Url.where(hash_string:h).first
			h = (0...8).map { (65 + rand(26)).chr }.join	
		end

		#check if not already created this link before an hour, else redirecting to the last one
		alreadyCreated = Url.where("link_to = ? AND created_at < DATE_SUB(NOW() , INTERVAL 1 HOUR)",params[:link_to]).first

		if alreadyCreated
			url = alreadyCreated
		else
			url = Url.new(hash_string:h,link_to:params[:link_to])
			puts "link_to not found in last hour, creating"
			url.save()
		end

		render json: url
	end

	def show
		j = Url.where(hash_string:params[:hash_string]).first
		if j[:views]
			j[:views] += 1
		else
			j[:views] = 1
		end

		j.save() 
		if j.link_to =~ /^https?/
			redirect_to j.link_to
		else
			redirect_to "http://"+j.link_to
		end
	end
end
