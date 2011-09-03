class GitHistory

  attr_reader :test_lines_of_code, :production_lines_of_code, :current_commit_id, :previous_commit_id, :diff, :has_java_or_test_code

  def initialize(commit_id = nil)
    @commit_id= commit_id unless commit_id.nil?
    @has_java_or_test_code = false
    set_defaults
    get_change_list
    find_lines_of_code_added
  end

  def ratio_score
    @test_lines_of_code / @production_lines_of_code
  end

  def pass?
    if has_java_or_test_code
      return ratio_score > 0
    end
    true
  end

  def results
    puts "Prod Lines: " << "%2.0f" % @production_lines_of_code
    puts "Test Lines: " << "%2.0f" % @test_lines_of_code
    puts "Ratio Score: " << "%2.2f" % ratio_score
  end

  private

  def recent_checkin_ids
    execute "git rev-list HEAD^ --reverse --max-count=100"
  end

  def set_defaults
    @production_lines_of_code = 0
    @test_lines_of_code = 0
  end

  def get_change_list
    if @commit_id.scan(/[a-zA-Z]/).length.zero?
      @diff = execute "git log --numstat  --grep=svn\.swacorp\.com\/svn\/commerce\/trunk@#{@commit_id} | grep ^[0-9]"
    else
      @diff = execute "git show #{@commit_id} --numstat | grep ^[0-9]"
    end
  end

  def find_current_commit_id
    @commit_id = execute("git rev-parse HEAD").strip
  end

  def find_previous_commit_id
    @previous_commit_id = execute("git rev-parse HEAD^").strip
  end

  def find_lines_of_code_added
    @diff.each_line do |line|
      changed_lines = line.split[0].to_f
      if line.downcase.include? 'test'
        @test_lines_of_code += changed_lines
        @has_java_or_test_code = true
      elsif line.downcase.include? '.java'
        @production_lines_of_code += changed_lines
        @has_java_or_test_code = true
      end
    end

    @production_lines_of_code = 1 unless @production_lines_of_code.nonzero?
  end

  def execute(command, directory = ".")
    directory = ARGV.first unless ARGV.empty?
    `cd #{directory}; #{command}`
  end

end