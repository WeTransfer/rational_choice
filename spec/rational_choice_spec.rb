require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RationalChoice" do
  it "has the necessary constants" do
    RationalChoice::CardinalityError
    RationalChoice::Dimension
    RationalChoice::ManyDimensions
  end
end
