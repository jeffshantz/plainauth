guard_rspec_opts = {
  bundler: false,
  notification: true,
  cli: '--color --format documentation --fail-fast --tag ~slow:true --order default',
  all_after_pass: false,
  all_on_start: false
}

guard :rspec, guard_rspec_opts do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

