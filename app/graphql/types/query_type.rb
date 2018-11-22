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
  end
end
