require "rails_helper"

RSpec.describe CSVProcessingJob, :type => :job do
  context 'with a properly formatted file' do
    before do
      file = file_fixture('working_list.csv')
      CSVProcessingJob.perform_now(file)
    end

    it 'imports objects from a well formatted CSV' do
      expect(CSVObject.count).to eq 5
    end

    it 'correctly updates an existing record with new data' do
      test_object = CSVObject.find_by(object_id: 1, object_type: 'Invoice')
      expected_hash = {"order_id" => 7, "product_ids" => [1,5,3], "status" => "paid", "total" => 2500}
      expect(test_object.object_data).to eq expected_hash
    end

    it 'should allow versions to be retrieved by timestamp' do
      test_object = CSVObject.find_by(object_id: 1, object_type: 'Invoice').version_at(Time.at(1484731920))
      expected_hash = {"order_id" => 7, "product_ids" => [1,5,3], "status" => "unpaid", "total" => 2500}
      expect(test_object.object_data).to eq expected_hash
    end
  end

  context 'with a badly formatted file' do
    before do
      file = file_fixture('list_with_errors.csv')
      CSVProcessingJob.perform_now(file)
    end

    it 'should import working rows' do
      expect(CSVObject.count).to eq 6
    end
  end

  context 'with a CSV file with no headers' do
    before do
      file = file_fixture('working_list_no_headers.csv')
      CSVProcessingJob.perform_now(file)
    end

    it 'imports objects from a well formatted CSV' do
      expect(CSVObject.count).to eq 5
    end

    it 'correctly updates an existing record with new data' do
      test_object = CSVObject.find_by(object_id: 1, object_type: 'Invoice')
      expected_hash = {"order_id" => 7, "product_ids" => [1,5,3], "status" => "paid", "total" => 2500}
      expect(test_object.object_data).to eq expected_hash
    end
  end

  context 'with a CSV file with reordered headers' do
    before do
      file = file_fixture('working_list_reordered_headers.csv')
      CSVProcessingJob.perform_now(file)
    end

    it 'imports objects from a well formatted CSV' do
      expect(CSVObject.count).to eq 5
    end

    it 'correctly updates an existing record with new data' do
      test_object = CSVObject.find_by(object_id: 1, object_type: 'Invoice')
      expected_hash = {"order_id" => 7, "product_ids" => [1,5,3], "status" => "paid", "total" => 2500}
      expect(test_object.object_data).to eq expected_hash
    end
  end
end
