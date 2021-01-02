class Api::UsersController < ApplicationController
    before_action :authorized_token, only: [:auto_login, :update, :destroy]
    skip_before_action :verify_authenticity_token

    # REGISTER
    def create
        @user = User.create(user_params)
        if @user.valid?
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else
            error_string = ""
            if @user.errors
                @user.errors.full_messages.each do |msg|
                    error_string += "#{msg}, "
                end
                error_string = error_string[0..-3]
            else
                error_string = "Terjadi Kesalahan sistem, silahkan ulangi beberapa saat lagi !"
            end
            render json: {error: error_string}, status: :unprocessable_entity
        end
    end

    # LOGGING IN
    def login
        @user = User.find_by(username: params[:username])

        if @user && @user.authenticate(params[:password])
            token = encode_token({user_id: @user.id})
            render json: {user: @user, token: token}
        else
            render json: {error: "Username atau Password Salah !"}, status: :unprocessable_entity
        end
    end

    def update
        if @user.update(user_params)
            render json: @user
        else
            error_string = ""
            if @user.errors
                @user.errors.full_messages.each do |msg|
                    error_string += "#{msg}, "
                end
                error_string = error_string[0..-3]
            else
                error_string = "Terjadi Kesalahan sistem, silahkan ulangi beberapa saat lagi !"
            end

            render json: {error: error_string}, status: :unprocessable_entity
        end
    end 


    def auto_login
        render json: @user
    end

    def destroy
        @user.destroy
        render json: {message: "User telah di hapus !"}
    end

    private
        def user_params
            params.permit(:username, :password, :password_confirmation)
        end
end
