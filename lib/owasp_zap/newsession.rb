module OwaspZap
  class newsession
    def initialize(params = {})
        #TODO
        #handle it
        @base = params[:base]
        @name = params[:sessionname]
        @overwrite = params[:overwrite]
    end

    def start
        url = Addressable::URI.parse("#{@base}/JSON/core/action/newSession/")
        url.query_values = {:zapapiformat=>"JSON",:name=>"#{@name}",:overwrite=>"#{@overwrite}"}
        RestClient::get url.normalize.to_str
    end
  end
end    
