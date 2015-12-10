require "#{File.dirname(__FILE__)}/../../../app/util/drug_combo_helper"

RSpec.describe DrugComboHelper, '.exist_in_drug_combo_list' do

  context 'with an empty drug combo list' do
    it 'should return false' do
      target_drug_combo = {
          'drugs': [
              {
                  'drugId' => 'DrugA_ID',
                  'name' => 'DrugA_Name',
                  'description' => 'DrugA_Desc',
                  'drugClass' => 'DrugA_Class',
                  'pathway' => 'DrugA_Pathway',
                  'target' => 'DrugA_Target'
              }
          ]
      }
      expect(DrugComboHelper.exist_in_drug_combo_list(nil, target_drug_combo)).to eq(false)
    end
  end

  context 'with an empty target drug combo' do
    it 'should return false' do
      drug_combo_list = [
          {
              "drugs": [
                  {
                      'drugId' => 'DrugA_ID',
                      'name' => 'DrugA_Name',
                      'description' => 'DrugA_Desc',
                      'drugClass' => 'DrugA_Class',
                      'pathway' => 'DrugA_Pathway',
                      'target' => 'DrugA_Target'
                  }
              ]
          },
          {
              "drugs": [
                  {
                      'drugId' => 'DrugB_ID',
                      'name' => 'DrugB_Name',
                      'description' => 'DrugB_Desc',
                      'drugClass' => 'DrugB_Class',
                      'pathway' => 'DrugB_Pathway',
                      'target' => 'DrugB_Target'
                  }
              ]
          }
      ]
      expect(DrugComboHelper.exist_in_drug_combo_list(drug_combo_list, nil)).to eq(false)
    end
  end

  context 'with no matching drug combo' do
    it 'should return false' do
      drug_combo_list = [
          {
              'drugs' => [
                  {
                      'drugId' => 'DrugA_ID',
                      'name' => 'DrugA_Name',
                      'description' => 'DrugA_Desc',
                      'drugClass' => 'DrugA_Class',
                      'pathway' => 'DrugA_Pathway',
                      'target' => 'DrugA_Target'
                  }
              ]
          },
          {
              'drugs' => [
                  {
                      'drugId' => 'DrugB_ID',
                      'name' => 'DrugB_Name',
                      'description' => 'DrugB_Desc',
                      'drugClass' => 'DrugB_Class',
                      'pathway' => 'DrugB_Pathway',
                      'target' => 'DrugB_Target'
                  }
              ]
          }
      ]
      target_drug_combo = {
          'drugs' => [
              {
                  'drugId' => 'DrugC_ID',
                  'name' => 'DrugC_Name',
                  'description' => 'DrugC_Desc',
                  'drugClass' => 'DrugC_Class',
                  'pathway' => 'DrugC_Pathway',
                  'target' => 'DrugC_Target'
              }
          ]
      }
      expect(DrugComboHelper.exist_in_drug_combo_list(drug_combo_list, target_drug_combo)).to eq(false)
    end
  end

  context 'with a single drug match' do
    it 'should return true' do
      drug_combo_list = [
          {
              'drugs' => [
                  {
                      'drugId' => 'DrugA_ID',
                      'name' => 'DrugA_Name',
                      'description' => 'DrugA_Desc',
                      'drugClass' => 'DrugA_Class',
                      'pathway' => 'DrugA_Pathway',
                      'target' => 'DrugA_Target'
                  }
              ]
          },
          {
              'drugs' => [
                  {
                      'drugId' => 'DrugB_ID',
                      'name' => 'DrugB_Name',
                      'description' => 'DrugB_Desc',
                      'drugClass' => 'DrugB_Class',
                      'pathway' => 'DrugB_Pathway',
                      'target' => 'DrugB_Target'
                  }
              ]
          }
      ]
      target_drug_combo = {
          'drugs' => [
              {
                  'drugId' => 'DrugA_ID',
                  'name' => 'DrugA_Name',
                  'description' => 'DrugA_Desc',
                  'drugClass' => 'DrugA_Class',
                  'pathway' => 'DrugA_Pathway',
                  'target' => 'DrugA_Target'
              }
          ]
      }
      expect(DrugComboHelper.exist_in_drug_combo_list(drug_combo_list, target_drug_combo)).to eq(true)
    end
  end

  context 'with a multi-drugs match' do
    it 'should return true' do
      drug_combo_list = [
          {
              'drugs' => [
                  {
                      'drugId' => 'DrugA_ID',
                      'name' => 'DrugA_Name',
                      'description' => 'DrugA_Desc',
                      'drugClass' => 'DrugA_Class',
                      'pathway' => 'DrugA_Pathway',
                      'target' => 'DrugA_Target'
                  },
                  {
                      'drugId' => 'DrugB_ID',
                      'name' => 'DrugB_Name',
                      'description' => 'DrugB_Desc',
                      'drugClass' => 'DrugB_Class',
                      'pathway' => 'DrugB_Pathway',
                      'target' => 'DrugB_Target'
                  }
              ]
          },
          {
              'drugs' => [
                  {
                      'drugId' => 'DrugC_ID',
                      'name' => 'DrugC_Name',
                      'description' => 'DrugC_Desc',
                      'drugClass' => 'DrugC_Class',
                      'pathway' => 'DrugC_Pathway',
                      'target' => 'DrugC_Target'
                  }
              ]
          }
      ]
      target_drug_combo = {
          'drugs' => [
              {
                  'drugId' => 'DrugB_ID',
                  'name' => 'DrugB_Name',
                  'description' => 'DrugB_Desc',
                  'drugClass' => 'DrugB_Class',
                  'pathway' => 'DrugB_Pathway',
                  'target' => 'DrugB_Target'
              },
              {
                  'drugId' => 'DrugA_ID',
                  'name' => 'DrugA_Name',
                  'description' => 'DrugA_Desc',
                  'drugClass' => 'DrugA_Class',
                  'pathway' => 'DrugA_Pathway',
                  'target' => 'DrugA_Target'
              }
          ]
      }
      expect(DrugComboHelper.exist_in_drug_combo_list(drug_combo_list, target_drug_combo)).to eq(true)
    end
  end

