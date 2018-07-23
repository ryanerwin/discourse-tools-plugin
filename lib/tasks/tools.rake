desc "Add child theme to a theme"
task "tools:add_child_theme", [:parent, :child] => [:environment] do |_, args|
  Tools.add_child_theme(args[:parent], args[:child])
end

desc "Remove child theme from a theme"
task "tools:remove_child_theme", [:parent, :child] => [:environment] do |_, args|
  Tools.remove_child_theme(args[:parent], args[:child])
end

desc "Disable users except member of group"
task "tools:disable_users", [:group, :till] => [:environment] do |_, args|
  date, time = args[:till].split(" ")

  date = date.split("-")
  time = time.split(":")

  Tools.disable_users_except_group(args[:group], Time.new(*date, *time))
end

desc "Re-enable disabled users"
task("tools:enable_users" => :environment) {
  Tools.enable_users_except_group
}
