# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# Set SOURCE_DATE_EPOCH to the last git commit date for reproducible builds
# This ensures Ruby Toolbox and other tools can properly detect release dates
# See: https://github.com/rubytoolbox/rubytoolbox/issues/1653
ENV['SOURCE_DATE_EPOCH'] ||= `git log -1 --format=%cd --date=unix`.chomp

RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'

RuboCop::RakeTask.new

task default: %i[spec rubocop]
