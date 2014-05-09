require_relative "../spec_helper"


describe RodeoClown::EC2 do

  before do
    RodeoClown::EC2.stub(:instances).
      and_return(double(create: true, wait_for_status: true))
  end

  it "creates an image" do
    ec2 = RodeoClown::EC2.create_instance(image_id: "foo")

    expect(ec2).to_not be_nil
  end

  describe "#reboot" do
    it "reboots" do
      rc_ec2 = RodeoClown::EC2.new 
      rc_ec2.stub(:ec2).and_return(double(reboot: true))

      expect(rc_ec2.reboot).to be_true
    end
  end

  context "status" do

    it "is pending" do
      ec2 = RodeoClown::EC2.new(double(status: :pending))
      expect(ec2).to be_pending
    end

    it "is running" do
      ec2 = RodeoClown::EC2.new(double(status: :running))
      expect(ec2).to be_running
    end

    it "is stopped" do
      ec2 = RodeoClown::EC2.new(double(status: :stopped))
      expect(ec2).to be_stopped
    end

    it "is terminated" do
      ec2 = RodeoClown::EC2.new(double(status: :terminated))
      expect(ec2).to be_terminated
    end
  end


end
