class PostDelayedMailer < Struct.new(:user, :post)

  def perform
    UserMailer.topic_updated(user, post).deliver
  end
  
end