require 'spec_helper'

describe AuthHelper do
  describe ".prechecked_remember_me" do
    let(:object) { Struct.new(:remember_me) }

    it "returns true if object's `remember_me` is nil" do
      expect(helper.prechecked_remember_me object.new(nil)).to be_true
    end

    it "returns value if object's `remember_me` isn't nil" do
      expect(helper.prechecked_remember_me object.new(false)).to be_false
      expect(helper.prechecked_remember_me object.new(true)).to be_true
    end
  end
end
