class NotesController < LayoutController

  before_action :set_book
  before_action :get_note, only: [ :show, :edit, :update, :destroy ]

  def index
    @notes = @book.notes
  end
  
  def new
    @note = @book.notes.build
  end

  def create
    @note = @book.notes.build(note_params)

    if @note.save
      redirect_to book_notes_path, notice: 'Note was successfully created.'
    else
      render :new
    end
  end

  def show;end

  def edit;end

  def update
    
    if @note.update(note_params)
      redirect_to books_note_path, notice: 'Note was successfully updated.'
    else
      render :edit
    end

  end

  def destroy
    @note.destroy
    redirect_to book_notes_path, notice: 'Note was successfully destroyed.'
  end

  private
    
  def set_book
    @book = current_user.books.find(params[:book_id])
  end
  def get_note
    @note = @book.notes.find(params[:id])
  end
  
  def note_params
    params.require(:note).permit(:name, :content, :book_id)
  end
end
 