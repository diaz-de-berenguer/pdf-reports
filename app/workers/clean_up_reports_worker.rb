class CleanUpReportsWorker
  include Sidekiq::Worker

  def perform(report_id)
  	@report = Report.find(report_id)
  	if @report.remove_from_aws
  		true
  	else
  		raise "Something went wrogn, unable to remove Report id: #{report_id} from S3!"
  	end
  end
end
