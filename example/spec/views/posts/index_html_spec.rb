require File.join(File.dirname(__FILE__), "..","..", 'spec_helper.rb')

describe_view Posts, :index do
  before :each do
    #@controller_class.any_instance.stubs(:current_user).returns(User.new(:login => 'me'))
   # @assigns[:current_user] = stub(:login => "Me")
    @assigns[:post] = Post.new
    @assigns[:posts] = WillPaginate::Collection.create(1,20){|pager| pager.replace([])}
    
  end
  
  it "should render with nothing" do
    render
    @content.should have_tag('head')
    @content.should_not have_tag('li')
  end
  it "should render with 1 object" do
    @assigns[:posts] << Post.new(:title=>"test1")
    render #{}"/posts/index"
    
    # this block doesnt work as expected... everything passes when it shouldnt
    @content.should have_tag('ul') do
          match_tag('li', :content=>'test1xxx')
          be_include('test1')
          be_include('/body>')
        end
    @content.should match(/<ul.*?>(.*)<\/ul>/m)
      @content =~ /<ul.*?>(.*)<\/ul>/m #above doesnt set $1
      submatch = $1
      submatch.should match(/<li.*?>.*test1.*<\/li>/m)
    
      #clean-ish version -- but limits results to first tag match
      @content.should have_tag('ul li') do |tag|
        tag.inner_html.should match(/test1/)
      end
    
  end

  it "should render with 20 objects without paginators" do
    #tmp = []
    (0..21).each{|i| @assigns[:posts] << Post.new(:title=>"test#{i}")}  
   # 
    render

    @content.should match(/<ul.*?>(.*)<\/ul>/m)
      @content =~ /<ul.*?>(.*)<\/ul>/m #above doesnt set $1
      submatch = $1
      submatch.should match(/<li.*?>.*test11.*<\/li>/m)
      submatch.should match(/<li.*?>.*test20.*<\/li>/m)
      submatch.should_not match(/<li.*?>.*test21.*<\/li>/m)          
  end
  
  it "should render with 21 objects with paginators" do
    tmp = []
      (0..21).each{|i| tmp << Post.new(:title=>"test#{i}")}  
      tmp.nitems.should == 22
      @assigns[:posts] = WillPaginate::Collection.create(1,20,22){|pager| pager.replace(tmp)}
      #Post.paginate :page => params[:page], :per_page => 20
       @assigns[:posts].total_pages.should == 2
       render
     
       @content.should match(/<ul.*?>(.*)<\/ul>/m)
         @content =~ /<ul.*?>(.*)<\/ul>/m #above doesnt set $1
         submatch = $1
         submatch.should match(/<li.*?>.*test11.*<\/li>/m)
         submatch.should match(/<li.*?>.*test20.*<\/li>/m)
         submatch.should_not match(/<li.*?>.*test21.*<\/li>/m) #should not be visible yet
   end
  
  
end