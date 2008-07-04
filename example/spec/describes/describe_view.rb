def describe_view(controller, template, &block)
  describe "/#{controller.to_s.downcase}/#{template}" do
    before :all do
      @controller_class, @template = controller, template
    end
    before :each do
      @assigns = {}
    end
    
    def render(render_opts={})
      controller = @controller_class.new(fake_request)
      @assigns.each do |key, value|
        controller.instance_variable_set("@#{key}", value)
      end
      if @template.to_s =~ /^_/
        template = @template.to_s[1..-1] # strip leading _
        @content = controller.partial(template.to_sym, render_opts)
      else
        @content = controller.render(@template.to_sym, render_opts)
      end
    end
    
    def login_as(user)
      @assigns[:current_user] = user
    end
    
    instance_eval &block
  end
end
