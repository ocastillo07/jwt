class AuthorSerializer
  include JSONAPI::Serializer
  attributes :name, :email, :score
  belongs_to :post
end
