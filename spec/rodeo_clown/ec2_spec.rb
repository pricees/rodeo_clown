require_relative "../spec_helper"


describe RodeoClown::EC2 do

  before do
    RodeoClown::EC2.stub(:instances).
      and_return(double(create: true, any?: false))
  end

  it "creates an image" do
    ec2 = RodeoClown::EC2.create_instance(image_id: "foo")

    expect(ec2).to_not be_nil
  end

end
