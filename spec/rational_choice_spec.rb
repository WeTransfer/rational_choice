# frozen_string_literal: true

require File.expand_path("#{File.dirname(__FILE__)}/spec_helper")

describe "RationalChoice" do
  it "has the necessary constants" do
    expect(RationalChoice::VERSION).to be_kind_of(String)
    expect(RationalChoice::CardinalityError).to be_kind_of(Class)
    expect(RationalChoice::Dimension).to be_kind_of(Class)
    expect(RationalChoice::ManyDimensions).to be_kind_of(Class)
  end
end
