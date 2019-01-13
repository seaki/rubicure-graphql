module Types
  class AttackMessageType < Types::BaseObject
    field :transform_style, String, null: true
    field :attack_messages, [String], null: true
    def transform_style
      object.first
    end
    def attack_messages
      object.last[:attack_messages]
    end
  end
end
