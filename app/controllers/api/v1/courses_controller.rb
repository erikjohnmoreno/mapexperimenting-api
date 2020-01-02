class Api::V1::CoursesController < ApplicationController

  def create
    @obj = resource.new(obj_params)
    @obj.user = current_user
    if @obj.save
      render_obj
    else
      render_errors
    end
  end

  private

  def resource
    Course
  end

  def obj_params
    params.require(:resource).permit(:start_lat, :start_lng, :end_lat, :end_lng, :name)
  end

end
