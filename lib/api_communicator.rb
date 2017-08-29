require 'rest-client'
require 'json'
require 'pry'



def get_character_movies_from_api(character)
  #make the web request
  all_characters = RestClient.get('http://www.swapi.co/api/people/')


  character_hash = JSON.parse(all_characters)
  while character_hash
    characters_profile = character_hash["results"]
    movies = characters_profile.find do |person|
      person["name"].downcase == character
    end

    if movies
      return movies["films"]
    end

    character_hash = character_hash["next"] ? JSON.parse(RestClient.get(character_hash["next"])) : nil

  end



  # character_hash["results"].each do |character_profile|
  #   if character_profile["name"] == character
  #     character_hash["results"][character_profile]["films"]
  #   end
  #end
  # iterate over the character hash to find the collection of `films` for the given
  #   `character`
  # collect those film API urls, make a web request to each URL to get the info
  #  for that film
  # return value of this method should be collection of info about each film.
  #  i.e. an array of hashes in which each hash reps a given film
  # this collection will be the argument given to `parse_character_movies`
  #  and that method will do some nice presentation stuff: puts out a list
  #  of movies by title. play around with puts out other info about a given film.

end

def parse_character_movies(films_hash)
  # some iteration magic and puts out the movies in a nice list
  all_films = RestClient.get('http://www.swapi.co/api/films/')
  film_array = JSON.parse(all_films)
  film_profiles = film_array["results"]
  film_title = []
  film_profiles.each do |movie|
    if films_hash.include?(movie["url"])
      film_title << movie["title"]

    end
  end
    film_title.each_with_index do |title, index|
      puts "#{index + 1}. #{title}"
    end
end

def show_character_movies(character)
  films_hash = get_character_movies_from_api(character)
  if !films_hash
    puts "Thats not a character, try again!"
  else
    parse_character_movies(films_hash)
  end
end

# get_character_movies_from_api("Luke Skywalker")

# parse_character_movies("sdferdf")
## BONUS

# that `get_character_movies_from_api` method is probably pretty long. Does it do more than one job?
# can you split it up into helper methods?
