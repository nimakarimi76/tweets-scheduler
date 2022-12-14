class TweetsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tweet, only: %i[show edit update destroy]

  def index
    # @pagy, @tweets = pagy(current_user.tweets.order(publish_at: :desc))
    @pagy, @tweets = pagy(current_user.tweets.order(params[:sort]))
  end

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)
    if @tweet.save
      redirect_to tweets_path, notice: 'Tweet was scheduled successfully'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @tweet.update(tweet_params)
      redirect_to tweets_path, notice: 'Tweet was updated successfully'
    else
      render :edit
    end
  end

  def destroy
    @tweet.destroy
    redirect_to tweets_path, notice: 'Tweet was unscheduled'
  end

  private

  def tweet_params
    params.require(:tweet).permit(:twitter_account_id, :body, :publish_at)
  end

  def set_tweet
    @tweet = current_user.tweets.find(params[:id])
  end
end
