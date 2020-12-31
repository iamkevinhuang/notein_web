class UsersController < ApplicationController
  before_action :authorized_web, only: [:show, :edit, :update, :destroy, :logout]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token


  def login
    @user = User.find_by_username params[:username]
    if @user and @user.authenticate params[:password]
      @token = encode_token({user_id: @user.id})
      session[:user_id] = @user.id
      redirect_to user_path(@user), notice: "Anda berhasil Login"
    else
      redirect_to login_form_users_path, notice: "Username atau Password salah !"
    end
  end

  def login_form
    @user = User.new
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      token = encode_token({user_id: @user.id})
      session[:user_id] = @user.id
      redirect_to @user, notice: 'Akun anda telah berhasil di daftarkan !'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: 'Akun anda telah diperbaharui.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'Akun anda telah dihapus.'
  end

  def logout
    session[:user_id] = nil
    redirect_to login_form_users_path, notice: 'Anda berhasil keluar.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(session[:user_id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :password_confirmation)
    end
end
