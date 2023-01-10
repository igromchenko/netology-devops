#!/usr/bin/env python3
# coding=utf-8
import pika

connection = pika.BlockingConnection(pika.ConnectionParameters('localhost'))
channel = connection.channel()
channel.queue_declare(queue='hello', durable=True)


def callback(ch, method, properties, body):
    print(f" >>> Received '{body.decode()}'")


channel.basic_consume(queue="hello", on_message_callback=callback, auto_ack=True)
channel.start_consuming()
