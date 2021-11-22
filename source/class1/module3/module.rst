BIG-IP Automation with Ansible
==============================
Follow this script to demonstrate creation of Pools and Virtual
Servers using Ansible playbooks.

Task – Imperative - Create VS, Pool and Members using playbook variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Network Map** to confirm app110 virtual servers does not exist

   .. image:: ./images/nmap.png

#. From VScode explorer click on ``redhat->playbooks->imparative.yaml`` to examine the playbook

   .. image:: ./images/imparative.png

   .. code::

      - name: App Collection f5_modules
        hosts: bigips
        connection: local
        gather_facts: false

        vars:
          app:
            partition: App120
            name: app120
            vsip: 10.1.10.110
            vsport: 80
            memberport: 8080
            poolname: app120_pool
            members:
              - 10.1.20.8
              - 10.1.20.9
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

   .. image:: ./images/nmapaimparative.png

#. Run the ansible playbook to remove

   - Type ``ansible-playbook playbooks/imparative.yaml -e state="absent"`` 

#. From Firefox browser refresh BIG-IP GUI **Local Traffic -> Network Map** to confirm app110 virtual server is removed


Task – Declarative - Create VS, Pool and Members using AS3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
**This section is under construction - AS3 playbook coming soon**

