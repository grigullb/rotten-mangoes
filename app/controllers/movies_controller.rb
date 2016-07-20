class MoviesController < ApplicationController
  def index
    @movies = Movie.all
    if params[:search_term] && !params[:search_term].empty?
        @movies = @movies.title(params[:search_term])
    else
      @movies
    end

    if params[:duration] && !params[:duration].empty?
      if params[:duration] == 'under 90'
        @movies = @movies.less_than_90
      end
      if params[:duration] == 'Over 120'
        @movies = @movies.greater_than_120
      end
       if params[:duration] == 'Between 90 and 120'
        @movies = @movies.between_90_120
      end
    else
      @movies
    end

  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :description, :image
    )
  end

end