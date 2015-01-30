#!/bin/bash
cp -R /var/www/* /wordpress
chmod -R 755 /wordpress/*
rm -rf /var/www
ln -s /wordpress /var/www