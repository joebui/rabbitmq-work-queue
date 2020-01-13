#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new(host: "#{ENV['RABBITMQ']}:5672", automatically_recover: false)
connection.start

channel = connection.create_channel
mailer_queue = channel.queue('mailer', durable: true)
reporting_queue = channel.queue('reporting', durable: true)

10.times.each do |a|
  mailer_queue.publish("#{a}: New mail", persistent: true)
  puts "Sent #{a}: New mail"
  reporting_queue.publish("#{a}: New reporting data", persistent: true)
  puts "Sent #{a}: New reporting data"
end

connection.close
