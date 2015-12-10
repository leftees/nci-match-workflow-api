class DrugComboHelper

  def self.exist_in_drug_combo_list(drug_combo_list, target_drug_combo)
    return false if drug_combo_list.nil? || target_drug_combo.nil?
    drug_combo_list.each do |drug_combo|
      return true if does_drug_combo_match(drug_combo, target_drug_combo)
    end
    false
  end

  def self.does_drug_combo_match(drug_combo1, drug_combo2)
    return false if drug_combo1.nil? || drug_combo2.nil?
    return false if drug_combo1['drugs'].size != drug_combo2['drugs'].size
    drug_combo1['drugs'].each do |drug1|
      found = false
      drug_combo2['drugs'].each do |drug2|
        if drug1['drugId'] == drug2['drugId']
          found = true
          break
        end
      end
      return false if !found
    end
    true
  end

end