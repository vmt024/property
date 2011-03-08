class TransactionsController < ApplicationController
  layout 'property'
  # GET /transactions
  # GET /transactions.xml
  def index
    if session[:current_property_id].blank?
      flash[:error] = 'Please select an property account first.'
      redirect_to :controller=>'users',:action=>'show',:id=>session[:current_user_id]
    else
      unless params[:month].blank?
        @transactions = Transaction.find(:all, :conditions=>['property_account_id = ? and date LIKE ?',session[:current_property_id],"#{params[:month]}%"])
      else
        @transactions = Transaction.find(:all,:conditions=>['property_account_id = ?', session[:current_property_id]],:order=>'date asc')
      end
      @property = PropertyAccount.find(session[:current_property_id])
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @transactions }
        format.csv { export_to_csv(@transactions)}
        format.pdf {export_to_pdf(@transactions)}
      end
    end

  end

  def list
    date_from = params[:search][:date_from]
    date_to = params[:search][:date_to]

    type = params[:search][:type]

    @property = PropertyAccount.find(session[:current_property_id])
    if type.blank?
      @transactions = Transaction.find(:all, :conditions=>['(property_account_id = ?) and (date between ? and ?)',session[:current_property_id],date_from,date_to])
    else
      @transactions = Transaction.find(:all, :conditions=>['(property_account_id = ? and transaction_type = ?) and (date between ? and ?)',session[:current_property_id],type,date_from,date_to])
    end
    render :action=>:index
  end

  # GET /transactions/1
  # GET /transactions/1.xml
  def show
    @transaction = Transaction.find(params[:id])
    unless user_is_admin? || user_is_owner?(@transaction.property.user_id)
      flash[:error] = "The page you requested is for administrator only. Please sign in as administrator to continue."
      redirect_to :controller=>"users",:action=>"sign_in"
      return false
    end
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/new
  # GET /transactions/new.xml
  def new
    @transaction = Transaction.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @transaction }
    end
  end

  # GET /transactions/1/edit
  def edit
    @transaction = Transaction.find(params[:id])
    unless user_is_admin? || user_is_owner?(@transaction.property.user_id)
      flash[:error] = "The page you requested is for administrator only. Please sign in as administrator to continue."
      redirect_to :controller=>"users",:action=>"sign_in"
      return false
    end
  end

  # POST /transactions
  # POST /transactions.xml
  def create
    @transaction = Transaction.new(params[:transaction])

    respond_to do |format|
      if @transaction.save
        flash[:notice] = 'Transaction was successfully created.'
        format.html { redirect_to(:action=>'index',:property_account_id=>@transaction.property_account_id) }
        format.xml  { render :xml => @transaction, :status => :created, :location => @transaction }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /transactions/1
  # PUT /transactions/1.xml
  def update
    @transaction = Transaction.find(params[:id])
    unless user_is_admin? || user_is_owner?(@transaction.property.user_id)
      flash[:error] = "The page you requested is for administrator only. Please sign in as administrator to continue."
      redirect_to :controller=>"users",:action=>"sign_in"
      return false
    end
    respond_to do |format|
      if @transaction.update_attributes(params[:transaction])
        flash[:notice] = 'Transaction was successfully updated.'
        format.html { redirect_to(:action=>'index',:property_account_id=>@transaction.property_account_id) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @transaction.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /transactions/1
  # DELETE /transactions/1.xml
  def destroy
    @transaction = Transaction.find(params[:id])
    unless user_is_admin? || user_is_owner?(@transaction.property.user_id)
      flash[:error] = "The page you requested is for administrator only. Please sign in as administrator to continue."
      redirect_to :controller=>"users",:action=>"sign_in"
      return false
    end
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to(transactions_url) }
      format.xml  { head :ok }
    end
  end


  private

  def export_to_csv(transactions)

    balance = 0
    csv_string = FasterCSV.generate do |csv|
      # header row
      csv << ["Date", "Category", "Type", "Amount"]

      # data rows
      transactions.each do |t|
        # balance
        if t.transaction_type.eql?('Debit')
          balance += t.amount.to_f
        else
          balance -= t.amount.to_f
        end

        csv << [t.date, Category.category_desc(t.category_id), Transaction.type_desc(t.transaction_type),t.amount]
      end
      csv << ["","","Balance",balance]
    end

    # send it to the browser
    send_data csv_string,
          :type => 'text/csv; charset=iso-8859-1; header=present',
          :disposition => "attachment; filename=transactions.csv"
    end

   def export_to_pdf(transactions)
     balance = 0
     file_path = "#{Rails.root}/public/reports/pdf_report"
     html = File.new("#{file_path}.html",'w+')
     # header row
     html << "<table><tr><th>Date</th><th>Category</th><th>Type</th><th>Amount</th></tr> \n"
     
      # data rows
      transactions.each do |t|
        # balance
        if t.transaction_type.eql?('Debit')
          balance += t.amount.to_f
        else
          balance -= t.amount.to_f
        end

        html << "<tr><td>#{t.date}</td><td>#{Category.category_desc(t.category_id)}</td><td>#{Transaction.type_desc(t.transaction_type)}</td><td>#{(t.amount)}</td></tr>"
      end
      html << "<tr><td>&nbsp;</td><td>&nbsp;</td><td><b>Balance: </b></td><td>#{(balance)}</td></tr>"
      html.close()
      
      system("wkhtmltopdf #{file_path}.html #{file_path}.pdf" )

      
      
      send_file "#{file_path}.pdf",
                :type => 'application/pdf; charset=iso-8859-1; header=present',
                :disposition => "attachment; filename=pdf_report.pdf"
   end
end
