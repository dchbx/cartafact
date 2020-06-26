module Cartafact
  module Entities
    class RequestingIdentity < Dry::Struct
      transform_keys(&:to_sym)

      attribute? :authorized_subjects, Cartafact::Entities::Types::Coercible::Array
      attribute :authorized_identity, AuthorizedIdentity
    end
  end
end