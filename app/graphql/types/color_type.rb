module Types
  class ColorType < Types::BaseObject
    field :color, String, null: false
    field :girls, [Types::GirlType], null: true
    def color
      object.to_s
    end
    def girls
      Precure.all_girls.select{|girl| girl.send(object.to_s + '?')}
    end
  end
end
