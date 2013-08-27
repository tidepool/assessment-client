
replace_block = '/* scribeAmdDependencies.rb Writes Here */'

dev_dir = ARGV[0]
src_dir = ARGV[1]
static_dir = ARGV[2]

search_pattern = ARGV[3]
dest = ARGV[4]
skip_dir = ARGV[5]
files = []
dependency_list = ''
separator = ",\n"

puts "dev dir: #{dev_dir}"
puts "src dir: #{src_dir}"
puts "static dir: #{static_dir}"
puts "skipping folder: #{skip_dir}"
puts "Scribing dependencies that match `#{search_pattern}` into the file `#{dest}`."
puts "This file must have a comment that matches `#{replace_block}` in the position the dependencies should be scribed."

# Get all the dependencies that match the search pattern
Dir.chdir static_dir
#Dir.glob(search_pattern) do |filename|
Dir[search_pattern].reject{ |f| f[skip_dir] }.each do |filename|
  puts "Found: #{filename}"
  files.push filename
end
files.each do |f|
  filename = f.sub( ".js", "" ) # Remove the extension
  dependency_list += "'#{filename}'#{separator}"
end
puts ""
puts "Dependency List:"
puts dependency_list
puts ""

# Open the destination file and write the dependencies to it
Dir.chdir "../../#{src_dir}"
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

if files.length === 0
    abort 'Error, no files scribed'
else
    puts "Success! Scribed #{files.length} dependencies to #{src_dir}#{dest} :)"
end





