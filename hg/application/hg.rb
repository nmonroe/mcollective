class MCollective::Application::Hg<MCollective::Application
  description "manage hg repositories"
    usage <<-END_OF_USAGE
mco hg [OPTIONS] [FILTERS] <ACTION> [REPO]

The ACTION can be one of the following:
    update -- Does a hg pull / hg update of specified repository
    status -- Does hg status on repository and returns the results

    END_OF_USAGE

    def post_option_parser(configuration)
        if ARGV.length >= 1
            configuration[:command] = ARGV.shift
            configuration[:repo] = ARGV.shift
            unless configuration[:command].match(/^(update|status)$/)
                raise "Action must be update or status"
            end
        else
            raise "Please specify an action."
        end
    end
    
    def validate_configuration(configuration)
        if MCollective::Util.empty_filter?(options[:filter])
            print "Do you really want to operate on all hosts unfiltered? (y/n): "
            STDOUT.flush
            exit! unless STDIN.gets.strip.match(/^(?:y|yes)$/i)
        end
    end
    
    def log(msg)
        puts("#{Time.now}> #{msg}")
    end
    
    def main
        mc = rpcclient("hg", :options => options)
        case configuration[:command]
            when "update"
                mc.update(:repo => configuration[:repo]).each do |node|
                    if node[:statuscode] == 0
                        printf("%-25s:OK   - %s\n", node[:sender], node[:data][:msg])
                    else
                        printf("%-25s:FAIL - %s\n", node[:sender], node[:data][:msg])
                    end
                end
            when "status"
                mc.status(:repo => configuration[:repo]).each do |node|
                    if node[:statuscode] == 0
                        printf("%-25s:OK   - %s\n", node[:sender], node[:data][:msg])
                    else
                        printf("%-25s:FAIL - %s\n", node[:sender], node[:data][:msg])
                    end
                end
        end
        

        mc.disconnect
        printrpcstats
    end

end