end

RSpec.describe DrugComboHelper, '.does_drug_combo_match' do

  context 'with an empty drug combo1' do
    it 'should return false' do
      drug_combo2 = {
          'drugs': [
              {
                  'drugId' => 'DrugA_ID',
                  'name' => 'DrugA_Name',
                  'description' => 'DrugA_Desc',
                  'drugClass' => 'DrugA_Class',
                  'pathway' => 'DrugA_Pathway',
                  'target' => 'DrugA_Target'
              }
          ]
      }
      expect(DrugComboHelper.does_drug_combo_match(nil, drug_combo2)).to eq(false)
    end
  end

  context 'with an empty drug combo2' do
    it 'should return false' do
      drug_combo1 = {
          'drugs': [
              {
                  'drugId' => 'DrugA_ID',
                  'name' => 'DrugA_Name',
                  'description' => 'DrugA_Desc',
                  'drugClass' => 'DrugA_Class',
                  'pathway' => 'DrugA_Pathway',
                  'target' => 'DrugA_Target'
              }
          ]
      }
      expect(DrugComboHelper.does_drug_combo_match(drug_combo1, nil)).to eq(false)
    end
  end

  context 'with drug combo not matching' do
    it 'should return false' do
      drug_combo1 = {
          'drugs' => [
              {
                  'drugId' => 'DrugA_ID',
                  'name' => 'DrugA_Name',
                  'description' => 'DrugA_Desc',
                  'drugClass' => 'DrugA_Class',
                  'pathway' => 'DrugA_Pathway',
                  'target' => 'DrugA_Target'
              }
          ]
      }
      drug_combo2 = {
          'drugs' => [
              {
                  'drugId' => 'DrugB_ID',
                  'name' => 'DrugB_Name',
                  'description' => 'DrugB_Desc',
                  'drugClass' => 'DrugB_Class',
                  'pathway' => 'DrugB_Pathway',
                  'target' => 'DrugB_Target'
              }
          ]
      }
      expect(DrugComboHelper.does_drug_combo_match(drug_combo1, drug_combo2)).to eq(false)
    end
  end

  context 'with drug combo matching' do
    it 'should return true' do
      drug_combo1 = {
          'drugs' => [
              {
                  'drugId' => 'DrugA_ID',
                  'name' => 'DrugA_Name',
                  'description' => 'DrugA_Desc',
                  'drugClass' => 'DrugA_Class',
                  'pathway' => 'DrugA_Pathway',
                  'target' => 'DrugA_Target'
              }
          ]
      }
      drug_combo2 = {
          'drugs' => [
              {
                  'drugId' => 'DrugA_ID',
                  'name' => 'DrugA_Name',
                  'description' => 'DrugA_Desc',
                  'drugClass' => 'DrugA_Class',
                  'pathway' => 'DrugA_Pathway',
                  'target' => 'DrugA_Target'
              }
          ]
      }
      expect(DrugComboHelper.does_drug_combo_match(drug_combo1, drug_combo2)).to eq(true)
    end
  end

end
