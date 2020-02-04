import consumer from './consumer'

consumer.subscriptions.create(
  { 
    channel: 'CommentsChannel',
    question_id: gon.question_id
  }, {
    received(data) {
      $(
        '.' + data.commentable_type +
        '-' + data.commentable_id +
        '-comments .comments'
      ).append(data.template)
    }
  }
)
