class Posts < Application
  
  def index(limit=nil)
    #@posts = Post.paginate :page => params[:page], :per_page => 20
    limit ||= (params[:limit].to_i if params[:limit])
    
    if limit == 0
      @posts = WillPaginate::Collection.create(1,20){|pager| pager.replace([])}
    elsif  limit.nil? 
      @posts = Post.paginate :page => params[:page], :per_page => 20        
    else  
      @posts = Post.all( :limit=>limit).paginate :page => params[:page], :per_page => 20
    end
    render
  end
  
  
end
