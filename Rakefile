require "minitest/test_task"

Minitest::TestTask.create :test do |t|
  t.test_globs = ["test/**/*_spec.rb"]
end

task default: :test
