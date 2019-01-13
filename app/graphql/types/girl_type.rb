module Types
  class GirlType < Types::BaseObject
    field :girl_name, String, null: false, description: "Precure's symbol name"
    field :human_name, String, null: false, description: "Precure's name before transformation"
    field :human_full_name, String, null: true, description: "Precure's canonical name before transformation"
    field :precure_name, String, null: false, description: "Precure's name after transformation"
    field :cast_name, String, null: true, description: "Precure's character voice actor/actoress name"
    field :color, String, null: true, description: "Precure's color"
    field :created_date, String, null: true, description: "First seen on TV/theaters"
    field :birthday, String, null: true, description: "Precure's birthday(if present)"
    field :transform_message, String, null: true, description: "Precure's transform message(if present)", deprecation_reason: "Doesn't work properly with girls from Maho girls Precure"
    field :transform_messages, [Types::TransformMessageType], null: true, description: "Precure's transform message(if present)"
    field :extra_names, [String], null: true, description: "Precure's names after special transformation"
    field :attack_messages, [Types::AttackMessageType], null: true, description: "Precure's message when attack"
    field :transform_calls, [String], null: true, description: "Precure's transformation call"
    field :full_name, String, null: false, description: "Precure's name before transformation(full name or human name)"
    field :transform_styles, [String], null: true, description: "Transform styles(if present)"

    def girl_name
      object.girl_name
    end

    def human_name
      object.human_name
    end

    def human_full_name
      object.human_full_name
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

    def transform_messages
      begin
        object.transform_styles
      rescue => e
        return [["default", object]]
      end
    end

    def extra_names
      return object.extra_names if object.extra_names.is_a?(Array)
    end

    def attack_messages
      begin
        object.transform_styles
      rescue => e
        return [["default", object]]
      end
    end

    def transform_calls
      return object.transform_calls if object.transform_calls.is_a?(Array)
    end

    def full_name
      object.full_name
    end

    def transform_styles
      begin
        object.transform_styles.map {|s| s.first}
      rescue => e
        return nil
      end
    end
  end
end
