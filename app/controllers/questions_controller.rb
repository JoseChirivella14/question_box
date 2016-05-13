class QuestionsController < ApplicationController
  before_action :authenticate, only: [:new, :create, :vote]
  before_action :set_question, only: [:show, :vote]

  def home
    @question = Question.new
    @unanswered_questions = Question.unanswered.order(created_at: :desc).limit(5)
    @answered_questions = Question.recently_answered.limit(5)
  end

  def index
    @questions = Question.order(created_at: :desc).page params[:page]
  end

  def new
    @question = Question.new
  end

  def create
    @question = current_user.questions.build(question_params)

    if @question.save
      redirect_to @question, success: 'Your question has been created.'
    else
      render :new
    end
  end

  def show
    @answers = @question.answers.order_by_votes
    @answer = Answer.new
  end

  def vote
    @voteable = @question
    @vote = @voteable.votes.build(user: current_user, value: params[:value])
    respond_to do |format|
      format.html do
        if @vote.save
          redirect_to @question, success: 'Your vote was recorded.'
        else
          redirect_to @question, error: 'There was a problem saving your vote.'
        end
      end
      format.js do
        if @vote.save
          render 'votes/create', status: :created
        else
          render 'votes/create', status: :accepted
        end
      end
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :text, :tag_list)
  end
end
