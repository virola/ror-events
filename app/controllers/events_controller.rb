class EventsController < ApplicationController
  # before_action :authenticate_public, only: [:show]
  before_action :authenticate_operation, except: [:show]
  before_action :authenticate_admin, only: [:all]
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :set_member, only: [:index, :create, :new]

  # GET /events
  # GET /events.json
  def all
    @events = Event.order(updated_at: :desc).page(params[:page]).per(5)
  end

  # GET /members/:member_id/events
  # GET /members/:member_id/events.json
  def index
    # @member = Member.
    @events = Event.where(member_id: params[:member_id]).order(updated_at: :desc).page(params[:page]).per(5)
  end

  # GET /events/1
  # GET /events/1.json
  def show
    # 需要验证是否公开或属于该登录成员，否则没有权限查看
    # 管理员可以查看
    if !@event.is_public && (!@_current_member || @_current_member.id != @event.member_id && @_current_member.role == 'user')
      # 没有查看权限
      @message = '没有权限查看'
      respond_to do |format|
        format.html { redirect_to root_path, alert: @message }
        format.json { render json: { message: @message, status: 'error' }, status: :unprocessable_entity }
      end
    end
  end

  # GET /events/new
  def new
    @event = Event.new(member_id: params[:member_id])
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    @event = @member.events.new(event_params)

    respond_to do |format|
      if @event.save
        format.html { redirect_to @event, notice: '创建成功' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: '更新成功' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # 验证某个事件是否可见，针对show
  def authenticate_public
    
  end
  

  # Use callbacks to share common setup or constraints between actions.
  def set_member
    @member = Member.find(params[:member_id])
  end
  def set_event
    @event = Event.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def event_params
    params.require(:event).permit(:name, :description, :is_public, :date, :member_id)
  end
end
