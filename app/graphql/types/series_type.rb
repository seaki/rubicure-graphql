module Types
  class SeriesType < Types::BaseObject
    # Date#heisei?
    using Rubicure::Concerns::Gengou

    field :series_name, String, null: false
    field :title, String, null: false
    field :started_date, String, null: true
    field :ended_date, String, null: true
    field :girls, [Types::MemberType], null: true, deprecation_reason: "Cure Wing is a boy."
    field :girls_count, Integer, null: false, deprecation_reason: "Cure Wing is a boy."
    field :members, [Types::MemberType], null: true
    field :members_count, Integer, null: false
    field :heisei, String, null: true
    field :reiwa, String, null: true

    def girls
      object.girls
    end

    def girls_count
      object.girls.count
    end

    def members
      object.members
    end

    def members_count
      object.members.count
    end

    def heisei
      # A series that is still on air has no ended_date, and Rubicure::Series#heisei?
      # raises NameError for it.
      return object.started_date.heisei? unless object.key?(:ended_date)

      object.heisei?
    end

    def reiwa
      object.reiwa?
    end
  end
end
