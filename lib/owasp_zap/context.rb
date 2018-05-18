module OwaspZap
  class context
    def initialize(params = {})
        #TODO
        #handle it
        @base = params[:base]
        @target = params[:target]
    end

    def start
        url = Addressable::URI.parse("#{@base}/JSON/context/action/IncludeInContext/")
        url.query_values = {:zapapiformat=>"JSON",:contextName=>"Default Context",:regex=>@target.*}
        RestClient::get url.normalize.to_str
    end
  end
end
