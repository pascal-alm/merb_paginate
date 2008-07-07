require 'rubygems'
require 'merb-core'
require 'spec' # Satisfies Autotest and anyone else not using the Rake tasks

#Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'test')
Merb.start_environment(:testing => true, :adapter => 'runner', :environment => ENV['MERB_ENV'] || 'development')

Spec::Runner.configure do |config|
  config.include(Merb::Test::ViewHelper)
  config.include(Merb::Test::RouteHelper)
  config.include(Merb::Test::ControllerHelper)
end

Dir['spec/describes/*.rb'].each {|lib| require lib }

if $specs_timed.nil?
  $specs_timed = true
  $timings = []

  Spec::Example::ExampleGroup.prepend_before do
    @start = Time.now
  end
  Spec::Example::ExampleGroup.append_after do
    elapsed = Time.now - @start
    $timings << [elapsed, "#{self.class.description} #{description}"]
  end

  at_exit do
    $timings = $timings.sort{|a,b| a.first <=> b.first}
    total_time = $timings.map{|a|a.first}.inject(1){|a,b|a+b}
    slow_time = (ENV['SLOW'] || (total_time / $timings.size / 8) rescue 0).to_f 
    slow_timings = $timings.select{|t|t.first > slow_time}
    unless slow_timings.empty?
      slow_total = 0.0
      puts "\nSlow Specs (#{"> %.2f" % slow_time}):"
      slow_timings.each do |time, name|
        slow_total += time
        puts " %7.2f #{name}" % time
      end
      puts "---------"
      puts " %7.2f Total in #{slow_timings.size} slow specs" % slow_total
      puts " %7.2f Over slow threshold" % (slow_total - slow_time*slow_timings.size)
    end
  end
end