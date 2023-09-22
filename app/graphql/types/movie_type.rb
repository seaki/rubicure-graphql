module Types
  class MovieType < Types::BaseObject
    field :title, String, null: false, description: "Movie's title"
    field :started_date, String, null: false, description: "Movie's opening day"
    field :name, String, null: false, description: "Movie's symbol"
    field :girls, [Types::MemberType], null: false, description: "Girls apper in the movie", deprecation_reason: "Cure Wing is a boy."
    field :members, [Types::MemberType], null: false, description: "Members apper in the movie"

    def name
      Rubicure::Movie.config.key(object)
    end

    def members
      return Precure.dream_stars if (name == :dream_stars)
      return Precure.super_stars if (name == :super_stars)
      return Precure.miracle_universe if (name == :miracle_universe)
      return Precure.miracle_leap if (name == :miracle_leap)
      Precure.all_stars(Rubicure::Movie.config.key(object))
    end

    alias_method :girls, :members
  end
end
