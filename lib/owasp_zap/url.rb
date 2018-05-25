# module OwaspZap
#     class url
#       def initialize(params = {})
#           #TODO
#           #handle it
#           @base = params[:base]
#           @target = params[:target]
#       end
Puppet::Functions.create_function(:'owasp_zap::url') do
  dispatch :attack do
    param :base
    param :target
    param :followRedirects
  end

      def start
          url = Addressable::URI.parse("#{base}/JSON/core/action/accessUrl/")
          url.query_values = {:zapapiformat=>"JSON",:url=>"#{target}",:followRedirects=>"#{followRedirects}"}
          RestClient::get url.normalize.to_str
      end

  end
end
