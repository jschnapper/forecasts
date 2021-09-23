class MembersController < ManagementController
  before_action -> { requires_role :representative, team_name_slug: params[:team_name] }, except: [:index]
  before_action -> { requires_role :admin }, only: [:index]
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
    @member.build_member_role.new(role_id: params[:role_id])
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
    update = true
    if @member.teams.first.id != params[:team_id] 
      membership = Membership.new(member_id: @member.id, team_id: params[:team_id])
      if membership
        @member.memberships.replace([membership])
      else
        update = false
      end
    end
    if params[:role_id].present? && params[:role_id].to_i != -1 && @member.role&.id != params[:role_id] 
      role = MemberRole.new(member_id: @member.id, role_id: params[:role_id])
      if role
        @member.build_member_role(role_id: params[:role_id])
      else
        update = false
      end
    end
    if update && @member&.update(member_params)
      if params[:role_id].to_i == -1
        @member.member_role.destroy
      end
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
    params.require(:member).permit(:first_name, :middle_name, :last_name, :email)
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
