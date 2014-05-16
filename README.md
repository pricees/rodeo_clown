```
              _
            _( )_
            (_ O _)
              (_)  
    _________/_    
    \      / /    
sK   )=====@=(   Tp!
____/_________\____
    | /^\ /^\ |    
   _| \0/_\0/ |_  
  (_  _ (_) _  _)  
    \( \___/ )/    
RAiSE\\\___/// 2o14!
  ,-._\\___//_,-.  
  |* *`-._,-' * |  
  | * * (_)* * *|  
  |* _,-' `-.*  |  
   `-'        `-'
```



rodeo_clown
===========

Gem to assist cycling AWS EC2 instance and images.

Grab an instance of your ELB
```ruby
elb = RodeoClown::ELB.by_name("my-elb")
```
Rotate instances by tag values
```ruby
elb.rotate("myapp_v1" => "myapp_v2")
```

Rotate new instances into load balancer
```ruby
elb.instances.rotate
```

Rotate new instances into load balancer, with a new image
```ruby
elb.instances.rotate(image_id: "ami-1234567a")
```

Return array of ec2 instances by tags
```ruby
RodeoClown::EC2.by_tags "app" => "foo", "ver" => "1.2"
```

Build instances from YAML (see examples/ranch_hands.yml)
```
  lets_dance /path/to/ranch_hands.yml www
```
More to come!
