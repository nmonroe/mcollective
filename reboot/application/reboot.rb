class MCollective::Application::Reboot<MCollective::Application
  description "reboot nodes"
    usage <<-END_OF_USAGE
mco reboot [OPTIONS] [FILTERS]

    END_OF_USAGE
    
    def validate_configuration(configuration)
        if MCollective::Util.empty_filter?(options[:filter])
            print "Do you really want to operate on all nodes unfiltered? (y/n): "
            STDOUT.flush
            exit! unless STDIN.gets.strip.match(/^(?:y|yes)$/i)
        end
    end
    
    def log(msg)
        puts("#{Time.now}> #{msg}")
    end
    
    def main
        mc = rpcclient("reboot", :options => options)
        mc.reboot().each do |node|
            if node[:statuscode] == 0
                printf("%-25s:OK   - %s\n", node[:sender], node[:data][:msg])
            else
                printf("%-25s:FAIL - %s\n", node[:sender], node[:data][:msg])
            end
        end
        
        mc.disconnect
        printrpcstats
    end

end