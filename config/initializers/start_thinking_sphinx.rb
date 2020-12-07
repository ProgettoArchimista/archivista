# avvio automatico di ThinkingSphinx
unless Rails.rake?
  Archiweb::Application.load_tasks
  Rake::Task['ts:stop'].invoke
  Rake::Task['ts:rebuild'].invoke
end
