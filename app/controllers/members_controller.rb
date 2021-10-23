class MembersController < ManagementController
  before_action -> { requires_at_least_role :representative, team_name_slug: params[:team_name] }, except: [:index]
  before_action -> { requires_at_least_role :admin }, only: [:index]
  before_action :set_teams, :set_roles, except: [:index]

  def index
    @members = Member.includes(:teams, :role).all
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)
    @member.memberships.new(team_id: params[:team_id])
    @member.build_member_role(role_id: params[:role_id]) if params[:role_id].present?
    if @member.save
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
      redirect_to action: :edit
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
    params.require(:member).permit(:first_name, :middle_name, :last_name, :email, :team_id, :role_id)
  end

  def set_teams
    @teams = Team.all
    if params[:team_id].present?
      id = params[:team_id].to_i 
      @team = @teams.detect { |team| team.id == id }
    end
  end

  def set_roles
    @roles = Role.all
  end
end
