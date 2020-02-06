class TasksController < ApplicationController
  before_action :require_user_logged_in
  
  def index
    #@tasks = Task.all.page(params[:page]).per(5)
    @tasks = current_user.tasks.all.page(params[:page]).per(5)
  end

  def show
    set_task
  end

  def new
    @task = current_user.tasks.new
  end

  def create
    @task = current_user.tasks.new(task_params)

    if @task.save
      flash[:success] = 'タスクが正常に投稿されました'
      redirect_to @task
    else
      flash[:danger] = 'タスクが投稿されませんでした'
      render :new
    end
  end

  def edit
    set_task
  end

  def update
    set_task

    if @task.update(task_params)
      flash[:success] = 'Task は正常に更新されました'
      redirect_to @task
    else
      flash.now[:danger] = 'Task は更新されませんでした'
      render :edit
    end
  end

  def destroy
    set_task
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to tasks_url
  end
  
  
    private

  def set_task
    @task = current_user.tasks.find_by(params[:user_id])
    unless current_user.tasks
      redirect_to '/'
    end
  end

  def task_params
    params.require(:task).permit(:content, :status, :user_id)
  end
end
