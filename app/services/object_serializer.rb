# frozen_string_literal: true

class ObjectSerializer
  module ClassMethods
    def serialize(obj)
      object_to_hash(obj)
    end

    def serialize_each(objs_array)
      objs_array.map { |obj| object_to_hash(obj) }
    end

    private

    def object_to_hash(obj)
      hash_representation = {}
      obj.instance_variables.each do |var|
        hash_representation[var.to_s.delete('@')] = obj.instance_variable_get(var)
      end
      hash_representation
    end
  end
  extend ClassMethods
end
