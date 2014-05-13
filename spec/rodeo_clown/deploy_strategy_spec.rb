require "spec_helper"

describe RodeoClown::DeployStrategy do
  describe "#tool" do

    context "mina is the strategy " do
      let(:strategy) { "mina" }
      it "returns the mina class" do
        res = RodeoClown::DeployStrategy.by_name(strategy)

        expect(res).to eq(RodeoClown::DeployStrategy::Mina)
      end
    end

    context "unknown strategy " do
      let(:strategy) { "not_mina" }
      it "raises name error" do
        expect {
          RodeoClown::DeployStrategy.by_name(strategy)
        }.to raise_error(NameError)
      end
    end
  end
end
