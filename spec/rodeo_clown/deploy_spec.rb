require "spec_helper"

describe RodeoClown::Deploy do

  let(:instances) do
    double
  end

  context "deploying is successful" do
    before do
      RodeoClown::Deploy.stub(:before_deploy).and_return true
      RodeoClown::Deploy.stub(:deploy).and_return true
      RodeoClown::Deploy.stub(:after_deploy).and_return true
    end

    it "returns true" do
      res = RodeoClown::Deploy.on(instances)

      expect(res).to be_true
    end
  end

  context "deploying is failure" do
    before do
      RodeoClown::Deploy.stub(:before_deploy).and_return false
    end

    it "is a failure" do
      res = RodeoClown::Deploy.on(instances)

      expect(res).to be_false
    end
  end

end
