class Movie < ActiveRecord::Base
  def self.all_ratings()
    return ['G','PG','PG-13','R']
  end

  def self.with_ratings(ratings_list)
    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
    #  movies with those ratings
    # if ratings_list is nil, retrieve ALL movies
    if ratings_list == nil
      return Movie.all
    else
      ratings_list += ratings_list.map(&:downcase)
      return Movie.where(rating: ratings_list)
    end
  end
end