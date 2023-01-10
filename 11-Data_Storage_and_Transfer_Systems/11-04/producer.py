#!/usr/bin/env python3
# coding=utf-8
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()
channel.queue_declare(queue='hello', durable=True)
channel.basic_publish(exchange='', routing_key='hello', body=b'Hello, World!')
print(" <<< Sent %r" % 'Hello, World!')
connection.close()
