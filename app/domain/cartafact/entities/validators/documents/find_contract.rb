module Cartafact
  module Entities
    module Validators
      module Documents
        class FindContract < Dry::Validation::Contract
          params do
            required(:authorized_subjects).array(:hash) do
              required(:id).value(:string)
              required(:type).value(:string)
            end

            required(:authorized_identity).hash do
              required(:user_id).value(:string)
              required(:system).value(:string)
            end
            required(:id).value(:string)
          end
        end
      end
    end
  end
end
