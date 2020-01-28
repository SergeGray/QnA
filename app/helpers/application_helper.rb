module ApplicationHelper
  GIST_RECEIVER = "https://www.gonevis.com/toodartoo/embed/?media=".freeze

  def embed_gist(link)
    content_tag :iframe,
                '',
                src: "#{GIST_RECEIVER}#{link.url}",
                class: "gist-link-#{link.id}"
  end
end
