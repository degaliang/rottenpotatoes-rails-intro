class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      @all_ratings = Movie.all_ratings
      @ratings_to_show = Movie.all_ratings
      
      if params[:filter] == nil && params[:ratings] == nil
        if session[:filter] != nil
          params[:filter] = session[:filter]
        end
  
        if session[:ratings] != nil
          params[:ratings] = session[:ratings]
        end
      end

      if params[:ratings] != nil
        session[:ratings] = params[:ratings]
        temp = Movie.all_ratings
        @ratings_to_show.each do |rating|
          if not params[:ratings].key?(rating)
            temp.delete(rating)
          end
        end
        @ratings_to_show = temp
      end
      @movies = Movie.with_ratings(@ratings_to_show)

      @title_css_class = "hilite"
      @date_css_class = "hilite"
      if params[:filter] != nil
        session[:filter] = params[:filter]
        if params[:filter] == "title"
          @movies = @movies.order(:title)
          @title_css_class = "hilite bg-warning"
        elsif params[:filter] == "date"
          @movies = @movies.order(:release_date)
          @date_css_class = "hilite bg-warning"
        end
      end
      logger.debug "params[:ratings] are #{params[:ratings]}"
      logger.debug "ratings_to_show are #{@ratings_to_show}"
    end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
  end