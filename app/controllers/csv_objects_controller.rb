class CsvObjectsController < ApplicationController
  require 'tempfile'

  rescue_from ActionController::ParameterMissing, with: :new_error

  def new_error(exception)
    flash[:notice] = 'You must select a file to upload.'
    @object = CSVObject.new
    render :new, status: 200
  end

  def new
    @object = CSVObject.new
  end

  def create
    input_csv = permited_params[:csv]
    @results = CSVObject.import(input_csv.path)
    render :results
  end

  def index
    object = CSVObject.find_by(object_id: params[:object_id], object_type: params[:object_type])
    if(params[:timestamp])
      object = object.version_at(Time.at(params[:timestamp].to_i))
    end
    render json: object || {}
  end

  private

  def permited_params
    params.require(:csv_object).permit(:csv)
  end
end
