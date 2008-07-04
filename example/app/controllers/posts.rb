class Posts < Application
  
  def index(limit=nil)
    #@posts = Post.paginate :page => params[:page], :per_page => 20
    limit ||= params[:limit].to_i
    unless limit.nil? or limit == 0
      @posts = Post.all( :limit=>limit).paginate :page => params[:page], :per_page => 20
    else
      @posts = Post.paginate :page => params[:page], :per_page => 20
    end
    render
  end
  
  
end
