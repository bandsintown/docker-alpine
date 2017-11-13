#!/usr/bin/env bash

@test "script 'apk-install' should be present" {
  run which apk-install
  [ $status -eq 0 ]
}