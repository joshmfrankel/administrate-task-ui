namespace :error do
  desc "Error task"
  task :raised do
    raise "Error task"
  end
end
