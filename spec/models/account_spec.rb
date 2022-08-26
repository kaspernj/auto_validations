require "rails_helper"

describe Account do
  it "adds the expected number of validators to the name field" do
    validators = Account.validators_on(:name)

    expect(validators).to have_attributes(length: 3) # Presence, maxlength, uniqueness
  end

  describe "persence validations" do
    it "adds a presence validation to the name field" do
      presence_validation = Account.validators_on(:name).find { |validator| validator.kind == :presence }

      expect(presence_validation.attributes).to eq [:name]
      expect(presence_validation.options).to eq({})
    end
  end

  describe "max length validations" do
    it "adds a maxlength validation to the name field" do
      max_length_validation = Account.validators_on(:name).find { |validator| validator.kind == :length }

      expect(max_length_validation.attributes).to eq [:name]
      expect(max_length_validation.options).to eq(allow_blank: true, maximum: 255)
    end

    it "doesnt add max length validation if one is manually defined" do
      max_length_validations = Account.validators_on(:vat_number).select { |validator| validator.kind == :length }

      expect(max_length_validations).to have_attributes(length: 1)
    end
  end

  describe "uniqueness validations" do
    it "adds a uniqueness validation to the name field" do
      uniqueness_validation = Account.validators_on(:name).find { |validator| validator.kind == :uniqueness }

      expect(uniqueness_validation.attributes).to eq [:name]
      expect(uniqueness_validation.options).to eq({})
    end

    it "allows blank if any column is nullable in a unique index" do
      uniqueness_validation = Account.validators_on(:callsign).find { |validator| validator.kind == :uniqueness }

      expect(uniqueness_validation.attributes).to eq [:callsign]
      expect(uniqueness_validation.options).to eq(allow_blank: true)
    end
  end
end
