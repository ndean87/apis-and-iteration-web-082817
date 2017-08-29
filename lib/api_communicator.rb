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
