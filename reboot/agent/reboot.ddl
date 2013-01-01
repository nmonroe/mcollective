metadata    :name        => "reboot",
            :description => "reboot service for MCollective",
            :author      => "Nick Monroe",
            :license     => "GPL v2",
            :version     => "1.0",
            :url         => "https://github.com/nmonroe",
            :timeout     => 120


action "reboot", :description => "reboots the node" do
    display :always
end
