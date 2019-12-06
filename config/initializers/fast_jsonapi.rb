module FastJsonapi
  module SerializationCore
    class_methods do

      # Remove type node
      def id_hash(id, record_type, default_return=false)
        { id: id }
      end

      # Merge attributes to parent hash to eliminate attributes node
      def record_hash(record, fieldset, params = {})
        if cached
          record_hash = Rails.cache.fetch(record.cache_key, expires_in: cache_length, race_condition_ttl: race_condition_ttl) do
            temp_hash = id_hash(id_from_record(record), record_type, true)
            temp_hash = temp_hash.merge(attributes_hash(record, fieldset, params)) if attributes_to_serialize.present?
            temp_hash[:relationships] = {}
            temp_hash[:relationships] = relationships_hash(record, cachable_relationships_to_serialize, fieldset, params) if cachable_relationships_to_serialize.present?
            temp_hash[:links] = links_hash(record, params) if data_links.present?
            temp_hash
          end
          record_hash[:relationships] = record_hash[:relationships].merge(relationships_hash(record, uncachable_relationships_to_serialize, fieldset, params)) if uncachable_relationships_to_serialize.present?
          record_hash[:meta] = meta_hash(record, params) if meta_to_serialize.present?
          record_hash
        else
          record_hash = id_hash(id_from_record(record), record_type, true)
          record_hash = record_hash.merge(attributes_hash(record, fieldset, params)) if attributes_to_serialize.present?
          record_hash[:relationships] = relationships_hash(record, nil, fieldset, params) if relationships_to_serialize.present?
          record_hash[:links] = links_hash(record, params) if data_links.present?
          record_hash[:meta] = meta_hash(record, params) if meta_to_serialize.present?
          record_hash
        end
      end
    end
  end

  # treat .belongs_to, .has_one, .has_many as .attribute
  module ObjectSerializer
    class_methods do
      def not_nested
        Proc.new{ |obj, params| !params[:nested] }
      end

      def belongs_to(relationship_name, opts = {}, &block)
        attribute(relationship_name, if: not_nested) do |obj, params|
          _params = (params || {}).merge(nested: true)
          result = obj.send(relationship_name).as_json(opts.merge(params: _params))
          next nil unless result
          next result[:data] if result.is_a?(Hash)
          next result.map{ |r| r[:data] }
        end
      end
      alias_method :has_one, :belongs_to
      alias_method :has_many, :belongs_to
    end
  end

end
