import consumer from './consumer'

consumer.subscriptions.create(
  { 
    channel: 'AnswersChannel',
    question_id: gon.question_id
  }, {
    received(data) {
      $('.answers').append(data)
    }
  }
)
