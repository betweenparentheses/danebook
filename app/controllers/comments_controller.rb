class CommentsController < ApplicationController

  def create
    klass, commentable_id = parse_klass_and_id

    @commentable = klass.find(params[commentable_id])
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:success] = "Commented!"
      redirect_to user_timeline_url(@commentable.user)
    else
      flash[:error] = "Something went wrong with that comment."
      redirect_to user_timeline_url(@commentable.user)
    end

  end

  def destroy
    @comment = Comment.find(params[:id])
    @user = @comment.commentable.user


    if @comment.destroy
      flash[:success] = "Deleted."
      redirect_to user_timeline_url(@user)
    else
      flash[:error] = "Something went wrong with that deletion."
      redirect_to user_timeline_url(@user)
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def parse_klass_and_id
    klass = params[:commentable].constantize
    commentable_id = "#{klass}_id".downcase.to_sym
    return klass, commentable_id
  end
end