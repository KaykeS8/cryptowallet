class WellcomeController < ApplicationController
  def index
    cookies[:curso] = "Curso de Ruby on Rails"
    session[:user_name]=  "kayke"
    @nome = params[:nome]
    @age = params[:age]
  end
end
