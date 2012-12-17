metadata    :name        => "hg",
            :description => "hg service for MCollective",
            :author      => "Nick Monroe",
            :license     => "GPL v2",
            :version     => "1.0",
            :url         => "https://github.com/nmonroe",
            :timeout     => 120


action "update", :description => "does a hg pull and hg update on the repository" do
    display :always
    
    input :repo,
        :prompt => "Repository",
        :description => "the repository location",
        :type => :string,
        :validation => '.*',
        :optional => false,
        :maxlength => 130
    
    output :msg,
        :description => "message received",
        :display_as => "Message"
    
end

action "status", :description => "result of hg status on the repository" do
    display :always
    
    input :repo,
        :prompt => "Repository",
        :description => "the repository location",
        :type => :string,
        :validation => '.*',
        :optional => false,
        :maxlength => 130
    
    output :msg,
        :description => "status received",
        :display_as => "Status"
    
end
