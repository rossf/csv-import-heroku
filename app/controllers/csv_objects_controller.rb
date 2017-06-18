class CsvObjectsController < ApplicationController
  require 'tempfile'

  def new
    @object = CSVObject.new
  end

  def create
    input_csv = permited_params[:csv]
    @results = CSVObject.import(input_csv.path)
    render :results
  end

  def index
  end

  private

  def permited_params
    params.require(:csv_object).permit(:csv)
  end
end
