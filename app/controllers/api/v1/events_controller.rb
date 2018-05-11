class Api::V1::EventsController < Api::V1::BaseController
  # token login
  before_action :authenticate_member!, only: [:index, :create, :update, :destroy]

  before_action :set_event, only: [:show, :update, :destroy]
  before_action :set_member, only: [:create]
  before_action :authenticate_operation!, only: [:update, :destroy]
  
  # GET /api/v1/events.json
  def index
    @events = Event.where(member_id: self.current_member.id).order(updated_at: :desc).page(params[:page]).per(10)
  end

  # GET /api/v1/events/1.json
  def show
    # 需要验证是否公开或属于该登录成员，否则没有权限查看
    # 管理员可以查看
    if !@event.is_public && (!self.current_member || self.current_member.id != @event.member_id && self.current_member.role == 'user')
      # 没有查看权限
      return api_error(status: 401, message: '没有权限查看')
    end
  end

  # POST /api/v1/events.json
  def create
    @event = @member.events.new(event_params)

    respond_to do |format|
      if @event.save
        format.json { render :show, status: :created, location: @event }
      else
        return api_error(status: :unprocessable_entity, message: @event.errors)
      end
    end
  end

  # PATCH/PUT /api/v1/events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.json { render :show, status: :ok, location: @event }
      else
        return api_error(status: :unprocessable_entity, message: @event.errors)
      end
    end
  end

  # DELETE /api/v1/events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.json { render json: { message: @event.errors, status: 'ok', data: '删除成功'}, status: :ok }
    end
  end

  private
  # 验证操作权限
  # 必须是用户本人操作
  def authenticate_operation!
    # byebug
    unless self.current_member.id && (self.current_member.id == @event.member_id)
      return api_error(status: 401, message: '没有操作权限')
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(self.current_member.id)
  end

  def set_event
    @event = Event.find(params[:id])
    if !@event 
      return api_error(status: 404, message: '没有这个Event')
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name, :description, :is_public, :date)
  end
end
