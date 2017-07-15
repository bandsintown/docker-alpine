## v1.1.1

### Improvements

 - Rename environment variable `CONSUL_ADDRESS` to `CONSUL_HTTP_ADDR` to be compliant with Consul naming
 
## v1.1.0

### Features

 - Release Alpine 3.6

## v1.0.4 (May 04, 2017) 

### Bugs

- Fix trailing carriage return  in variables registered as container environment variables

## v1.0.3 (April 20, 2017) 

### Improvements

  - Use su-exec to run consul-template with a user

## v1.0.2 (April 19, 2017) 

### Packages installed

The following package has been added:
  - `su-exec`

## v1.0.1 (April 13, 2017) 

### Environment Variables

The following environment variable have been added:
  - `EC2_IP`: Defines the IP of the EC2 instance when the container is running on AWS.
  - `CONSUL_HTTP_ADDR`: The address of Consul agent. This variable is inferred from `EC2_IP` and the Consul port is the HTTP port (`8500`). 
  It's possible to define another port with the variable `CONSUL_PORT`

  
## v1.0.0 (April 2, 2017) 

### Packages installed

The following packages are installed:
  - `curl`
  - `wget`
  - `bash` 
  - `tree`
  - `jq` (since version 3.5)
  - `bind-tools` (since version 3.5)
  - `consul` (since version 3.5)

### Services installed

The following services runs by default when a container is created:
  - `GoDNSMasq`: For DNS records resolution
  - `Consul Template`: For managing configuration

### Environment Variables

The following environment variable is set:
  - `NPROC`: Defines the number of CPU cores