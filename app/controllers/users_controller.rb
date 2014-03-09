class UsersController < ApplicationController
    before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
    before_action :correct_user, only: [:edit, :update]
    before_action :admin_user, only: :destroy

    def index
        @users = User.paginate(page: params[:page])
    end

    def destroy
        User.find(params[:id]).destroy
        flash[:success] = "User deleted."
        redirect_to users_url
    end

    def new
        @user = User.new
    end

    def edit
    end

    def update
        if @user.update_attributes(user_params)
            # Handle a successful update.
            flash[:success] = "Profile updated"
            redirect_to @user
        else
            render 'edit'
        end
    end

    def create

        @user = User.new(user_params)
        if @user.save
            # Success.
            sign_in @user
            flash[:success] = "Welcome Alright, we're created!!"
            redirect_to @user
        else
            render 'new'
        end
    end

    def show
        @user = User.find(params[:id])
        @microposts = @user.microposts.paginate(page: params[:page])
    end

    private

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def admin_user
        redirect_to(root_url) unless current_user.admin?
    end

    def correct_user
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
    end


end
