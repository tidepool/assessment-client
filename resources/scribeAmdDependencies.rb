
replace_block = '/* scribeAmdDependencies.rb Writes Here */'

dev_dir = ARGV[0] #'.devServer/'
app_dir = ARGV[1] #'app/'

search_pattern = ARGV[2]
dest = ARGV[3]
files = []
dependency_list = ''
separator = ",\n"

puts "dev dir: #{dev_dir}"
puts "app dir: #{app_dir}"
puts "Scribing dependencies that match `#{search_pattern}` into the file `#{dest}`."
puts "This file must have a comment that matches `#{replace_block}` in the position the dependencies should be scribed."

# Get all the dependencies that match the search pattern
Dir.chdir dev_dir
Dir.glob(search_pattern) do |f|
  #puts "Found: #{f}"
  files.push f
end
files.each do |f|
  dependency_list += "'#{f}'#{separator}"
end
puts ""
puts "Dependency List:"
puts dependency_list
puts ""

# Open the destination file and write the dependencies to it
Dir.chdir "../#{app_dir}"
dest_files = Dir.glob(dest)
abort("Error: Wrong number of destination files found") unless dest_files.length == 1

dest_files.each do |f|
  text = File.read(f)
  #puts text
  abort("Error: #{f} does not contain #{replace_block}") unless text.scan replace_block
  
  new_text = text.gsub replace_block, dependency_list
  #puts new_text
  File.open("../#{dev_dir}/#{f}", "w") do |file|
    file.puts new_text
  end
end

puts "Success! Scribed #{files.length} dependencies to #{app_dir}#{dest} :)"






