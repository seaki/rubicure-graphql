module Types
  class TransformMessageType < Types::BaseObject
    field :transform_style, String, null: true
    field :transform_message, String, null: true
    def transform_style
      object.first
    end
    def transform_message
      if object.last[:random_transform_words] && !object.last[:random_transform_words].empty?
        random_transform_word = object.last[:random_transform_words].sample
        object.last[:transform_message].gsub("${random_transform_word}", random_transform_word)
      else
        object.last[:transform_message]
      end
    end
  end
end
