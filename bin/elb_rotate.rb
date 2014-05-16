#!/usr/bin/env ruby

require "./lib/rodeo_clown"

def get_elb
  puts "============\nRotate ELB\n=============\nChoose ELB:"
  elbs = RodeoClown::ELB.load_balancers
  n = 0
  elbs.each do |elb|
    n += 1
    puts "#{n}> #{elb.name}"
  end
  puts "Other> Exit!"

  num = gets.chomp.to_i 
  cnt = 1
  elb = nil

  elbs.each do |e|
    if cnt == num
      elb = e
      break
    end
    cnt += 1
  end

  if elb.nil?
    puts "Leaving so soon?"
    exit
  end

  RodeoClown::ELB.new elb
end

rc_elb = get_elb
puts rc_elb.instances.map &:id
