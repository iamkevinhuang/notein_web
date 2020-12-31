class NotesController < ApplicationController
  before_action :authorized_web
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = Note.where 'user_id = ?', @user.id
  end

  def show
  end


  def new
    @note = Note.new
  end

  def edit
  end

  def create
    @note = Note.new(note_params)
    @note.user_id = @user.id
    if @note.save
      redirect_to @note, notice: 'Catatan berhasil di simpan.'
    else
      render :new 
    end
  end

  def update
    if @note.update(note_params)
      redirect_to @note, notice: 'Catatan berhasil diupdate.' 
    else
      render :edit 
    end
  end

  def destroy
    @note.destroy
    redirect_to notes_url, notice: 'Catatan berhasil di hapus.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])

      unless @note.user_id == @user.id
        redirect_to notes_url, notice: 'Catatan ini bukan milik anda !'
      end
    end

    # Only allow a list of trusted parameters through.
    def note_params
      params.require(:note).permit(:title, :body)
    end
end
