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

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Virtual Servers** to confirm app110 virtual servers now exists

   .. image:: /pictures/nmapimparative.png

Task – Declarative - Create VS, Pool and Members using AS3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Virtual Servers** to confirm app1 virtual servers does not exist

#. From VScode terminal examine file **playbooks/app1.yaml**

   - Type ``nano playbooks/app.yaml`` and note 
   - Ctrl x to exit

#. Run this playbook.

   - Type ``ansible-playbook -e @creds.yaml --ask-vault-pass playbooks/app.yaml``

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Virtual Servers** to confirm app1 virtual servers now exists
