namespace :solr do
  desc 'Drops index and recreates it again'
  #TODO rework to use Game
  task reindex: :environment do
    #Event.solr.delete_index
    #Event.each do |e|
      #Event.solr.add(e.solr_index_data)
    #end
  end
end
