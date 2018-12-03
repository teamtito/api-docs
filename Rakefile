namespace :assets do
  task :precompile do
    sh "middleman build --build-dir='build/docs/api/v3'"
    sh "middleman build --build-dir='build/docs/api' --no-clean"
  end
end
