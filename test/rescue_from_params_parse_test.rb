require 'rubygems'
require 'test/unit/notification'
require 'rexml/document'
require File.expand_path(File.dirname(__FILE__) + '/test_helper')
require 'test/unit'

class RescueFromParamsParseTest < ActionController::IntegrationTest

  def setup
    ActionController::Base.consider_all_requests_local = false
  end
  
  def test_controller_without_rescue_from
    get "/without_rescue_from/raise_parse_error"
    
    assert_response 500, "expected 500 but got:\n#{@response.body}"
  
    post "/without_rescue_from/do_nothing", good_xml, posting_xml_headers
    
    assert_response 200, "expected 200 but got:\n#{@response.body}"
  
    post "/without_rescue_from/do_nothing", bad_xml, posting_xml_headers
    
    assert_response 500, "expected 500 but got:\n#{@response.body}"      
  end
  
  def test_controller_with_rescue_from
    get "/with_rescue_from/raise_parse_error"
    
    assert_response 400, "expected 400 but got:\n#{@response.body}"

    post "/with_rescue_from/do_nothing", good_xml, posting_xml_headers
    
    assert_response 200, "expected 200 but got:\n#{@response.body}"
    
    post "/with_rescue_from/do_nothing", bad_xml, posting_xml_headers
    
    assert_response 400, "expected 400 but got:\n#{@response.body}"
  end
  

  def bad_xml
    %Q[
      <?xml version="1.0" encoding="UTF-8"?>
      <thing>
        <tag not closed = "bad"
    ]
  end
  
  def good_xml
    %Q[
      <?xml version="1.0" encoding="UTF-8"?>
      <thing>
        <other-thing>value</other-thing>
      </thing>
    ]    
  end
  
  def posting_xml_headers
    {
      :content_type => 'application/xml', 
      :accept => 'application/xml'
    }
  end
  
end
