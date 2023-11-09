class MicropostsController < ApplicationController
  before_action :redirect_based_on_login_status, except: []
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = 'Micropost created!'
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:id])
    if @micropost.destroy
      flash[:success] = 'Micropost deleted'
      redirect_to request.referrer || root_url
    else
      flash[:danger] = 'Fail to delete micropost'
    end
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def correct_user
    if current_user != Micropost.find(params[:id]).user
      flash[:danger] = 'You are not allowed to do this'
      redirect_to root_url
    end
  end
end
