module Types
  class GirlType < Types::BaseObject
    field :girl_name, String, null: false, description: "Precure's symbol name"
    field :human_name, String, null: false, description: "Precure's name before transformation"
    field :human_full_name, String, null: true, description: "Precure's canonical name before transformation"
    field :human_turnover_name, String, null: true, description: "Precure's turnovered name"
    field :precure_name, String, null: false, description: "Precure's name after transformation"
    field :cast_name, String, null: true, description: "Precure's character voice actor/actoress name"
    field :color, String, null: true, description: "Precure's color"
    field :created_date, String, null: true, description: "First seen on TV/theaters"
    field :birthday, String, null: true, description: "Precure's birthday(if present)"
    field :transform_message, String, null: true, description: "Precure's transform message"
    field :extra_names, [String], null: true, description: "Precure's names after special transformation"
    field :attack_messages, [String], null: true, description: "Precure's message when attack"
    field :transform_calls, [String], null: true, description: "Precure's transformation call"
    field :full_name, String, null: false, description: "Precure's name before transformation(full name or human name)"
    field :transform_styles, [String], null: true

    def girl_name
      object.girl_name
    end

    def human_name
      object.human_name
    end

    def human_full_name
      object.human_full_name
    end

    def human_turnover_name
      # コードに直で書かれているので、こっちも直で書いてやるｩｩｩ
      return "イース" if object.girl_name == "cure_passion"
      return "セイレーン" if object.girl_name == "cure_beat"
      return "トワイライト" if object.girl_name == "cure_scarlet"
      human_name
    end

    def precure_name
      object.precure_name
    end

    def cast_name
      object.cast_name
    end

    def color
      object.color
    end

    def created_date
      "#{object.created_date}"
    end

    def birthday
      object.birthday
    end

    def transform_message
      object.transform_message # まほプリのときは定義されていないのでnilが帰る、transform_stylesにスタイル指定しろとするか
    end

    def extra_names
      return object.extra_names if object.extra_names.is_a?(Array)
    end

    def attack_messages
      return object.attack_messages if object.attack_messages.is_a?(Array)
    end

    def transform_calls
      return object.transform_calls if object.transform_calls.is_a?(Array)
    end

    def full_name
      object.full_name
    end

    def transform_styles
      object.transform_styles if object.method_defined?(:transform_styles)
    end
  end
end
