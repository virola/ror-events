namespace :data do
  task :create_events => [:environment] do
    member = Member.find(12)
    100.times do |i|
      Event.create(member_id: member, name: "title-#{i}", description: "content-#{i}", date: "2018-05-11")
    end
  end
end