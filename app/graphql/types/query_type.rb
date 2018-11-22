require 'rubicure'

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :girl, Types::GirlType, null: false do
      argument :girl_name, String, required: true
    end
    def girl(girl_name:)
      Rubicure::Girl.find(girl_name.intern)
    end

    field :precure_all_stars, [Types::GirlType], null: false do
      argument :series, String, required: false
    end
    def precure_all_stars(series:)
      return Precure.all_stars(series.intern) if series.present?
      Precure.all_stars
    end

    field :precure_dream_stars, [Types::GirlType], null: false
    def precure_dream_stars
      Precure.dream_stars
    end

    field :precure_super_stars, [Types::GirlType], null: false
    def precure_super_stars
      Precure.super_stars
    end

    field :precure_all_girls, [Types::GirlType], null: false
    def precure_all_girls
      precure_all
    end

    field :precure_all, [Types::GirlType], null: false
    def precure_all
      Precure.all
    end
  end
end
