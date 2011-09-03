require "rubygems"
require "code_watch"
require "git_history"
CodeWatch.new(ARGV[1].dup).to_file