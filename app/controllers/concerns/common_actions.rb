module CommonActions
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do
      render_not_found
    end
  end


  def index
    page = params.fetch(:page, 1)
    per_page = params.fetch(:per_page, 20)

    result = filtered_collection.by_limit(page, per_page)

    options = {
      meta: {total_count: filtered_collection.count, current_page: page}
    }.merge(serializer_options)

    render json: serializer ? serializer.new(result, options) : result
  end

  def create
    @obj = resource.new(obj_params)
    if @obj.save
      render_obj
    else
      render_errors
    end
  end

  def show
    render_obj
  end

  def update
    if obj.update(obj_params)
      render_obj
    else
      render_errors
    end
  end

  def destroy
    if obj.destroy
      head :no_content
    else
      render_errors
    end
  end

  protected


  def render_obj _obj=obj, opts=serializer_options
    render json: serializer ? serializer.new(_obj, opts) : _obj
  end

  def render_errors _obj=obj
    render json: { errors: [_obj.errors.messages] }, status: 422
  end

  def render_not_found
    render json: { error: 'Not found' }, status: 404
  end


  def obj
    @obj ||= collection.find(params[:id])
  end

  def resource
    @resource ||=
      begin
        resource_name = params[:controller].split('/').last.singularize.capitalize
        if Object.const_defined?(resource_name) or
            File.exists? File.join('app', 'models', "#{resource_name.underscore}.rb")
          resource_name.constantize
        end
      end
  end

  def serializer
    @serializer ||= resource.serializer
  end

  def serializer_options
    @serializer_options ||= {}
  end

  def collection
    @collection ||= resource.all
  end

  def filtered_collection
     @filtered_collection ||= collection.ransack(params[:q]).result
  end
end
