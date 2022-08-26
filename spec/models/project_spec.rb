require "rails_helper"

describe Project do
  it "adds the expected number of validators to the name field" do
    validators = Project.validators_on(:name)

    expect(validators).to have_attributes(length: 3) # Presence, maxlength, uniqueness
  end

  describe "presence validations" do
    it "doesn't add a presence validator on name because one is already defined directly on the model" do
      name_validators = Project.validators_on(:name).select { |validator| validator.kind == :presence }

      expect(name_validators).to have_attributes(length: 1)
    end
  end

  describe "max length validations" do
    it "adds maxlength validations" do
      presence_validation = Project.validators_on(:name).find { |validator| validator.kind == :length }

      expect(presence_validation.attributes).to eq [:name]
      expect(presence_validation.options).to eq(allow_blank: true, maximum: 120)
    end
  end

  describe "uniqueness validations" do
    it "adds a uniqueness validation to the name field" do
      uniqueness_validation = Project.validators_on(:name).find { |validator| validator.kind == :uniqueness }

      expect(uniqueness_validation.attributes).to eq [:name]
      expect(uniqueness_validation.options).to eq(scope: ["account_id"])
    end

    it "doesnt add a uniqueness validation to an index that isnt unique" do
      uniqueness_validation = Project.validators_on(:account_id).find { |validator| validator.kind == :uniqueness }

      expect(uniqueness_validation).to be nil
    end
  end
end
