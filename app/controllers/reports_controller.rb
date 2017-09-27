class ReportsController < ApplicationController

	def index
		@report = Report.new
		render 'new'
	end

	def new
		@report = Report.new
	end

	def create
		@report = Report.new(report_params)
		if @report.save
		else
			render 'new'
		end
	end

	private

		def report_params
			params.require(:report).permit(:title, :body)
		end

end
