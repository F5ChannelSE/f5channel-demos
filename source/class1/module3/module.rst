BIG-IP Automation with Ansible
==============================
Follow this script to demonstrate creation of Pools and Virtual
Servers using Ansible playbooks.

Task – Imperative - Create VS, Pool and Members using playbook variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Network Map** to confirm app110 virtual servers does not exist

   .. image:: ./images/nmap.png

#. From VScode explorer click on ``imparative.yaml`` to examine the playbook

   .. image:: ./images/imparative.png

   .. code::

      - name: App Collection f5_modules
        hosts: bigips
        connection: local
        gather_facts: false

        vars:
          app:
            partition: App110
            name: app110_vs
            vsip: 10.1.10.110
            vsport: 80
            memberport: 8080
            poolname: app110_pool
            members:
              - 10.1.20.5
              - 10.1.20.6
          state: present
          provider:
            server: 10.1.1.245
            server_port: 443
            user: admin
            password: Agility2021!
            validate_certs: false


        tasks:

          - name: Create
            block:

              - name: Create partition
                f5networks.f5_modules.bigip_partition:
                  state: "{{ state }}"
                  name: "{{ app['partition'] }}"
                  provider: "{{ provider }}"
                delegate_to: localhost

              - name: Create HTTP Monitor
                f5networks.f5_modules.bigip_monitor_http:
                  state: "{{ state }}"
                  name: http_mon
                  receive: "I AM UP"
                  partition: "{{ app['partition'] }}"
                  provider: "{{ provider }}"
                delegate_to: localhost

              - name: Create Pool
                f5networks.f5_modules.bigip_pool:
                  state: "{{ state }}"
                  name: "{{ app['poolname'] }}"
                  partition: "{{ app['partition'] }}"
                  monitors:
                    - http_mon
                  provider: "{{ provider }}"
                delegate_to: localhost

              - name: Add pool members
                f5networks.f5_modules.bigip_pool_member:
                  state: "{{ state }}"
                  pool: "{{ app['poolname'] }}"
                  partition: "{{ app['partition'] }}"
                  host: "{{ item }}"
                  port: "{{ app['memberport'] }}"
                  provider: "{{ provider }}"
                delegate_to: localhost
                loop: "{{ app['members'] }}"

              - name: Add virtual server
                f5networks.f5_modules.bigip_virtual_server:
                  state: "{{ state }}"
                  partition: "{{ app['partition'] }}"
                  name: "{{ app['name'] }}"
                  destination: "{{ app['vsip'] }}"
                  port: "{{ app['vsport'] }}"
                  pool: "{{ app['poolname'] }}"
                  profiles:
                    - http
                  provider: "{{ provider }}"
                delegate_to: localhost

            rescue: # BACKOUT LOGIC

              - set_fact:
                  state: absent

              - name: Delete virtual server
                f5networks.f5_modules.bigip_virtual_server:
                  state: "{{ state }}"
                  partition: "{{ app['partition'] }}"
                  name: "{{ app['name'] }}"
                  destination: "{{ app['vsip'] }}"
                  port: "{{ app['vsport'] }}"
                  pool: "{{ app['poolname'] }}"
                  profiles:
                    - http
                  provider: "{{ provider }}"
                delegate_to: localhost

              - name: Delete Pool
                f5networks.f5_modules.bigip_pool:
                  state: "{{ state }}"
                  name: "{{ app['poolname'] }}"
                  partition: "{{ app['partition'] }}"
                  monitors:
                    - http_mon
                  provider: "{{ provider }}"
                delegate_to: localhost

              - name: Delete Node
                f5networks.f5_modules.bigip_node:
                  state: "{{ state }}"
                  name: "{{ item }}"
                  address: "{{ item }}"
                  partition: "{{ app['partition'] }}"
                  provider: "{{ provider }}"
                delegate_to: localhost
                loop: "{{ app['members'] }}"

              - name: Delete HTTP Monitor
                f5networks.f5_modules.bigip_monitor_http:
                  state: "{{ state }}"
                  name: http_mon
                  receive: "I AM UP"
                  partition: "{{ app['partition'] }}"
                  provider: "{{ provider }}"
                delegate_to: localhost

              - name: Delete partition
                f5networks.f5_modules.bigip_partition:
                  state: "{{ state }}"
                  name: "{{ app['partition'] }}"
                  provider: "{{ provider }}"
                delegate_to: localhost


#. From VScode terminal cd to redhat demo directory

   - Type ``cd ~/f5channel-demos/redhat``

#. Run the ansible playbook

   - Type ``ansible-playbook playbooks/imparative.yaml`` 

   .. image:: ./images/runimparative.png

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Network Map** to confirm app110 virtual servers now exists

   .. image:: ./images/nmapimparative.png


Task – Declarative - Create VS, Pool and Members using AS3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**WARNING - This section is still under construction and will not work as documented.**

#. From VScode explorer click on ``declarative.yaml`` to examine the playbook

   .. code::

      - name: App Collection f5_bigip
        hosts: bigips
        connection: httpapi
        gather_facts: false

        vars:
          partition: App111
          apps:
            - name: app111_vs
              vsip: 10.1.10.111
              vsport: 80
              memberport: 80
              poolname: app111_pool
              members:
                - 10.1.20.7
                - 10.1.20.8
                - 10.1.20.9
            - name: api111_vs
              vsip: 10.1.10.111
              vsport: 8080
              memberport: 8080
              poolname: api111_pool
              members:
                - 10.1.20.7
                - 10.1.20.8
                - 10.1.20.9
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


#. Run the ansible playbook

**WARNING - This section is still under construction and will not work as documented.**
**WARNING - This section is still under construction and will not work as documented.**
**WARNING - This section is still under construction and will not work as documented.**

   - Type ``ansible-playbook playbooks/declaratiive.yaml`` 

   .. image:: /pictures/runimparative.png

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Network Map** to confirm app110 virtual servers now exists

   .. image:: /pictures/nmapimparative.png