module Types
  class SeriesType < Types::BaseObject
    field :series_name, String, null: false
    field :title, String, null: false
    field :started_date, String, null: true
    field :girls, [Types::GirlType], null: true
    field :girls_count, Integer, null: false

    def girls
      object.girls
    end

    def girls_count
      object.girls.count
    end
  end
end
