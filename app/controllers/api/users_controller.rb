class Api::UsersController < ApplicationController
    before_action :authorized_token, only: [:auto_login]
    skip_before_action :verify_authenticity_token

    # REGISTER
    def create
        @user = User.create(user_params)
        if @user.valid?
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else
            render json: {error: "Username atau Password Salah !"}
        end
    end

    # LOGGING IN
    def login
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else
            render json: {error: "Username atau Password Salah !"}
        end
    end


    def auto_login
        render json: @user
    end

    def destroy
        @user = User.find params[:id]
        @user.destroy
        render json: {message: "User telah di hapus !"}
    end

    private
        def user_params
            params.permit(:username, :password)
        end
end
