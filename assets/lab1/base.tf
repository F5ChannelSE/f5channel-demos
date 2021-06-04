{
    "class": "AS3",
    "action": "deploy",
    "persist": true,
    "declaration": {
        "class": "ADC",
        "schemaVersion": "3.0.0",
        "id": "urn:uuid:33045210-3ab8-4636-9b2a-c98d22ab915d",
        "label": "Sample 1",
        "remark": "Simple HTTP Service with Round-Robin Load Balancing",
        "Common": {
            "class": "Tenant",
            "Shared": {
                "class": "Application",
                "template": "shared",
                "hackazon1": {
                    "class": "Service_HTTPS",
                    "redirect80": false,
                    "virtualPort": 443,
                    "virtualAddresses": [
                        "10.1.10.20"
                    ],
                    "pool": "hackazon1_pool",
                    "serverTLS": "webtls"
                },
                "hackazon1_pool": {
                    "class": "Pool",
                    "monitors": [
                        "http"
                    ],
                    "members": [
                        {
                            "servicePort": 8080,
                            "serverAddresses": [
                                "10.1.20.3",
                                "10.1.20.4"
                            ]
                        }
                    ]
                },
                "webtls": {
                    "class": "TLS_Server",
                    "certificates": [{
                       "certificate": "webcert"
                    }]
                },
                "webcert": {
                    "class": "Certificate",
                    "remark": "using default",
                    "certificate": {"bigip":"/Common/default.crt"},
                    "privateKey": {"bigip":"/Common/default.key"}
                },              
                "hackazon2": {
                    "class": "Service_HTTPS",
                    "redirect80": false,
                    "virtualPort": 443,
                    "virtualAddresses": [
                        "10.1.10.21"
                    ],
                    "pool": "hackazon2_pool",
                    "serverTLS": "webtls"
                },
                "hackazon2_pool": {
                    "class": "Pool",
                    "monitors": [
                        "http"
                    ],
                    "members": [
                        {
                            "servicePort": 8081,
                            "serverAddresses": [
                                "10.1.20.3",
                                "10.1.20.4"
                            ]
                        }
                    ]
                },
                "webtls": {
                    "class": "TLS_Server",
                    "certificates": [{
                       "certificate": "webcert"
                    }]
                },
                "webcert": {
                    "class": "Certificate",
                    "remark": "using default",
                    "certificate": {"bigip":"/Common/default.crt"},
                    "privateKey": {"bigip":"/Common/default.key"}
                },
                "juice1": {
                    "class": "Service_HTTPS",
                    "redirect80": false,
                    "virtualPort": 443,
                    "virtualAddresses": [
                        "10.1.10.145"
                    ],
                    "pool": "juice1_pool",
                    "policyWAF": {"use": "juice_awaf"},
                    "securityLogProfiles": [{ "use": "secLogLocal"}],
                    "serverTLS": "webtls"
                },
                "juice1_pool": {
                    "class": "Pool",
                    "monitors": [
                        "http"
                    ],
                    "members": [
                        {
                            "servicePort": 80,
                            "serverAddresses": [
                                "10.1.20.3",
                                "10.1.20.4"
                            ]
                        }
                    ]
                },
                "webtls": {
                    "class": "TLS_Server",
                    "certificates": [{
                       "certificate": "webcert"
                    }]
                },
                "webcert": {
                    "class": "Certificate",
                    "remark": "using default",
                    "certificate": {"bigip":"/Common/default.crt"},
                    "privateKey": {"bigip":"/Common/default.key"}
                },
                "juice_awaf": {
                    "class": "WAF_Policy",
                    "ignoreChanges": false,
                    "url": "https://raw.githubusercontent.com/gotspam/f5-lab-days-hashi-basics/master/assets/lab3/owaspwaf.xml"
                 },
                 "secLogLocal": {
                    "class": "Security_Log_Profile",
                    "application": {
                        "storageFilter": {
                            "logicalOperation": "and",
                            "requestType": "all",
                            "responseCodes": [
                                "100",
                                "200",
                                "300",
                                "400"
                            ],
                            "protocols": [
                                "https",
                                "ws",
                                "http"
                            ],
                            "httpMethods": [
                                "ACL",
                                "GET",
                                "POLL",
                                "POST"
                            ]
                        }
                    }
                 },
                "juice2": {
                    "class": "Service_HTTPS",
                    "redirect80": false,
                    "virtualPort": 443,
                    "virtualAddresses": [
                        "10.1.10.146"
                    ],
                    "pool": "juice2_pool",
                    "serverTLS": "webtls"
                },
                "juice2_pool": {
                    "class": "Pool",
                    "monitors": [
                        "http"
                    ],
                    "members": [
                        {
                            "servicePort": 81,
                            "serverAddresses": [
                                "10.1.20.3",
                                "10.1.20.4"
                            ]
                        }
                    ]
                },
                "webtls": {
                    "class": "TLS_Server",
                    "certificates": [{
                       "certificate": "webcert"
                    }]
                },
                "webcert": {
                    "class": "Certificate",
                    "remark": "using default",
                    "certificate": {"bigip":"/Common/default.crt"},
                    "privateKey": {"bigip":"/Common/default.key"}
                }
            }
        }
    }
}