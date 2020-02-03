import consumer from "./consumer"

let questionsList = $(".questions")

consumer.subscriptions.create("QuestionsChannel", {
  connected() {
    this.perform('follow')
  },

  received(data) {
    let questionsList = $(".questions")
    questionsList.append(data)
  }
})
