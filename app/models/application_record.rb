class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.by_limit page, per_page
    limit(per_page.to_i).offset(per_page.to_i * (page.to_i - 1))
  end

  def self.serializer
    @serializer ||=
      begin
        default_serializer = "#{self.name}Serializer"

        if Object.const_defined?(default_serializer) or
            File.exists? File.join('app', 'serializers', "#{default_serializer.underscore}.rb")
          default_serializer.constantize
        end
      end
  end

  def as_json opts={}
    serializer = opts[:serializer].presence || self.class.serializer

    if serializer
      serializer.new(self, opts).serializable_hash
    else
      super(opts)
    end
  end
end
