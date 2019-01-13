module Types
  class TransformMessageType < Types::BaseObject
    field :transform_style, String, null: true
    field :transform_message, String, null: true
    def transform_style
      object.first
    end
    def transform_message
      object.last[:transform_message]
    end
  end
end
