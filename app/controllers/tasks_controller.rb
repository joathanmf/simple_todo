class TasksController < ApplicationController
  before_action :set_task, except: %i[index create]

  def index
    @tasks = Task.all
    @task = Task.new
  end

  def edit
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("task_name_frame_#{@task.id}", partial: "edit", locals: { task: @task })
      end
    end
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("tasks", partial: "task", locals: { task: @task }),
            turbo_stream.update("task_form", partial: "form", locals: { task: Task.new })
          ]
        end
        format.html { redirect_to tasks_path }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("task_form", partial: "form", locals: { task: @task })
        end
        format.html do
          render :index, status: :unprocessable_entity
        end
      end
    end
  end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("task_#{@task.id}", partial: "task", locals: { task: @task })
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.replace("task_#{@task.id}", partial: "task", locals: { task: @task }),
            turbo_stream.update("task_name_frame_#{@task.id}", partial: "edit", locals: { task: @task })
          ]
        end
      end
    end
  end

  def destroy
    @task.destroy

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.remove("task_#{@task.id}")
      end
    end
  end

  def update_status
    respond_to do |format|
      @task.toggle_status

      format.turbo_stream do
        render turbo_stream: turbo_stream.update("task_#{@task.id}", partial: "task", locals: { task: @task })
      end
      format.html { redirect_to tasks_path }
    end
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name)
  end
end
