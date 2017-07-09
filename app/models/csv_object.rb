class CSVObject < ApplicationRecord
  require 'csv'
  has_paper_trail
  
  validates_presence_of :object_id, :object_type
  validates_numericality_of :object_id, { only_integer: true, greater_than: 0 }

  def version_at(timestamp)
    self.paper_trail.version_at(timestamp)
  rescue ActiveRecord::StatementInvalid
    {}
  end
end
