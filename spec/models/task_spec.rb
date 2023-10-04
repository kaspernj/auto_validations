require "rails_helper"

describe Task do
  it "doesnt add validations to ignored columns" do
    max_length_validation = Task.validators_on(:name).find { |validator| validator.kind == :length }
    presence_validation = Task.validators_on(:name).find { |validator| validator.kind == :presence }
    uniqueness_validation = Task.validators_on(:name).find { |validator| validator.kind == :uniqueness }

    expect(max_length_validation).to be_nil
    expect(presence_validation).to be_nil
    expect(uniqueness_validation).to be_nil
  end
end
