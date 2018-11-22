require 'rubicure'

module Types
  class QueryType < Types::BaseObject
    # Add root-level fields here.
    # They will be entry points for queries on your schema.

    # TODO: remove me
    field :test_field, String, null: false,
      description: "An example field added by the generator"
    def test_field
      Rails.logger.info context[:time]
      "Hello World!"
    end

    field :human_name, String, null: false do
      argument :girl_name, String, required: true
    end
    def human_name(girl_name:)
      "#{Rubicure::Girl.find(girl_name.intern).human_name}"
    end
  end
end
