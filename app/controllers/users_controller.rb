class UsersController < ApplicationController

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @user = User.find(params[:id])
  end

  def show
    @user = User.find(params[:id])
  end


end
