# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def get_user_name(id)
    return User.find(id).name
  rescue =>e
    logger.error("Application_helper::get_user_name::#{e}")
  end

  def get_category_description(id)
    return 'None' if id.blank?
    return Category.find(id).description
  rescue =>e
    logger.error("Application_helper::get_category_description::#{e}")
  end

  def dr_cr_selection
    return [['Money In','Debit'],['Money Out','Credit']]
  rescue =>e
    logger.error("Application_helper::dr_cr_selection::#{e}")
  end

  def display_dr_or_cr(option)
    case option
    when 'Debit'
      return 'Money In'
    when 'Credit'
      return 'Money Out'
    else
      return 'error'
    end
  rescue =>e
    logger.error("Application_helper::display_dr_or_cr::#{e}")
  end

  def display_transaction_amount(transaction)
    case transaction.transaction_type
    when 'Debit'
      return "#{number_to_currency(transaction.amount)}"
    when 'Credit'
      return "-#{number_to_currency(transaction.amount)}"
    else
      return 'error'
    end
  rescue =>e
    logger.error("Application_helper::display_transaction_amount::#{e}")
  end

  def get_total_balance
    debit_total = Transaction.sum(:amount,:conditions=>['property_account_id = ? and transaction_type = ?', session[:current_property_id], 'Debit'])
    credit_total = Transaction.sum(:amount,:conditions=>['property_account_id = ? and transaction_type = ?',session[:current_property_id], 'Credit'])
    return debit_total - credit_total
  rescue =>e
    return 'error'
    logger.error("Application_helper::get_total_balance::#{e}")
  end

  def get_number_of_transactions
    return Transaction.count(:conditions=>['property_account_id = ?', session[:current_property_id]])
  rescue =>e
    return 'error'
    logger.error("Application_helper::get_number_of_transactions::#{e}")
  end

  def get_number_of_dr_transactions
    return Transaction.count(:conditions=>['property_account_id = ? and transaction_type = ?', session[:current_property_id],'Debit'])
  rescue =>e
    return 'error'
    logger.error("Application_helper::get_number_of_dr_transactions::#{e}")
  end

  def get_number_of_cr_transactions
    return Transaction.count(:conditions=>['property_account_id = ? and transaction_type = ?', session[:current_property_id],'Credit'])
  rescue =>e
    return 'error'
    logger.error("Application_helper::get_number_of_cr_transactions::#{e}")
  end

end
