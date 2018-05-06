class MembersController < ApplicationController
  before_action :authenticate_admin, only: [:index, :edit, :admin_password, :destroy, :show, :update]
  before_action :authenticate_member, only: [:profile, :edit_info, :update_info, :edit_password]
  before_action :set_member, only: [:show, :edit, :update, :destroy, :admin_password,
                :profile, :edit_info, :update_info, :edit_password]

  # 普通用户使用
  # ===================
  # 用户资料
  def profile
  end
  # 用户编辑资料
  def edit_info
  end
  # PATCH/PUT profile/update
  def update_info
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to profile_path, notice: '更新资料成功' }
        format.json { render :show, status: :ok, location: profile_path }
      else
        format.html { render :edit_info, alert: '更新失败，请稍后再试' }
        format.json { render json: { message: @member.errors, status: :unprocessable_entity}, status: :unprocessable_entity }
      end
    end
  end
  # 用户修改密码
  def edit_password
  end
  # PATCH/PUT profile/password_update
  def update_password
    @member = Member.find(session[:current_member_id]).try(:authenticate, member_params[:password])
    respond_to do |format|
      if !@member
        format.html { redirect_to profile_password_path, alert: '密码错误' }
        format.json { render json: { message: '密码错误', status: :unprocessable_entity}, status: :unprocessable_entity }
      else
        new_params = {
          password: member_params[:new_password],
          password_confirmation: member_params[:new_password_confirmation]
        }
        if @member.update(new_params)
          format.html { redirect_to profile_path, notice: '密码修改成功' }
          format.json { render :profile, status: :ok, location: profile_path }
        else
          format.html { render :edit_password }
          format.json { render json: { message: @member.errors, status: :unprocessable_entity}, status: :unprocessable_entity }
        end
      end
      
    end
  end

  # 管理员用户使用
  # =================
  # GET /members
  # GET /members.json
  def index
    @members = Member.all.order(created_at: :asc).page(params[:page]).per(5)
  end

  # GET /members/1
  # GET /members/1.json
  def show
  end

  # GET /members/new
  def new
    @member = Member.new
  end

  # GET /members/1/edit
  def edit
  end

  # GET /members/:id/admin_password
  def admin_password
  end
  # POST /members
  # POST /members.json
  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        # redirect_to new_session_path
        format.html { redirect_to new_session_path, notice: 'Member was successfully created.' }
        format.json { render :show, status: :created, location: @member }
      else
        format.html { render :new }
        format.json { render json: { message: @member.errors, status: :unprocessable_entity }, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /members/1
  # PATCH/PUT /members/1.json
  def update
    respond_to do |format|
      if @member.update(member_params)
        format.html { redirect_to @member, notice: 'Member was successfully updated.' }
        format.json { render :show, status: :ok, location: @member }
      else
        format.html { render :edit }
        format.json { render json: { message: @member.errors, status: :unprocessable_entity }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /members/1
  # DELETE /members/1.json
  def destroy
    @member.destroy
    respond_to do |format|
      format.html { redirect_to members_url, notice: 'Member was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_member
    member_id = params[:id] || session[:current_member_id]
    @member = Member.find(member_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def member_params
    params.require(:member).permit(:username, :nickname, :password, :password_confirmation, 
      :bio, :open_id, :union_id, :birthday, :new_password, :new_password_confirmation)
  end
end
