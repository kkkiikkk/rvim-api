class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :year
end
