import consumer from "./consumer"

consumer.subscriptions.create("QuestionsChannel", {
  received(data) {
    let questionsList = $(".questions")
    questionsList.append(data)
  }
})
