namespace :namespaced do
  namespace :custom do
    desc "Custom task"
    task :without_arguments do
      puts "Custom task"
    end

    task :no_comment do
      puts "No comment"
    end
  end
end
