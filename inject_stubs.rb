require 'xcodeproj'
project = Xcodeproj::Project.open(ARGV[0])
target = project.targets.find { |t| t.name == "TradePulse" }
raise "Target not found" unless target
group = project.main_group.find_subpath("LeanIOS", false)
raise "LeanIOS group not found" unless group
existing = group.files.find { |f| f.path == "GNStubsImpl.m" }
unless existing
  file_ref = group.new_file("GNStubsImpl.m")
  target.source_build_phase.add_file_reference(file_ref)
  puts "Added GNStubsImpl.m to project and target sources"
else
  puts "GNStubsImpl.m already in group"
end
project.save
