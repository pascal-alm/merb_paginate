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
    
    #hpricot elem tests
    @response.body.should have_tag('ul') do |tag|
            tag.should be_match('The first post')
            tag.inner_text.should be_match('The first post')
            tag.inner_text.should_not be_match('/body>')
          end
    @content = @response.body
    
    @content.should match(/<ul.*?>(.*)<\/ul>/m)
    @content =~ /<ul.*?>(.*)<\/ul>/m #above doesnt set $1
    submatch = $1
    submatch.should match(/<li.*?>.*The first post.*<\/li>/m)     
    
    @content.should have_selector('li[@id=post_1]') 
  end
  
  it "should render with 20 objects without paginators" do
    @response = dispatch_to(Posts, :index, {:limit=>20})
    @response.should respond_successfully
    @content = @response.body
    
    
    @content.should match(/<ul.*?>(.*)<\/ul>/m)
      @content =~ /<ul.*?>(.*)<\/ul>/m #above doesnt set $1
      submatch = $1
      submatch.should match(/<li.*?>.*Post number 11.*<\/li>/m)
      submatch.should match(/<li.*?>.*Post number 20.*<\/li>/m)
      submatch.should_not match(/<li.*?>.*Post number 21.*<\/li>/m) 
      
      @content.should_not have_selector('div[@class=pagination]')         #pagination links not displayed
  end 
  
  it "should render with 21 objects with paginators" do
    @response = dispatch_to(Posts, :index, {:limit=>21})
    @response.should respond_successfully
    @content = @response.body
    
    
    @content.should match(/<ul.*?>(.*)<\/ul>/m)
      @content =~ /<ul.*?>(.*)<\/ul>/m 
      submatch = $1
      submatch.should match(/<li.*?>.*Post number 11.*<\/li>/m)
      submatch.should match(/<li.*?>.*Post number 20.*<\/li>/m)
      submatch.should_not match(/<li.*?>.*Post number 21.*<\/li>/m)    # on page 2
      
    @content.should have_selector('div[@class=pagination]')         
    #links enabled/disabled based on first/last page
    @content.should_not =~ /Previous<\/a>/         
    @content.should =~ /Next &raquo;<\/a>/
    
    @content.should have_tag('div',:class=>'pagination') do |inner|
     #wordier but same
      does_include_prev = nil
      does_include_next = nil
      (inner / 'a').each do |tag|
        does_include_prev = true if tag.inner_text =~ /Previous/
        does_include_next = true if tag.inner_text =~ /Next/
            end
      does_include_prev.should be_nil 
      does_include_next.should be_true
    end
  end
  
  it "should be able to go directly to page 2 with 21 objects " do
    @response = dispatch_to(Posts, :index, {:limit=>21, :page=>2})
    @response.should respond_successfully
    @content = @response.body
    
    
    @content.should match(/<ul.*?>(.*)<\/ul>/m)
      @content =~ /<ul.*?>(.*)<\/ul>/m 
      submatch = $1
      submatch.should_not match(/<li.*?>.*Post number 11.*<\/li>/m)
      submatch.should_not match(/<li.*?>.*Post number 20.*<\/li>/m)
      submatch.should match(/<li.*?>.*Post number 21.*<\/li>/m)    # on page 2
      
    @content.should have_selector('div[@class=pagination]')
    #links enabled/disabled based on first/last page
    @content.should =~ /Previous<\/a>/         
    @content.should_not =~ /Next &raquo;<\/a>/  

    #merby way
    @content.should have_tag('div',:class=>'pagination')
    @content.should have_tag('div',:class=>'pagination') do |inner|
      inner.inner_html.should =~ /Previous/
   
      (inner / 'a')[0].inner_html.should =~ /Previous/
      (inner / 'a').nitems.should == 2 # no next or page 2 links
      inner.should be_contain("Next")
      inner.inner_html.should =~ /Previous<\/a>/ 
      
      #wordier but same
      does_include_prev = nil
      does_include_next = nil
      (inner / 'a').each do |tag|
        does_include_prev = true if tag.inner_text =~ /Previous/
        does_include_next = true if tag.inner_text =~ /Next/
            end
      does_include_prev.should be_true
      does_include_next.should be_nil
    end
  end
  it "basics" 
end