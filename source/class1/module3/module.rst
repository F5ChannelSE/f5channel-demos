Demo 3 - BIG-IP Automation with Ansible
=======================================
Follow this script to demonstrate creation of Pools and Virtual
Servers using Ansible playbooks.

Task – Imperative - Create VS, Pool and Members using playbook variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Network Map** to confirm app110 virtual servers does not exist

   .. image:: /pictures/nmap.png

#. From VScode explorer click on ``imperative.yaml`` to examine the playbook

   .. image:: /pictures/imparative.png

#. From VScode terminal cd to redhat demo directory

   - Type ``cd ~/f5channel-demos/redhat``

#. Run the ansible playbook

   - Type ``ansible-playbook playbooks/imperatiive.yaml`` 

   .. image:: /pictures/runimparative.png

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Network Map** to confirm app110 virtual servers now exists

   .. image:: /pictures/nmapimparative.png


Task – Declarative - Create VS, Pool and Members using AS3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From VScode explorer click on ``declarative.yaml`` to examine the playbook

   .. code::

      - name: App Collection f5_bigip
        hosts: bigips
        connection: httpapi
        gather_facts: false

        vars:
          partition: ColNew
          apps:
            - name: web
              vsip: 10.1.10.100
              vsport: 80
              memberport: 8080
              poolname: web_pool
              members:
                - 10.1.20.52
                - 10.1.20.53
                - 10.1.20.55
            - name: api
              vsip: 10.1.10.100
              vsport: 3000
              memberport: 3000
              poolname: api_pool
              members:
                - 10.1.20.52
                - 10.1.20.53
                - 10.1.20.54
          provider:
            ansible_host: 10.1.1.245
            ansible_user: admin
            ansible_httpapi_password: Agility2021!
            ansible_httpapi_port: 443
            ansible_network_os: f5networks.f5_bigip.bigip
            ansible_httpapi_use_ssl: yes
            ansible_httpapi_validate_certs: no

        tasks:   

          - name: AS3
            f5networks.f5_bigip.bigip_as3_deploy:
                content: "{{ lookup('template', '../declarations/as3_templ.json') }}"


#. From VScode explorer click on ``/declarations/as3_tmpl.json`` to examine the playbook

   .. code::

      {
        "class": "AS3",
        "action": "deploy",
        "persist": true,
        "declaration": {
          "class": "ADC",
          "schemaVersion": "3.22.0",
          "id": "id",
          "label": "WebApp",
              "{{ partition }}": {
                "class": "Tenant",
                {% set comma = joiner(",") %}
                {% for app in apps %}
                {{comma()}}
                "{{ app['name'] }}": {
                  "class": "Application",
                  "{{ app['name'] }}": {
                    "class": "Service_HTTP",
                    "virtualAddresses": [ "{{app['vsip']}}" ],
                    "virtualPort": {{app['vsport']}},
                    "pool": "{{ app['poolname'] }}"
                  },
                  "{{ app['poolname'] }}": {
                    "class": "Pool",
                    "monitors": [{"use": "http_mon"}],
                    "members": [
                      {
                        "servicePort": {{ app['memberport'] }},
                        "serverAddresses": [
                          {% set comma2 = joiner(",") %}
                          {% for mem in app['members'] %}
                              {{comma2()}} "{{  mem  }}"
                          {% endfor %}
                        ]
                      }
                    ]
                  },
                  "http_mon": {
                      "class": "Monitor",
                      "monitorType": "http",
                      "receive": "I AM UP"
                  }
                }
                {% endfor %}
             }
            }
          }

#. From VScode terminal cd to redhat demo directory

   - Type ``cd ~/f5channel-demos/redhat``

#. Run the ansible playbook

   - Type ``ansible-playbook playbooks/imperatiive.yaml`` 

   .. image:: /pictures/runimparative.png

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Network Map** to confirm app110 virtual servers now exists

   .. image:: /pictures/nmapimparative.png