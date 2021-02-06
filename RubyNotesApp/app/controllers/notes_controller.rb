class NotesController < LayoutController
  
  before_action :set_book

  def index
    @notes = @book.notes
  end
  
  def new
    @book = current_user.books.build
  end

  def create
    @book = current_user.books.build(book_params)

    if @book.save
      redirect_to books_path, notice: 'Post was successfully created.'
    else
      render :new
    end
  end

  def edit;end

  def update
    
    if @book.update(book_params)
      redirect_to books_path, notice: 'Post was successfully updated.'
    else
      render :edit
    end

  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: 'Book was successfully destroyed.'
  end

  private
    
  def set_book
    @book = current_user.books.find(params[:id])
  end
  
  def book_params
    params.require(:book).permit(:name, :global, :user_id)
  end
end
 