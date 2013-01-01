module MCollective
    module Agent
        class Reboot<RPC::Agent
            action "reboot" do
                run("reboot")
            end
        end
    end
end
