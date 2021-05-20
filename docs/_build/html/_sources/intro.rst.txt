Getting Started
---------------

Please follow the instructions provided by the instructor to start your
lab and access your jump host.

.. NOTE::
	 All work for this lab will be performed exclusively from the Windows
	 jumphost. No installation or interaction with your local system is
	 required.

Lab Topology
~~~~~~~~~~~~

The following components have been included in your lab environment:

- 1 BIG-IP virtual appliances (16.0.x)
- 1 Ubuntu client server running:

  - vscode

  - firefox

- 1 Ubuntu application server running:

  - OWASP Juice Shop (App port 80 & 81) 

  - Hackazon (App port 8080 & 8081)

  - NGINX Demo App (App port 82 & 83)


Network Addressing
^^^^^^^^^^^^^^^^^^

The following table lists VLANS, IP Addresses and Credentials for all
components:

.. list-table::
    :widths: 20 20 20 20 20
    :header-rows: 1
    :stub-columns: 0

    * - **Component**
      - **Management**
      - **Internal**
      - **External**
      - **Additional IP**
    * - Client Server
      - 10.1.1.2
      - 10.1.10.2
      - 10.1.20.2
      - none
    * - App Server
      - 10.1.1.3
      - 10.1.10.3
      - 10.1.20.3
      - none
    * - BIG-IP1
      - 10.1.1.245
      - 10.1.10.245
      - 10.1.20.245
      - none


Access Demo Environment
~~~~~~~~~~~~~~~~~~~~~~~

#. Click the **ACCESS** dropdown on the **client** ubuntu server, then click **VS CODE**. We will use this for making edits to the terraform files

   .. image:: /_static/vscode.png
      :scale: 40 %

#. Open a **New Terminal** in **VS Code** to run commands in this lab

   .. image:: /_static/newterm.png
      :scale: 40 %

#. Update **Terraform** in **VS Code** to version 13.x

   - run ``terraform -version`` in **VS Code terminal** on bottom of window
   - if terraform version is **v0.13.2** then **skip to step 7** else continue with upgrade process
   - ``wget --quiet --continue --show-progress https://releases.hashicorp.com/terraform/0.13.2/terraform_0.13.2_linux_amd64.zip``
   - ``sudo unzip terraform_0.13.2_linux_amd64.zip``
   - ``sudo mv terraform /usr/local/bin``
   - ``terraform -version`` to confirm **v0.13.2**
   - ``rm terraform_0.13.2_linux_amd64.zip``

   .. image:: /_static/tfupdate.png
      :scale: 40 %

#. Under components, click the access dropdown on the **client ubuntu** server, then click **Firefox**

   .. image:: /_static/firefox.png
      :scale: 25 %

   .. image:: /_static/firefox1.png
      :scale: 25 %

#. Login to BIG-IP management interface (https://10.1.1.6) admin : F5d3vops

   .. NOTE::
      Ctrl+c and Ctrl+v does not work with the firefox web instance.  You must paste into firefox cliboard and submit, then rtclk paste to paste as shown in the images below

   .. image:: /_static/clipboard.png
      :scale: 25 %

   .. image:: /_static/paste.png
      :scale: 25 %
