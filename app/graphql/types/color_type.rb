module Types
  class ColorType < Types::BaseObject
    field :color, String, null: false
    field :girls, [Types::MemberType], null: true, deprecation_reason: "Cure Wing is a boy."
    field :members, [Types::MemberType], null: true
    def color
      object.to_s
    end
    def girls
      Precure.all_girls.select{|girl| girl.send(object.to_s + '?')}
    end
    def members
      Precure.all_members.select{|member| member.send(object.to_s + '?')}
    end
  end
end
