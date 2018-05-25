# module OwaspZap
#   class context
#     def initialize(params = {})
#         #TODO
#         #handle it
#         @base = params[:base]
#         @target = params[:target]
#     end
Puppet::Functions.create_function(:'owasp_zap::context') do
  dispatch :attack do
    param :base
    param :regex
  end

    def start
        url = Addressable::URI.parse("#{base}/JSON/context/action/IncludeInContext/")
        url.query_values = {:zapapiformat=>"JSON",:contextName=>"#{context}",:regex=>"#{target.*}"}
        RestClient::get url.normalize.to_str
    end
  end
end
