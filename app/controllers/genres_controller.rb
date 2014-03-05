#TODO Not used for now, maybe remove in future?
class GenresController < ApplicationController
  before_action :authenticate
  respond_to :html, :json

  def index
    authorize! :read, Genre
    #NOTE: warning: #search method usually used by Search Engines
    @genres = Genre.search(params[:q])
    respond_with @genres do |format|
      format.json { render json: @genres.tokenize }
      format.html
    end
  end

  def show
    genre = Genre.find params[:id]
    @genre = GenrePresenter.new(genre).entry
  end

  def new
    authorize! :manage, Genre
    @genre = Genre.new
  end

  def create
    @genre = Genre.create genre_params
    respond_with @genre
  end

  def edit
    @genre = Genre.find params[:id]
    authorize! :manage, @genre
  end

  def update
    @genre = Genre.find params[:id]
    authorize! :manage, @genre
    @genre.update_attributes genre_params
    respond_with @genre
  end

  def destroy
    @genre = Genre.find params[:id]
    authorize! :manage, @genre
    @genre.destroy
    respond_with @genre
  end

  private

  def genre_params
    params.require(:genre).permit(:title, :description)
  end
end
