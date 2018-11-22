module Types
  class GirlType < Types::BaseObject
    field :girl_name, String, null: false
    def girl_name
      "#{object.girl_name}"
    end
    field :human_name, String, null: false
    def human_name
      "#{object.human_name}"
    end
  end
end
