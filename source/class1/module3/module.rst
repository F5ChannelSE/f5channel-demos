Demo 3 - BIG-IP Automation with Ansible
=======================================
Follow this script to demonstrate creation of Pools and Virtual
Servers using Ansible playbooks.

Task – Imperative - Create VS, Pool and Members using playbook variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Virtual Servers** to confirm app110 virtual servers does not exist

#. From VScode explorer click on ``imperative.yaml`` to examine the playbook

#. From VScode terminal cd to ``~/f5channel-demos/redhat``

#. Run the ansible playbook

   - Type ``ansible-playbook playbooks/imperatiive.yaml`` 

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Virtual Servers** to confirm app110 virtual servers now exists

Task – Declarative - Create VS, Pool and Members using AS3
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Virtual Servers** to confirm app1 virtual servers does not exist

#. From VScode terminal examine file **playbooks/app1.yaml**

   - Type ``nano playbooks/app.yaml`` and note 
   - Ctrl x to exit

#. Run this playbook.

   - Type ``ansible-playbook -e @creds.yaml --ask-vault-pass playbooks/app.yaml``

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Virtual Servers** to confirm app1 virtual servers now exists
