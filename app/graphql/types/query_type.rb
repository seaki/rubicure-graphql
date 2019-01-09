require 'rubicure'

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :girl, Types::GirlType, null: false, description: "Get a Precure" do
      argument :girl_name, String, required: true, description: "Precure's symbol"
    end
    def girl(girl_name:)
      Rubicure::Girl.find(girl_name.intern)
    end

    def self.define_cure(name)
      define_method(name) {
        Rubicure::Girl.find(name)
      }
    end

    Precure.all_girls.map(&:girl_name).each do |girl|
      field girl.intern, Types::GirlType, null: false
      # define method dynamically
      define_cure girl.intern

    field :series, Types::SeriesType, null: false, description: "Get information about series" do
      argument :series_name, String, required: true, description: "Series symbol"
    end
    def series(series_name:)
      Rubicure::Series.find(series_name.intern)
    end

    field :precure_all_stars, [Types::GirlType], null: false, description: "Get Precure All Stars" do
      argument :series, String, required: false, description: "Prescribe which series from Precure All Stars(if absent, prescribes 'Futari wa Pretty Cure' to 'Maho Girls Precure')"
    end
    def precure_all_stars(series:)
      return Precure.all_stars(series.intern) if series.present?
      Precure.all_stars
    end

    field :precure_dream_stars, [Types::GirlType], null: false, description: "Get Precure seen in 'Precure Dream Stars'"
    def precure_dream_stars
      Precure.dream_stars
    end

    field :precure_super_stars, [Types::GirlType], null: false, description: "Get Precure seen in 'Precure Super Stars'"
    def precure_super_stars
      Precure.super_stars
    end

    field :precure_all_girls, [Types::GirlType], null: false, description: "Get all Precure"
    def precure_all_girls
      precure_all
    end

    field :precure_all, [Types::GirlType], null: false, description: "Get all Precure"
    def precure_all
      Precure.all
    end

    field :all_series, [Types::SeriesType], null: false, description: "Get all series"
    def all_series
      Precure
    end
  end
end
