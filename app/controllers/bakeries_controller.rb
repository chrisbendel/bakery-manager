class BakeriesController < ApplicationController
  before_action :require_user, except: [ :index, :show ]
  before_action :set_bakery, only: [ :show, :edit, :update ]
  before_action :ensure_owner, only: [ :edit, :update ]

  def index
    @bakeries = Bakery.all
  end

  def show
  end

  def new
    @bakery = Bakery.new
  end

  def edit
  end

  def create
    @bakery = Bakery.new(bakery_params)

    if @bakery.save
      Current.user.bakery_memberships.create(bakery: @bakery, role: :owner)
      redirect_to @bakery, notice: "Bakery created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bakery.update(bakery_params)
      redirect_to @bakery, notice: "Bakery updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def my_bakery
    @bakery = current_user.bakeries.first
    if @bakery
      redirect_to @bakery
    else
      redirect_to new_bakery_path
    end
  end

  private

  def ensure_owner
    unless @bakery.bakery_memberships.owner.exists?(user: current_user)
      redirect_to @bakery, alert: "Only bakery owners can perform this action"
    end
  end

  def bakery_params
    params.require(:bakery).permit(:name, :description, :image)
  end

  def set_bakery
    @bakery = Bakery.find(params[:id])
  end
end
