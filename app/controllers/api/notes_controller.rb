class Api::NotesController < ApplicationController
    before_action :set_note, only: [:show, :update, :destroy]
    before_action :authorized_token
    skip_before_action :verify_authenticity_token

    def index
        @notes = Note.where 'user_id = ?', @user.id
        render json: @notes
    end

    def show
        render json: @note
    end

    def create
        @note = Note.new(note_params)

        if @note.save
            render json: @note, status: :created, location: @note
        else
            error_string = ""
            if @note.errors
                @note.errors.full_messages.each do |msg|
                    error_string += "#{msg}, "
                end
                error_string = error_string[0..-3]
            else
                error_string = "Terjadi Kesalahan sistem, silahkan ulangi beberapa saat lagi !"
            end
            render json: {error: error_string}, status: :unprocessable_entity
        end
    end

    def update
        if @note.update(note_params)
            render json: @note
        else
            error_string = ""
            if @note.errors
                @note.errors.full_messages.each do |msg|
                    error_string += "#{msg}, "
                end
                error_string = error_string[0..-3]
            else
                error_string = "Terjadi Kesalahan sistem, silahkan ulangi beberapa saat lagi !"
            end
            render json: {error: error_string}, status: :unprocessable_entity
        end
    end


    def destroy
        @note.destroy
    end

    private
    # Use callbacks to share common setup or constraints between actions.
        def set_note
            @note = Note.find(params[:id])

            unless @note.user_id == @user.id
                render json: {error: "Catatan ini bukan milik anda !"}, status: :unprocessable_entity
            end
        end

        # Only allow a trusted parameter "white list" through.
        def note_params
            params.require(:note).permit(:body, :title)
        end
end
