class AddAwsInfoToReport < ActiveRecord::Migration[5.0]
  def change
    add_column :reports, :key,    :string
    add_column :reports, :bucket, :string
  end
end
