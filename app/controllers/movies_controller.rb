class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    @sort = params[:sort]
    @ratings = params[:ratings]
    
    #ratings = @ratings.nil? ? Movie.ratings : @ratings.keys

    if @ratings.nil?
      ratings = Movie.ratings 
    else
      ratings = @ratings.keys
    end

    
    @all_ratings = Movie.ratings.inject({}) do |results, element|
      results[element] = @ratings.nil? ? true : @ratings.has_key?(element)
      results
    end

    if !@sort.nil?
      @movies = Movie.order("#{@sort} ASC").find_all_by_rating(ratings)
    else
      @movies = Movie.find_all_by_rating(ratings)
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

end
