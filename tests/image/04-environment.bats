@test "environment variable 'NPROC' is set" {
  run test -n "${NPROC}"
  [ $status -eq 0 ]
}

@test "environment variable 'CONSUL_HTTP_ADDR' is set" {
  run test -n "${CONSUL_HTTP_ADDR}"
  [ $status -eq 0 ]
}
