class FieldsController < ApplicationController
  def index
    @fields = Field.all
  end

  def new
    @field = Field.new
  end

  def create
    @field = Field.new(field_params)
    if Field.create(field_params)
      redirect_to @field
    else
      render :new
    end
  end

  def show
    @field = Field.find_by(id: params[:id])
    if @field.nil?
      redirect_to action: :index
    end
  end

  def edit
    @field = Field.find_by(id: params[:id])
    if @field
      render :edit
    else
      redirect_to action: :index
    end
  end

  def update
    @field = Field.find_by(id: params[:id])
    if @field&.update(field_params)
      redirect_to(@field)
    else
      render :edit
    end
  end

  def destroy
    @field = Field.find_by(id: params[:id])
    if @field&.destroy
      redirect_to action: :index
    else
      render :show
    end
  end

  private

  def field_params
    params.require(:field).permit(:name, :code, :description, :default)
  end
end
