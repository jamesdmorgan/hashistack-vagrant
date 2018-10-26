job "nginx" {
	region = "vagrant"

	datacenters = ["dc1"]

	constraint {
		attribute = "${attr.kernel.name}"
		value = "linux"
	}

	update {
		stagger = "10s"
		max_parallel = 1
	}

	group "nginx" {

		restart {
			attempts = 10
			interval = "5m"
			delay = "25s"
			mode = "delay"
		}

		task "nginx" {
			driver = "docker"

			config {
				image = "nginx:latest"
				port_map {
					http = 80
				}

				volumes = [
					"/var/www:/usr/share/nginx/html"
				]
			}


			service {
				name = "nginx"
				tags = ["urlprefix-nginx.hashistack.vagrant/"]
				port = "http"
				check {
					name = "alive"
					type = "http"
					interval = "10s"
					timeout = "2s"
					path = "/"
					protocol = "http"
				}
			}

			env {
				NOMAD_ENABLE = 1
				NOMAD_ADDR = "http://nomad.service.consul:4646"
				CONSUL_ENABLE = 1
				CONSUL_ADDR = "172.16.0.2:8500"
			}

			resources {
				cpu = 128
				memory = 128
				network {
					mbits = 1
					port "http" {
						static = "8080"
					}
				}
			}
		}
	}
}
