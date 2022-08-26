require "rails_helper"

describe Project do
  xit "doesn't add a presence validator on name because one is already defined directly on the model" do
    name_validators = Project.validators_on(:name)

    expect(name_validators).to have_attributes(length: 1)
  end
end
