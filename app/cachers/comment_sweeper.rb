class CommentSweeper < ArticleSweeper
  observe Comment

  def after_save(record)
    @event.update_attributes :title => record.article.title, :body => record.body, :article => record.article
    expire_overview_feed!

    return if controller.nil?
    pages = CachedPage.find_by_reference(record.article)
    controller.class.benchmark "Expired pages referenced by #{record.class} ##{record.id}" do
      pages.each { |p| controller.class.expire_page(p.url) }
      CachedPage.expire_pages(pages)
    end if pages.any?
  end

  undef :after_create
end