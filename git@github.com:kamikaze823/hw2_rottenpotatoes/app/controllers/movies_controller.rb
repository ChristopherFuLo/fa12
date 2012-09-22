class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @title = false
    @date = false
    @all_ratings = Movie.allRatings
    @current_checked = []
    current = params["ratings"]
    if current == nil
	@movies = Movie.all
    else
      @current_checked = params["ratings"].keys
      @movies = []
      @current_checked.each do |check|
    	@movies += Movie.where("rating = '#{check}'").to_a
      end
    end
    titleHash = {}
    dateHash = {}
    titleArr = []
    dateArr = []
    @movies.each do |x|
	titleHash[x.title] = x
	dateHash[x.release_date] = x
	titleArr << x.title
	dateArr << x.release_date
    end
    if params["title"]
      @title = true
      titleArr.sort!
      @movies = []
      titleArr.each do |title|
	@movies << titleHash[title]
      end
    end
    if params["date"]
      @date = true
      dateArr.sort!
      @movies = []
      dateArr.each do |date|
         @movies << dateHash[date]
      end
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def titlesort
    @titlesortmovies = Movie.order(:title).all
  end

  def datesort
    @datesortmovies = Movie.order(:release_date).all
  end
end
