#!/usr/bin/env bash

# ------ DNSMasq ------

@test "service 'go-dnsmasq' should be installed" {
  run test -f /etc/services.d/go-dnsmasq/run
  [ $status -eq 0 ]
}

@test "service 'go-dnsmasq' is running" {
  status=$(ps -o pid,comm | grep go-dnsmasq 2>&1 >/dev/null;echo $?)
  [ $status -eq 0 ]
}


# ------ Consul Template ------

@test "service 'consul-template' should be installed" {
  run test -f /etc/services.d/consul-template/run
  [ $status -eq 0 ]
}

@test "service 'consul-template' is running" {
  status=$(ps -o pid,comm | grep consul-template 2>&1 >/dev/null;echo $?)
  [ $status -eq 0 ]
}

