class Report < ApplicationRecord
	validates_presence_of :title, :body
	validate :upload_to_s3_and_validate_response, :on => :create
	validates_presence_of :key, :bucket

	def temp_url
		bucket = Aws::S3::Bucket.new(self.bucket)
		object = bucket.object(self.key)
		return object.presigned_url(:get, expires_in: 3600)
	end

	def upload_to_s3
	  # Set Buket and Key
	  filename    = "#{self.id}-#{Time.now.strftime('%Y%m%d%H%M%S')}.pdf"
	  self.key    = "pdf/#{filename}"
	  self.bucket = bucket_name

	  # Get path for generated PDF. This is performed by the :create_pdf_path method.
	  pdf_path    = create_pdf_path

	  # Open temp file
	  pdf         = File.open(pdf_path)

	  # Upload to AWS
	  s3          = Aws::S3::Client.new
	  response    = s3.put_object(
	    bucket: self.bucket,
	    key:    self.key,
	    body:   pdf
	  )

	  # Remove Temp file after upload
	  File.delete(pdf_path) if File.exist?(pdf_path)

	  return response
	end

	def create_pdf_path
	  # use wicked_pdf gem to create a PDF from an html template.
	  doc_pdf = WickedPdf.new.pdf_from_string(
	    ActionController::Base.new().render_to_string(
	      template: "reports/show",
	      locals:   { report: self }
	    ),
	    pdf:         "Report",
	    page_size:   "Letter",
	    margin: { top:    "0.5in",
	              bottom: "0.5in",
	              left:   "0.5in",
	              right:  "0.5in" },
	    disposition: "attachment"
	  )

	  pdf_path = Rails.root.join("tmp", "temp_pdf_file_#{self.id}_#{Date.today.iso8601}.pdf")
	  File.open(pdf_path, "wb") do |file|
	    file << doc_pdf
	  end

	  # Returns the path of the temporary PDF file. eg: "/tmp/temp_pdf_file_132_2017-12-12.pdf"
	  return pdf_path
	end

	def bucket_name
	  return ENV['BUCKET_NAME']
	end

	private

		def upload_to_s3_and_validate_response
		  response = self.upload_to_s3
		  self.errors.add :base, "unable upload PDF" if response.error.present?
		end
end
