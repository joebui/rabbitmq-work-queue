#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new(host: "#{ENV['RABBITMQ']}:5672", automatically_recover: false)
connection.start

channel = connection.create_channel
queue = channel.queue(ENV['QUEUE'], durable: true)

channel.prefetch(2)
puts "[*] Waiting for #{ENV['QUEUE']}"

queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
  puts " [x] Received '#{body}'"
  channel.ack(delivery_info.delivery_tag)
end
