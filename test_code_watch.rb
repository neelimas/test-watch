require "test/unit"
require "code_watch"

class TestCodeWatch < Test::Unit::TestCase

  def setup
    ARGV[0] = "~/work/commerce-git"
    @revision_url = "http://lfjenkins.swacorp.com/jenkins/job/Trunk_Build/4992/"
    use_passing_commit_id
  end

  def use_passing_commit_id
    @code_watch = CodeWatch.new("http://lfjenkins.swacorp.com/jenkins/job/Trunk_Build/4992/")
  end

  def use_failing_commit_id
    @code_watch = CodeWatch.new("http://lfjenkins.swacorp.com/jenkins/job/Trunk_Build/4965/")
  end

  def test_report_should_not_be_null_or_empty
    assert(!@code_watch.report.nil?)
    assert_not_equal("", @code_watch.report)
  end

  def test_revision_count_should_equal_three
    assert_equal(3, @code_watch.revisions.length)
  end

  def test_revision_status
    assert_equal(true, @code_watch.revisions[0].status)
  end

  def test_revision_number
    assert_equal("47121", @code_watch.revisions[0].revision_number)
  end

  def test_pass
    assert(@code_watch.revisions[0].pass?)
  end

  def test_aggregate_status
    assert(@code_watch.aggregate_status)
  end

  def test_build_number
    assert_equal("4992", @code_watch.build_number)
  end

  def test_to_json
    assert_equal('{"revision": "47121", "status": "pass"}', @code_watch.revisions[0].to_json(nil, nil))
  end

  def test_fail_to_json
    use_failing_commit_id
    assert_equal('{"revision": "47076", "status": "fail"}', @code_watch.revisions[0].to_json(nil, nil))
  end

  def test_fail
    use_failing_commit_id
    assert_equal(false, @code_watch.revisions[0].pass?)
  end

  def test_aggregate_fail
    use_failing_commit_id
    assert_equal("fail", @code_watch.aggregate_status)
  end

end