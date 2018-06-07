class NotifySubscribersJob < ApplicationJob
  queue_as :default

  def perform(answer)
    question = answer.question

    question.subscriptions.find_each do |subscription|
      QuestionsMailer.notify(subscription.user, answer).deliver_later
    end
  end
end
