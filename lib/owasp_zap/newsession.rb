
Puppet::Functions.create_function(:'owasp_zap::newsession') do
  dispatch :attack do
    param :base
    param :overwrite
    param :sessionname
  end
end
module OwaspZap
  class newsession
    def initialize(params = {})
        # TODO
        #handle it
        @base = params[:base]
        @name = params[:sessionname]
        @overwrite = params[:overwrite]
    end
    def start
        url = Addressable::URI.parse("#{base}/JSON/core/action/newSession/")
        url.query_values = {:zapapiformat=>"JSON",:sessionname=>"#{sessionname}",:overwrite=>"#{overwrite}"}
        RestClient::get url.normalize.to_str
    end
  end
end
