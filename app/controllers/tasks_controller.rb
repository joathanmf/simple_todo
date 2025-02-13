class TasksController < ApplicationController
  def index
    @tasks = Task.all
    @task = Task.new
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

  private

  def task_params
    params.require(:task).permit(:name)
  end
end
