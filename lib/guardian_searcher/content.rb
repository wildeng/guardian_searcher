# frozen_string_literal: true

module GuardianSearcher
  class Content
    include GuardianSearcher::Helpers::Util
    def initialize(attributes)
      attributes.each do |key, attribute_value|
        attr_name = key
        attr_name = snakecase(key) unless key.is_a? Symbol
        self.class.send(:define_method, "#{attr_name}=".to_sym) do |value|
          instance_variable_set("@#{attr_name}", value)
        end

        self.class.send(:define_method, attr_name.to_sym) do
          instance_variable_get("@#{attr_name}")
        end

        send("#{attr_name}=".to_sym, attribute_value)
      end
    end
  end
end
