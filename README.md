rodeo_clown
===========

Gem to assist cycling AWS EC2 instance and images.

Grab an instance of your ELB
```ruby
elb = RodeoClown::ELB.by_name("my-elb")
```

Rotate out all of the instances, with a new image
```ruby
elb.instances.rotate
```
