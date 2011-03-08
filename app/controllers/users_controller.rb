class UsersController < ApplicationController
  layout 'property'

  before_filter :has_permission, :only=>[:index,:destroy]

  # GET /users
  # GET /users.xml
  def index
    @users = User.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end
  
  def welcome
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    id = user_is_admin? ? params[:id] : session[:current_user_id]
    @user = User.find(id)

    @properties = @user.properties
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    id = user_is_admin? ? params[:id] : session[:current_user_id]
    @user = User.find(id)
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = "User created!"
        session[:current_user] = @user.name
        session[:current_user_id] = @user.id
        format.html { redirect_to(@user, :notice => 'User was successfully created.') }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        flash[:error] = "Create user failed!"
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    id = user_is_admin? ? params[:id] : session[:current_user_id]
    @user = User.find(id)

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end

  def sign_in
  end

  def process_sign_in
    @user = User.find_by_email(params[:login][:email])

    if @user.blank? || !@user.correct_password?(params[:login][:password])
      flash[:error] = "Wrong email address or password."
      redirect_to :action=>:sign_in
    end

    if @user.correct_password?(params[:login][:password])
      session[:current_user] = @user.name
      session[:current_user_id] = @user.id
      redirect_to url_for(@user)
    end

  end

  def sign_out
    session[:current_user] = nil
    session[:current_user_id] = nil
    session[:current_property_id] = nil
    redirect_to :action=>:sign_in
  end
end
