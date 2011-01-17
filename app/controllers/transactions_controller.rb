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
        @transactions = Transaction.find_all_by_property_account_id(session[:current_property_id])
      end
      @property = PropertyAccount.find(session[:current_property_id])
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @transactions }
      end
    end

  end

  def list
    date_from = "#{params[:search]['date_from(1i)']}-#{params[:search]['date_from(2i)'].length.eql?(1) ? '0' : ''}#{params[:search]['date_from(2i)']}-#{params[:search]['date_from(3i)'].length.eql?(1) ? '0' : ''}#{params[:search]['date_from(3i)']}"
    date_to = "#{params[:search]['date_to(1i)']}-#{params[:search]['date_to(2i)'].length.eql?(1) ? '0' : '' }#{params[:search]['date_to(2i)']}-#{params[:search]['date_to(3i)'].length.eql?(1) ? '0' : ''}#{params[:search]['date_to(3i)']}"

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
    @transaction.destroy

    respond_to do |format|
      format.html { redirect_to(transactions_url) }
      format.xml  { head :ok }
    end
  end
end
