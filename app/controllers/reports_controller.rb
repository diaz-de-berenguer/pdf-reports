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
			redirect_to @report.temp_url
		else
			render 'new'
		end
	end

	# Used to preview PDF
	def show
		@report       = Report.new
		@report.title = "Example PDF report"
		@report.body  = "###Some very important data\n\nLorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.\n\nDonec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu.\n\nIn enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a,"

		respond_to do |f|
			f.pdf do
				render pdf: "Report"
			end
		end

	end

	private

		def report_params
			params.require(:report).permit(:title, :body)
		end

end
