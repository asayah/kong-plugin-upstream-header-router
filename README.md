[![Build Status][badge-travis-image]][badge-travis-url]

kong plugin upstream header router
====================

Kong plugin to route traffic to different upstreams depending on header

#Prerequisites
The Service/Routes/Upstreams/Targets need to exist.

#usage

```shell script

# Activations are required to route to the traffic to the specifc upstream
# traffic will be routed to the activation upstream with the most common headers.

$ curl --location --request POST 'http://localhost:8001/services/mockbin/plugins' \
--header 'Content-Type: application/json' \
--data-raw '{
    "name": "upstreamrouter",
    "config": {
        "activations": [
            {
                "headers": {
                    "x-header-1": "foo",
                    "x-header-2": "foo"
                },
                "upstream": "upstream1"
            },
            {
                "headers": {
                    "x-header-1": "foo"
                },
                "upstream": "upstream2"
            }
        ]
    }
}'

```

[badge-travis-url]: https://travis-ci.org/asayah/kong-plugin/branches
[badge-travis-image]: https://travis-ci.com/asayah/kong-plugin.svg?branch=master
