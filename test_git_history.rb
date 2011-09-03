require "test/unit"
require "git_history"

class TestGitHistory < Test::Unit::TestCase

  def setup
    ARGV[0] = "~/work/commerce-git"
    build_passing_git_commit
  end

  def build_passing_git_commit
    @commit_id = "2a170b9cf8716dd5cf1881d5df5dfe0c0f7a0815"
    @git_history = GitHistory.new(@commit_id)
  end

  def build_failing_git_commit
    @commit_id = "6cc695a5a5ebbfdb77a440e4d7552575ed93a5aa"
    @git_history = GitHistory.new(@commit_id)
  end

  def build_passing_git_commit_with_no_java_or_test_code
    @commit_id = "4dc68904fc9c78e86296948f403857c4004367cb"
    @git_history = GitHistory.new(@commit_id)
  end

  def build_passing_svn_commit
    @commit_id = "46993"
    @git_history = GitHistory.new(@commit_id)
  end

  def build_failing_svn_commit
    @commit_id = "47076"
    @git_history = GitHistory.new(@commit_id)
  end

  def build_passing_svn_commit_with_no_java_or_test_code
    @commit_id = "47113"
    @git_history = GitHistory.new(@commit_id)
  end

  def test_git_diff
    assert_not_nil(@git_history.diff)
    assert_not_equal("", @git_history.diff)
    assert_equal(22, @git_history.diff.lines.count)
  end

  def test_production_lines_of_code_calculated
    assert_equal(49, @git_history.production_lines_of_code)
  end

  def test_test_lines_of_code_calculated
    assert_equal(157, @git_history.test_lines_of_code)
  end

  def test_calculate_ratio_score
    assert_equal("3.20", "%2.2f" % @git_history.ratio_score)
  end

  def test_git_when_ratio_score_is_greater_than_zero_should_pass
    build_passing_git_commit
    assert(@git_history.pass?)
  end

  def test_git_when_ratio_score_is_zero_should_fail
    build_failing_git_commit
    assert_equal(false, @git_history.pass?)
  end

  def test_git_when_no_java_or_test_code_is_present_should_pass
    build_passing_git_commit_with_no_java_or_test_code
    assert(@git_history.pass?)
  end

  def test_svn_when_ratio_score_is_greater_than_zero_should_pass
    build_passing_svn_commit
    assert(@git_history.pass?)
  end

  def test_svn_when_ratio_score_is_zero_should_fail
    build_failing_svn_commit
    assert_equal(false, @git_history.pass?)
  end

  def test_svn_when_no_java_or_test_code_is_present_should_pass
    build_passing_svn_commit_with_no_java_or_test_code
    assert(@git_history.pass?)
  end

end
