class PostSerializer
  include JSONAPI::Serializer
  attributes :title, :body, :published
  has_many :authors
end
