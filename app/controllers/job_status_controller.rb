class JobStatusController < ApplicationController
  def show
    @job = JobStatus.find_by(active_job_id: params[:id])
    render json: @job
  end
end
