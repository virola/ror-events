class Api::V1::MembersController < Api::V1::BaseController

  before_action :authenticate_member!, only: [:update]
  before_action :set_member, only: [:update, :show]

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    # byebug 
    respond_to do |format|
      # byebug
      if self.current_member && self.current_member.id == params[:id].to_i
        if @member.update(member_params)
          format.json { render :show, status: :ok, location: @member }
        else
          format.json { render json: { message: @member.errors, status: :unprocessable_entity }, status: :unprocessable_entity }
        end
      else
        format.json { render json: { message: '没有操作权限', status: :unprocessable_entity }, status: :unprocessable_entity }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_member
    member_id = params[:id]
    @member = Member.find(member_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(:username, :nickname, :password, :password_confirmation, 
      :bio, :open_id, :union_id, :birthday, :new_password, :new_password_confirmation)
  end
end
