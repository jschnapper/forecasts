class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    if Member.create(member_params)
      redirect_to @member
    else
      render :new
    end
  end

  def show
    @member = Member.find_by(id: params[:id])
    if @member.nil?
      redirect_to action: :index
    end
  end

  def edit
    @member = Member.find_by(id: params[:id])
    if @member
      render :edit
    else
      redirect_to action: :index
    end
  end

  def update
    @member = Member.find_by(id: params[:id])
    if @member&.update(member_params)
      redirect_to(@member)
    else
      render :edit
    end
  end

  def destroy
    @member = Member.find_by(id: params[:id])
    if @member&.destroy
      redirect_to action: :index
    else
      render :show
    end
  end

  private

  def member_params
    params.require(:member).permit(:first_name, :middle_name, :last_name, :email)
  end
end
