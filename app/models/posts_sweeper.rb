class PostsSweeper < ActionController::Caching::Sweeper
  observe Post
  
  def after_save(post)
    FileUtils.rm_rf File.join(Rails.root, 'public', 'posts.atom')
  end
  
end