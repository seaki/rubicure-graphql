module Types
  class MovieType < Types::BaseObject
    field :title, String, null: false, description: "Movie's title"
    field :started_date, String, null: false, description: "Movie's opening day"
    field :name, String, null: false, description: "Movie's symbol"
    field :girls, [Types::GirlType], null: false, description: "Girls apper in the movie"
    def name
      Rubicure::Movie.config.key(object)
    end
    def girls
      return Precure.dream_stars if (name == :dream_stars)
      return Precure.super_stars if (name == :super_stars)
      return Precure.miracle_universe if (name == :miracle_universe)
      Precure.all_stars(Rubicure::Movie.config.key(object))
    end
  end
end
