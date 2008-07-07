module ControllerStubs
  %w(render send_mail).each do |action|
    eval <<-STUB
      attr_reader :#{action}_args
      def #{action}(*args)
        @#{action}_args = args
      end
    STUB
  end
end
def describe_action(controller, action, &block)
  
  describe "#{controller}##{action}" do
    before :all do
      @controller_class, @action = controller, action
    end
    before :each do
      @session = {}
    end
    
    def dispatch(params = {}, env = {})
      @ivar_name ||= "@#{@controller_class.to_s.split('::').last.downcase.singularize}"
      if obj = instance_variable_get(@ivar_name)
        params = {:id => obj.id}.merge(params)
      end
      
      @controller = dispatch_to(@controller_class, @action, params, env) do |c|
        c.extend ControllerStubs
        c.stubs(:session).returns(@session)
      end
      
      if obj
        obj.reload unless obj.new_record?
      end
    end
    def post_dispatch(params = {}, env = {})
      dispatch(params, env.merge(:REQUEST_METHOD => 'POST'))
    end
    
    def login_as(user)
      @session[:user] = user ? user.id : nil
      User.stubs(:[]).with(@session[:user]).returns(user)
    end
    
    instance_eval &block
  end
end
