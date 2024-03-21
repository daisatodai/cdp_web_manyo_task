class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]
  before_action :ensure_correct_user, only: %i[ show edit update destroy ]
  before_action :correct_label_user, only: [:new, :create, :edit, :update]
  # GET /tasks or /tasks.json
  def index
    @tasks = current_user.tasks.order(created_at: :desc)
    @tasks = @tasks.joins(:labels).where(labels: { id: params[:label_id] }) if params[:label_id].present?
    @tasks = current_user.tasks.sort_deadline_on if params[:sort_deadline_on]
    @tasks = current_user.tasks.sort_priority if params[:sort_priority]
    if params[:search]
      @tasks = current_user.tasks.order(created_at: :desc)
      @tasks = @tasks.title_like(params[:search][:title]) if params[:search][:title].present?
      @tasks = @tasks.status_is(params[:search][:status]) if params[:search][:status].present?
      @tasks = @tasks.label_search(params[:search][:label]) if params[:search][:label].present?
    end
    @tasks = @tasks.sort_by_created_at.page(params[:page]).per(10)
  end

  # GET /tasks/1 or /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    if params[:back]
      @task = current_user.tasks.build(task_params)
    else
      @task = current_user.tasks.build
    end
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @task = current_user.tasks.build(task_params)
    respond_to do |format|
      if params[:back]
        render :new
      else
        if @task.save
          format.html { redirect_to tasks_path(@task), notice: t('flash.tasks.created') }
          format.json { render :show, status: :created, location: @task }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @task.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
    if params[:label_ids].nil?
      @task.labels.clear
    end
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.tasks.updated')
    else
      render :edit
    end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_path, notice: t('flash.tasks.destroyed') }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
    end

    def ensure_correct_user
      if @task.user.id != current_user.id
        flash[:notice] = "アクセス権限がありません"
        redirect_to tasks_path
      end
    end

    def correct_label_user
      @labels = current_user.labels
    end
end
