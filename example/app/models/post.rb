class Post
  include DataMapper::Resource
  include MerbPaginate::Finders::Datamapper
  
  property :id, Integer, :serial => true
  property :title, String
end