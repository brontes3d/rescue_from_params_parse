# ActionController::Rescue is a module included into ActionController::Base 
# in the same way as CheckEnvForParamsParseFailure is being included here
# It defines a method rescue_action
# Since this is the layer in which exceptions are normally caught and handled
# then this is the layer in which we insert our hook
module CheckEnvForParamsParseFailure
  
  def self.included(base)
    base.class_eval do
      alias_method_chain :perform_action, :check_for_failed_param_parse
    end
  end

  def perform_action_with_check_for_failed_param_parse
    if request.env["rescue_from_params_parse.exception"]
      rescue_action(request.env["rescue_from_params_parse.exception"])
    else
      perform_action_without_check_for_failed_param_parse
    end
  end
  
end

ActionController::Base.send(:include, CheckEnvForParamsParseFailure)

# This class implments rack middleware
# It is meant to wrap the rack middleware ActionController::ParamsParser
# If call ActionController::ParamsParser fails, we insert the exception into the environment
# So that our ActionController::Base hook can find it later and raise it from the appropriate place in the stack
class RescueFromParamsParse
  
  def initialize(app)
    @app = app
    @params_parser = ActionController::ParamsParser.new(app)
  end
  
  def call(env)
    begin
      @params_parser.call(env)
    rescue => e
      env["rescue_from_params_parse.exception"] = e
      @app.call(env)
    end
  end  
end

ActionController::Dispatcher.middleware.swap(ActionController::ParamsParser, RescueFromParamsParse)
