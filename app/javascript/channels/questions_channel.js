import consumer from './consumer'

consumer.subscriptions.create('QuestionsChannel', {
  received(data) {
    $('.questions').append(data)
  }
})
