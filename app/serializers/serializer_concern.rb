module SerializerConcern
  extend ActiveSupport::Concern

  include FastJsonapi::ObjectSerializer


  class_methods do

    def format_time(time, format='%m/%d/%Y %I:%M%p')
      time.strftime format
    end

  end
end
