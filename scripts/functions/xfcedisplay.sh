#!/bin/bash

monitor=$(grep -o 'Output .* connected' /var/log/Xorg.0.log | head -n 1)
echo ${monitor:7:-10}
