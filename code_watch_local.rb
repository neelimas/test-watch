require "git_history"

class CodeWatchLocal
  def initialize
    if GitHistory.new.pass? :
      puts "pass"
    else
      puts  "Your code does not have adequate tests."
    end
  end
end