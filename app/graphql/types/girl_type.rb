module Types
  class GirlType < Types::BaseObject
    field :girl_name, String, null: false
    field :human_name, String, null: false
    field :human_full_name, String, null: false
    field :precure_name, String, null: false
    field :cast_name, String, null: true
    field :color, String, null: true
    field :created_date, String, null: true
    field :birthday, String, null: true
    field :transform_message, String, null: true
    field :extra_names, String, null: true
    field :attack_messages, String, null: true
    field :transform_calls, String, null: true
    field :full_name, String, null: false

    def girl_name
      "#{object.girl_name}"
    end

    def human_name
      "#{object.human_name}"
    end

    def human_full_name
      "#{object.human_full_name}"
    end

    def precure_name
      "#{object.precure_name}"
    end

    def cast_name
      "#{object.cast_name}"
    end

    def color
      "#{object.color}"
    end

    def created_date
      "#{object.created_date}"
    end

    def birthday
      "#{object.birthday}"
    end

    def transform_message
      "#{object.transform_message}"
    end

    def extra_names
      "#{object.extra_names}"
    end

    def attack_messages
      "#{object.attack_messages}"
    end

    def transform_calls
      "#{object.transform_calls}"
    end

    def full_name
      "#{object.full_name}"
    end
  end
end
