namespace :minitest do
  desc "Without arguments"
  task :without_arguments do
    puts "Without arguments"
  end

  desc "With arguments"
  task :with_arguments, [ :foo, :bar ] => :environment do |_, args|
    args.with_defaults(foo: "default", bar: "default")
    sleep 10

    puts "foo: #{args.foo}"
    puts "bar: #{args.bar}"
  end

  namespace :nested do
    desc "Nested without arguments"
    task :without_arguments do
      puts "Nested without arguments"
    end
  end
end
