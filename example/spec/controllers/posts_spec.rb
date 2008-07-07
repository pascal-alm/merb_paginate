require File.join(File.dirname(__FILE__), "..", 'spec_helper.rb')

#COMBO Controller and view tests, because view merb rspecs flakey

describe Posts, "#index" do

  it "should respond correctly" do
      dispatch_to(Posts, :index).should respond_successfully
      #dispatch_to(Posts, :index). == 1
  end

end

describe Posts, "#index" do
  before(:each) do

  end

  it "should respond with empty post list" do
    @response = dispatch_to(Posts, :index, {:limit=>0})
    @response.should respond_successfully
    @response.body.should =~ /No entries found/
  end

  it "should respond with 1 post in list" do
    @response = dispatch_to(Posts, :index, {:limit=>1})
    @response.should respond_successfully
    @response.body.should =~ /<ul/
    
    #some of these should fail :( 
    @response.body.should have_tag('ul') do
            match_tag('li', :content=>'test1xxx')
            be_include('test1')
            be_include('/body>')
          end
    @content = @response.body
    
    @content.should match(/<ul.*?>(.*)<\/ul>/m)
    @content =~ /<ul.*?>(.*)<\/ul>/m #above doesnt set $1
    submatch = $1
    submatch.should match(/<li.*?>.*The first post.*<\/li>/m)     
    
    @content.should have_selector('li[@id=post_1]') 
  end
  
   
  
  it "basics" do
    #@response.should render_template(:index)
    @response.body.should == "a"
  end
end