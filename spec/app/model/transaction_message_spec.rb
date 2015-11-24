require "#{File.dirname(__FILE__)}/../../../app/model/transaction_message"

RSpec.describe TransactionMessage, '#initialize' do
  context 'with status "SUCCESS" and message "The transaction was completed successfully."' do
    it 'should return status "SUCCESS" and message "The transaction was completed successfully."' do
      message = TransactionMessage.new('STATUS', 'The transaction was completed successfully.')
      expect(message.status).to eq('STATUS')
      expect(message.message).to eq('The transaction was completed successfully.')
    end
  end

  context 'with status "FAILURE" and message "The transaction failed to complete successfully."' do
    it 'should return status "FAILURE" and message "The transaction failed to complete successfully."' do
      message = TransactionMessage.new('FAILURE', 'The transaction failed to complete successfully.')
      expect(message.status).to eq('FAILURE')
      expect(message.message).to eq('The transaction failed to complete successfully.')
    end
  end
end