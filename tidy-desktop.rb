#!/usr/bin/env ruby
# chmod a+x tidy-desktop.rb
require 'fileutils'
include FileUtils

require '/Users/benwiseley/dev/tidy-desktop//tidy_desktop_vars'
include TidyDesktopVars

# create old and old yyyy-mm-dd folder if they don't exist
mkdir_p(OLD_DIR)

# debug
touch File.join(DESKTOP_DIR, "aaa-#{TIME}.txt") if DEBUG

files = Dir[File.join(DESKTOP_DIR, LS_PATTERN)]

# create old yyyy-mm-dd sub folder if it doesn't exist
mkdir_p(File.join(OLD_DIR, OLD_DIR_DAY_FOLDER)) if files

files.each do |file|
  fname = File.basename(file)
  fdest = File.join(OLD_DIR, OLD_DIR_DAY_FOLDER, fname)

  # check time
  st = File.stat(file)
  next unless st.mtime < (TIME - (FILE_AGE_MIN * 60))

  if File.exist?(fdest) # add time to filename
    fname_no_ext = File.basename(fname, File.extname(fname))
    fdest =
      File.join(OLD_DIR,
                OLD_DIR_DAY_FOLDER,
                "#{fname_no_ext}-#{TIME_STR}#{File.extname(fname)}")
  end
  if DEBUG
    cp(file, fdest)
  else
    mv(file, fdest)
  end
  puts fdest
end

puts "#{files.size} moved at #{Time.now}"
