module TransactionsHelper

  def calculate_running_balance(balance,amount,type)
    balance = balance.to_f
    amount = amount.to_f
    case type
      when 'Debit'
        return (balance + amount)
      when 'Credit'
        return (balance - amount)
      else
         return 'Error'
      end
  rescue =>e
    logger.error("Transaction_helper::calculate_running_balance::#{e}")
  end


  
end
