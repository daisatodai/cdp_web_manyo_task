class LabelsController < ApplicationController
  # skip_before_action :logout_required
  # before_action :set_user, only: %i[ index new create]
  skip_before_action :login_required, only: [:new, :create]
  before_action :set_label, only: %i[ show edit update destroy ]

  def index
    @labels = current_user.labels
  end

  # GET /tasks/1 or /tasks/1.json

  # GET /tasks/new
  def new
    @label = Label.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks or /tasks.json
  def create
    @label = Label.new(label_params)
    @label = current_user.labels.build(label_params)
        if @label.save
          redirect_to labels_path, notice: t('flash.labels.created')
        else
          render :new
        end
  end

  # PATCH/PUT /tasks/1 or /tasks/1.json
  def update
      if @label.update(label_params)
        redirect_to labels_path(@label), notice: t('flash.labels.updated')
      else
        render :edit
      end
  end

  # DELETE /tasks/1 or /tasks/1.json
  def destroy
    @label.destroy
    redirect_to labels_path, notice: t('flash.labels.destroyed')
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_label
      @label = Label.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def label_params
      params.require(:label).permit(:name, task_ids: [])
    end
  end