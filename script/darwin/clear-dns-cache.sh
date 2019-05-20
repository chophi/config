#!/bin/bash
sudo killall -HUP mDNSResponder
sudo killall mDNSResponderHelper
sudo dscacheutil -flushcache
say MacOS DNS cache has been cleared
