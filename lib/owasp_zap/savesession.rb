# module OwaspZap
#   class savesession
#     def initialize(params = {})
#         #TODO
#         #handle it
#         @base = params[:base]
#         @name = params[:sessionname]
#         @overwrite = params[:overwrite]
#     end
Puppet::Functions.create_function(:'owasp_zap::savesession') do
  dispatch :attack do
    param :base
    param :sessionname
    param :overwrite
  end

    def start
        url = Addressable::URI.parse("#{base}/JSON/core/action/saveSession/")
        url.query_values = {:zapapiformat=>"JSON",:name=>"#{sessionname}",:overwrite=>"#{overwrite}"}
        RestClient::get url.normalize.to_str
    end
  end
end
