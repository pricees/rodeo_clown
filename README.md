rodeo_clown
===========

Gem to assist cycling AWS EC2 instance and images.

Grab an instance of your ELB
```ruby
elb = RodeoClown::ELB.by_name("my-elb")
```

Rotate new instances into load balancer
```ruby
elb.instances.rotate
```

Rotate new instances into load balancer, with a new image
```ruby
elb.instances.rotate(image_id: "ami-1234567a")
```
