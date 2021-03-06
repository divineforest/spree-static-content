class Admin::PagesController < Admin::BaseController
  resource_controller

  def create_draft
    @page = Page.create!
    redirect_to edit_admin_page_url(@page.id)
  end

  update.response do |wants|
    wants.html { redirect_to collection_url }
  end
  
  update.after do
    expire_page :controller => '/static_content', :action => 'show', :path => @page.slug unless @page.slug == "/"
    Rails.cache.delete('page_not_exist/'+@page.slug) if @page.slug?
  end
  
  create.response do |wants|
    wants.html { redirect_to collection_url }
  end

  create.after do
    Rails.cache.delete('page_not_exist/'+@page.slug)
  end

end
