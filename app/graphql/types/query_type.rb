# frozen_string_literal: true

require 'rubicure'

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    field :girl, Types::MemberType, null: false, description: "Get a Precure", deprecation_reason: "Cure Wing is a boy." do
      argument :girl_name, String, required: true, description: "Precure's symbol"
    end
    def girl(girl_name:)
      find_member(girl_name, "girl")
    end

    field :member, Types::MemberType, null: false, description: "Get a Precure" do
      argument :member_name, String, required: true, description: "Precure's symbol"
    end
    def member(member_name:)
      find_member(member_name, "member")
    end

    field :movie, Types::MovieType, null: false, description: "Get information about a movie" do
      argument :movie_name, String, required: true, description: "Movie's symbol"
    end
    def movie(movie_name:)
      Rubicure::Movie.find(movie_key(movie_name))
    end

    field :all_movies, [Types::MovieType], null: false, description: "Get all movies"
    def all_movies
      Rubicure::Movie.uniq_names.map do |name|
        Rubicure::Movie.find(name)
      end
    end

    def self.define_cure(name)
      define_method(name) {
        Rubicure::Girl.find(name)
      }
    end

    Precure.all_girls.map(&:girl_name).each do |girl|
      field girl.intern, Types::MemberType, null: false
      # define method dynamically
      define_cure girl.intern
    end

    field :series, Types::SeriesType, null: false, description: "Get information about series" do
      argument :series_name, String, required: true, description: "Series symbol"
    end
    # Names accepted by `series` besides the ones listed in Rubicure::Series.names
    CURRENT_SERIES_NAMES = %w[now current].freeze

    def series(series_name:)
      return current_series if CURRENT_SERIES_NAMES.include?(series_name)

      Rubicure::Series.find(known_name(Rubicure::Series.names, series_name, "series"))
    end

    field :precure_all_stars, [Types::MemberType], null: false, description: "Get Precure All Stars" do
      argument :series, String, required: false, description: "Prescribe which series from Precure All Stars(if absent, prescribes 'Futari wa Pretty Cure' to 'Maho Girls Precure')"
    end
    def precure_all_stars(series: nil)
      return Precure.all_stars(movie_key(series)) if series.present?
      Precure.all_stars
    end

    field :precure_dream_stars, [Types::MemberType], null: false, description: "Get Precure seen in 'Precure Dream Stars'"
    def precure_dream_stars
      Precure.dream_stars
    end

    field :precure_super_stars, [Types::MemberType], null: false, description: "Get Precure seen in 'Precure Super Stars'"
    def precure_super_stars
      Precure.super_stars
    end

    field :precure_miracle_leap, [Types::MemberType], null: false, description: "Get Precure seen in 'Precure Miracle Leap'"
    def precure_miracle_leap
      Precure.miracle_leap
    end

    field :precure_all_girls, [Types::MemberType], null: false, description: "Get all Precure", deprecation_reason: "Cure Wing is a boy."
    def precure_all_girls
      precure_all
    end

    field :precure_all, [Types::MemberType], null: false, description: "Get all Precure"
    def precure_all
      Precure.all
    end

    field :all_series, [Types::SeriesType], null: false, description: "Get all series"
    def all_series
      Precure
    end

    field :colors, [Types::ColorType], null: false, description: "Get colors and members"
    def colors
      Rubicure::Girl.colors
    end

    field :color, Types::ColorType, null: false, description: "Get color and members specified color" do
      argument :color, String, required: true, description: "Specified color"
    end
    def color(color:)
      known_name(Rubicure::Girl.colors, color, "color")
    end

    field :now, Types::SeriesType, null: false, description: "Get now on air series"
    def now
      current_series
    end

    field :current, Types::SeriesType, null: false, description: "Get now on air series"
    def current
      current_series
    end

    field :version, String, null: false
    def version
      Rails.configuration.x.version
    end

    private

    # Looks a name given by the client up in the names rubicure knows. The argument
    # must never be used as a method name or be turned into a symbol unchecked.
    #
    # @return [Symbol]
    # @raise [GraphQL::ExecutionError] reported to the client in "errors"
    def known_name(names, name, kind)
      names.find { |n| n.to_s == name } || raise(GraphQL::ExecutionError, "unknown #{kind}: #{name}")
    end

    def find_member(name, kind)
      Rubicure::Girl.find(known_name(Rubicure::Girl.names, name, kind))
    end

    def movie_key(name)
      known_name(Rubicure::Movie.names, name, "movie")
    end

    def current_series
      Precure.now
    rescue Rubicure::NotOnAirError => e
      raise GraphQL::ExecutionError, e.message
    end
  end
end
