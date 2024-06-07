# app/controllers/groups_controller.rb
class GroupsController < ApplicationController
  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
      redirect_to @group
    else
      render :edit
    end
  end

  def calculate_score
    @group = Group.find(params[:id])
    @group.calculate_score
    @group.save!
    redirect_to @group
  end

  private

  def group_params
    params.require(:group).permit(:name, :multiplier)
  end
end
