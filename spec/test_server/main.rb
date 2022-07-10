require "sinatra"

not_found do
  erb :not_found
end

get "/example/html" do
  @first_name = params[:first_name]
  @last_name = params[:last_name]
  erb :html_index
end