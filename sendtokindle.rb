require 'sinatra'
require 'pony'
require 'open-uri'

def send_email(url, email)
	open(url) do |f|
		filename = "file.pdf"#f.path

		Pony.mail(:to => email, 
		:from => 'Send To Kindle',
		:subject => 'Convert',
		:attachments => {filename => f.read},
		:via => :smtp, :via_options => {
			:address              => 'smtp.gmail.com',
			:port                 => '587',
			:enable_starttls_auto => true,
			:user_name            => 'example@example.com',
			:password             => 'password',
			:authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
			:domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
		})
	end
end

get '/' do

	erb :index
end

get '/send' do
	@url = params[:url]
	@email = params[:email]

	@email = @email.chomp + '@free.kindle.com' unless @email=~/@/
	
	send_email(@url, @email)

	erb :send
end
