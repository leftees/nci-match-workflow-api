require "#{File.dirname(__FILE__)}/../scripts/PatientRejoinMatchboxScanner/lib/data_element_locator"

# Test the DataElementLocator get_latest_biopsy method

RSpec.describe DataElementLocator, '.get_latest_biopsy' do
  context 'with a nil value' do
    it 'should return a nil value' do
      expect(DataElementLocator.get_latest_biopsy(nil)).to be_nil
    end
  end

  context 'with a empty array' do
    it 'should return a nil value' do
      expect(DataElementLocator.get_latest_biopsy([])).to be_nil
    end
  end

  context 'with an array of one biopsy' do
    it 'should return the biopsy' do
      biopsies = [{'biopsySequenceNumber' => 'N-15-00005'}]
      latest_biopsy = DataElementLocator.get_latest_biopsy(biopsies)
      expect(latest_biopsy['biopsySequenceNumber']).to eq('N-15-00005')
    end
  end

  context 'with an array of two biopies' do
    it 'should return the latest biopsy' do
      biopsies = [{'biopsySequenceNumber' => 'N-15-00005'},{'biopsySequenceNumber' => 'N-15-00006'}]
      latest_biopsy = DataElementLocator.get_latest_biopsy(biopsies)
      expect(latest_biopsy['biopsySequenceNumber']).to eq('N-15-00006')
    end
  end
end

# Test the DataElementLocator get_latest_next_generation_sequence method

RSpec.describe DataElementLocator, '.get_latest_next_generation_sequence' do
  context 'with a nil value' do
    it 'should return a nil value' do
      expect(DataElementLocator.get_latest_next_generation_sequence(nil)).to be_nil
    end
  end

  context 'with a empty array' do
    it 'should return a nil value' do
      expect(DataElementLocator.get_latest_next_generation_sequence([])).to be_nil
    end
  end

  context 'with an array of one next generation sequence' do
    it 'should return the next generation sequence' do
      next_generation_sequences = [{'ionReporterResults' => { 'jobName' => 'testjob1' }}]
      latest_next_generation_sequence = DataElementLocator.get_latest_next_generation_sequence(next_generation_sequences)
      expect(latest_next_generation_sequence['ionReporterResults']['jobName']).to eq('testjob1')
    end
  end

  context 'with an array of two next generation sequences' do
    it 'should return the latest next generation sequence' do
      next_generation_sequences = [{'ionReporterResults' => { 'jobName' => 'testjob1' }},{'ionReporterResults' => { 'jobName' => 'testjob2' }}]
      latest_next_generation_sequence = DataElementLocator.get_latest_next_generation_sequence(next_generation_sequences)
      expect(latest_next_generation_sequence['ionReporterResults']['jobName']).to eq('testjob2')
    end
  end
end

# Test the DataElementLocator get_confirmed_variant_report_analysis_id method

RSpec.describe DataElementLocator, '.get_confirmed_variant_report_analysis_id' do
  context 'with a nil value' do
    it 'should return a nil value' do
      expect(DataElementLocator.get_confirmed_variant_report_analysis_id(nil)).to be_nil
    end
  end

  context 'with a CONFIRMED next generation sequence' do
    it 'should return the analysis id' do
      next_generation_sequence = {'ionReporterResults' => { 'jobName' => 'testjob1' }, 'status' => 'CONFIRMED'}
      analysis_id = DataElementLocator.get_confirmed_variant_report_analysis_id(next_generation_sequence)
      expect(analysis_id).to eq('testjob1')
    end
  end

  context 'with a PENDING next generation sequence' do
    it 'should return a nil value' do
      next_generation_sequence = {'ionReporterResults' => { 'jobName' => 'testjob1' }, 'status' => 'PENDING'}
      analysis_id = DataElementLocator.get_confirmed_variant_report_analysis_id(next_generation_sequence)
      expect(analysis_id).to be_nil
    end
  end

  context 'with a REJECTED next generation sequence' do
    it 'should return a nil value' do
      next_generation_sequence = {'ionReporterResults' => { 'jobName' => 'testjob1' }, 'status' => 'REJECTED'}
      analysis_id = DataElementLocator.get_confirmed_variant_report_analysis_id(next_generation_sequence)
      expect(analysis_id).to be_nil
    end
  end
end