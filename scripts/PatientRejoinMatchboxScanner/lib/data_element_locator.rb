class DataElementLocator
  def self.get_latest_biopsy(biopsies)
    return biopsies[biopsies.size() - 1] if !biopsies.nil? && biopsies.size() > 0
  end

  def self.get_latest_next_generation_sequence(next_generation_sequences)
    return next_generation_sequences[next_generation_sequences.size() - 1] if !next_generation_sequences.nil? && next_generation_sequences.size() > 0
  end

  def self.get_confirmed_variant_report_analysis_id(next_generation_sequence)
    return next_generation_sequence['ionReporterResults']['jobName'] if !next_generation_sequence.nil? && next_generation_sequence['status'] == 'CONFIRMED' && next_generation_sequence['ionReporterResults']['jobName']
  end
end