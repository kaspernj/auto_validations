require "rails_helper"

describe Account do
  it "adds the expected number of validators to the name field" do
    validators = Account.validators_on(:name)

    expect(validators).to have_attributes(length: 1)
  end

  it "adds a presence validation to the name field" do
    presence_validation = Account.validators_on(:name).find { |validator| validator.is_a?(ActiveRecord::Validations::PresenceValidator) }

    expect(presence_validation.attributes).to eq [:name]
    expect(presence_validation.options).to eq({})
  end
end
