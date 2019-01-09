module Types
  class MovieType < Types::BaseObject
    field :title, String, null: false, description: "Movie's title"
    field :started_date, String, null: false, description: "Movie's opening day"
    field :name, String, null: false, description: "Movie's symbol"
    def name
      Rubicure::Movie.config.key(object)
    end
  end
end
