class CSVObject < ApplicationRecord
  require 'csv'
  has_paper_trail
  DEFAULT_HEADERS = [:object_id, :object_type, :timestamp, :object_changes].freeze
  validates_presence_of :object_id, :object_type
  validates_numericality_of :object_id, { only_integer: true, greater_than: 0 }

  def self.import(file)
    headers = nil
    results = []
    File.foreach(file) do |csv_line|
      if headers
        results << parse_csv_line(csv_line, headers)
      else
        if csv_line.match /object_id/
          headers =  CSV.parse(csv_line).first.map(&:to_sym)
        else
          headers = DEFAULT_HEADERS
          results << parse_csv_line(csv_line, headers)
        end
      end
    end
    results
  end

  def version_at(timestamp)
    self.paper_trail.version_at(timestamp)
  end

  private

  def self.parse_csv_line(csv_line, headers)
    # ruby expects double quotes as the quoute escape instead of \"
    row = CSV.parse(csv_line.gsub('\"', '""'), headers: headers).first
    obj = CSVObject.find_or_initialize_by(object_id: row[:object_id], object_type: row[:object_type])
    # update existing object_data where possible
    obj_changes = JSON.parse(row[:object_changes]) if row[:object_changes]
    obj.object_data = obj.object_data ? obj.object_data.merge(obj_changes) : obj_changes
    timestamp = Time.at(row[:timestamp].to_i)
    obj.updated_at = timestamp
    Rails.logger.info("Saving updates to object #{obj.object_type}:#{obj.object_id}")
    obj.save
    obj

  rescue JSON::ParserError
    Rails.logger.error("Failed to parse JSON #{row[:object_changes]} for object #{obj.object_type}:#{obj.object_id}")
    obj.errors.add(:object_data, :parse_failure, message: "Failed to parse #{row[:object_changes]}")
    obj
  end
end
