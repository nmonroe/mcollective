module MCollective
    module Agent
        class Hg<RPC::Agent
            action "update" do
                validate :repo, String
                r = request[:repo]
                hgbin = "/usr/bin/hg"
                if File.exists?(r) && File.directory?(r)
                    sout = ""
                    serr = ""
                    st = run("#{hgbin} status -R #{r} | /usr/bin/wc -l", :stdout => sout, :stderr => serr, :chomp=> true)
                    if st != 0
                        reply[:msg] = "Failed: #{r} has uncommited change(s)."
                        reply.fail! "Failed: #{r} has uncommited change(s).", 1
                    end
                    oout = ""
                    oerr = ""
                    out = run("#{hgbin} outgoing -R #{r}", :stdout => oout, :stderr => oerr, :chomp=> true)
                    if out == 0
                        reply[:msg] = "Failed: #{r} has committed & unpushed change(s)."
                        reply.fail! "Failed: #{r} has committed & unpushed change(s).", 1
                    end
                    pout = ""
                    perr = ""
                    pull = run("#{hgbin} pull -R #{r}", :stdout => pout, :stderr => perr, :chomp=> true)
                    if pull != 0
                        reply[:msg] = "Pull #{r} Failed:  #{perr}"
                        reply.fail! "Pull #{r} Failed:  #{perr}", 1
                    end
                    uout = ""
                    uerr = ""
                    update = run("#{hgbin} update -R #{r}", :stdout => uout, :stderr => uerr, :chomp=> true)
                    if update != 0
                        reply[:msg] = "Update #{r} Failed:  #{uerr}"
                        reply.fail! "Update #{r} Failed:  #{uerr}", 1
                    end
                else
                    reply[:msg] = "Repository #{r} does not exist."
                    reply.fail! "Repository #{r} does not exist.", 1
                end
                reply[:msg] = uout
            end
            
            action "status" do
                validate :repo, String
                r = request[:repo]
                hgbin = "/usr/bin/hg"
                if File.exists?(r) && File.directory?(r)
                    message = ""
                    sout = ""
                    serr = ""
                    st = run("#{hgbin} status -R #{r}", :stdout => sout, :stderr => serr, :chomp=> true)
                    if st == 0
                        message << "No Uncommited Local Changes."
                    else
                        message << "Uncommited Local Changes Exist."
                    end
                    oout = ""
                    oerr = ""
                    out = run("#{hgbin} outgoing -R #{r}", :stdout => oout, :stderr => oerr, :chomp=> true)
                    if out == 0
                        message << " Committed & unpushed change(s) exist."
                    end
                    iout = ""
                    ierr =""
                    incoming = run("#{hgbin} incoming -R #{r}", :stdout => iout, :stderr => ierr, :chomp=> true)
                    if incoming == 0
                        message << " Remote Changes Exist."
                    else
                        message << " No Remote Changes Exist."
                    end
                else
                    reply[:msg] = "Repository #{r} does not exist."
                    reply.fail! "Repository #{r} does not exist.", 1
                end
                reply[:msg] = message
            end
        end
    end
end