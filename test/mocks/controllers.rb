module Rails
  def self.public_path
    File.dirname(__FILE__)
  end
end

ActionController::Base.session = {
      :session_key => '_just_a_test',
      :secret      => '0cccfe5a9063159223dea0b4455ff859'
}

class ApplicationController < ActionController::Base
    
  def raise_parse_error
    raise REXML::ParseException.new("raised from controller not params parser")
  end
  
  def do_nothing
    render :text => "ok"
  end
  
end

class WithoutRescueFromController < ApplicationController
end

class WithRescueFromController < ApplicationController
  
  rescue_from REXML::ParseException do |exception|
    # begin
    #   raise "test"
    # rescue => e
    #   puts "Called from " + e.backtrace.join("\n")
    # end
    render :text => exception.message, :status => 400
  end
  
end