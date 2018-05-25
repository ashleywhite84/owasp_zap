##
Puppet::Functions.create_function(:'owasp_zap::attack') do
  dispatch :attack do
    param :base
    param :target
    param :recurse
  end

# module OwaspZap
    #class Attack
        # def initialize(params = {})
        # #
        #     # handle it
        #     @base = params[:base]
        #     @target = params[:target]
        # end

        def start
            url = Addressable::URI.parse("#{base}/JSON/ascan/action/scan/")
            url.query_values = {:zapapiformat=>"JSON",:url=>"#{target}",:recurse=>"#{recurse}"}
            RestClient::get url.normalize.to_str
        end

        def status
            ret = JSON.parse(RestClient::get("#{base}/JSON/ascan/view/status/?zapapiformat=JSON"))
            if ret.has_key? "status"
                ret["status"].to_i
            else
                100 # it means no running
            end
        end

        def running?
            self.status != 100
        end

    end
end
