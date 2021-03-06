require 'helper'

include OwaspZap

describe Zap do
    before do
        @zap = Zap.new(:target=>'http://127.0.0.1')
    end

    it "shouldnt be nil" do
        @zap.wont_be_nil
    end

    it "should have a target" do
        @zap.must_respond_to :target
    end

    it "target shouldnt be nil" do
        @zap.target.wont_be_nil
    end

    it "should have a base" do
        @zap.must_respond_to :base
        #assert_respond_to @zap,:base
    end

    it "should have method start" do
        @zap.must_respond_to :start
    end

    it "should have a method shutdown" do
        @zap.must_respond_to :shutdown
    end

    it "should respond_to to spider" do
        @zap.must_respond_to :spider
    end

    it "should call spider and get a spider object" do
        assert_equal @zap.spider.class,Zap::Spider
    end

    it "should respond_to auth" do
        @zap.must_respond_to :auth
    end

    it "should call auth and get an auth object" do
        assert_equal @zap.auth.class, Zap::Auth
    end

    it "should respond_to ascan" do
        @zap.must_respond_to :ascan
    end

    it "should call ascan and get an attack object" do
        assert_equal @zap.ascan.class, Zap::Attack
    end

    it "should call the url" do
       assert_equal @zap.url.class, Zap::Url
    end
    
    it "should respond_to alerts" do
        @zap.must_respond_to :alerts
    end

    it "should call alerts and get a alert object" do
        assert_equal @zap.alerts.class,Zap::Alert
    end

    it "base shouldnt be nil" do
        @zap.base.wont_be :nil?
    end

    it "base default should be http://127.0.0.1:8080" do
        assert_equal @zap.base, "http://127.0.0.1:8080"
    end
end

describe "changing default params" do
    it "should be able to set base" do
        @zap = Zap.new(:target=>'http://127.0.0.1',:base=>'http://127.0.0.2:8383')
        assert_equal @zap.base, "http://127.0.0.2:8383"
    end
end

describe "method shutdown" do
    before do
        @h = Zap::Zap.new :target=>"http://127.0.0.1"
        stub_request(:get, "http://127.0.0.1:8080/JSON/core/action/shutdown/").to_return(:status => 200, :body => "{\"Result\":\"OK\"}" , :headers => {})
    end

    it "should receive a json as answer" do
         @h.shutdown.wont_be_nil
    end
    it "should request the shutdown url" do
        @h.shutdown
        assert_requested :get,"http://127.0.0.1:8080/JSON/core/action/shutdown/"
    end

end

describe "StringExtension" do
    it "should not respond_to camel_case and snake_case" do
        @str = ""
        [:camel_case,:snake_case].each do |m|
            @str.wont_respond_to m
        end
    end
     it "should respond_to camel_case and snake_case" do
        @str = ""
        @str.extend Zap::StringExtension
        [:camel_case,:snake_case].each do |m|
            @str.must_respond_to m
        end
    end
    it "should answer to camel_case" do
        @str = "foo_bar"
        @str.extend Zap::StringExtension
        assert_equal @str.camel_case,"fooBar"
    end
    it "should answer to snake_case" do
        @str = "fooBar"
        @str.extend Zap::StringExtension
        assert_equal @str.snake_case,"foo_bar"
    end
end

describe "status_for" do
    before do
        @h = Zap::Zap.new :target=>"http://127.0.0.1"
        stub_request(:get, "http://127.0.0.1:8080/JSON/spider/view/status/?zapapiformat=JSON").to_return(:status => 200, :body => {:status=>"100"}.to_json, :headers => {})
        stub_request(:get, "http://127.0.0.1:8080/JSON/ascan/view/status/?zapapiformat=JSON").to_return(:status => 200, :body => {:status=>"100"}.to_json, :headers => {})
    end

    it "should create a ascan" do
        @h.status_for(:ascan).wont_be_nil
    end
    it "should create a spider" do
        @h.status_for(:spider).wont_be_nil
    end
    it "should return an unknown" do
        @h.status_for(:foo).wont_be_nil
    end

    it "should return an integer" do
        @h.spider.status.must_be_kind_of Numeric
    end
    it "should return an integer" do
        @h.spider.status.must_be_kind_of Numeric
    end
end

describe "running? method" do
    before do
        @h = Zap::Zap.new :target=>"http://127.0.0.1"
        stub_request(:get, "http://127.0.0.1:8080/JSON/spider/view/status/?zapapiformat=JSON").to_return(:status => 200, :body => {:status=>"90"}.to_json, :headers => {})
        stub_request(:get, "http://127.0.0.1:8080/JSON/ascan/view/status/?zapapiformat=JSON").to_return(:status => 200, :body => {:status=>"100"}.to_json, :headers => {})
    end
    it "should return true" do
        @h.spider.running?.must_equal true
    end
    it "should return false" do
        @h.ascan.running?.must_equal false
    end
end
