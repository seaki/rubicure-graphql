module Types
  class SeriesType < Types::BaseObject
    field :series_name, String, null: false
    field :title, String, null: false
    field :started_date, String, null: true
    field :ended_date, String, null: true
    field :girls, [Types::GirlType], null: true
    field :girls_count, Integer, null: false
    field :heisei, String, null: true
    field :reiwa, String, null: true

    def girls
      object.girls
    end

    def girls_count
      object.girls.count
    end

    def heisei
      object.heisei?
    end

    def reiwa
      object.reiwa?
    end
  end
end
