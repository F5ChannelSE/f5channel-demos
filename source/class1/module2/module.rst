Mitigating OWASP Top 10 with NGINX App Protect
==============================================

Follow this script to demonstrate mitigation of common web attacks.

Task – Explore NGINX WAF Policy Attachement
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From Firefox browser open new tab and click on NGINX bookmark to access gui
   
   .. image:: ./images/nginxdashboard.png
        :width: 500
      
#. Click on **upstream** to view juice app is deployed
   
   .. image:: ./images/upstream.png
        :width: 500


Task – Demonstrate a SQL injection vulnerability
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Attack Account Login of app protected by **nginx_waf** policy

   - From Firefox browser open new tab and access **juice3** app
   - Click on **Account** then **Login**
   - Login with ``' or 1=1; --`` for Email and random characters for Password

   .. image:: ./images/attacklogin.png
        :width: 300

   - This should result with *invalid object* error and failed login attempt

   .. image:: ./images/blockedlogin.png
        :width: 500

   - Examine logs **nap_log** to list the blocked attempts

   .. NOTE::

      Note Attack Type of SQL Injection and Rating Violation of 4 which indicates additional examination is required to reduce false positives      

#. Attack Search API of app protected by **nginx_waf** policy

   - Paste the following path in your browser's location bar 

   .. code-block:: none
      
      http://10.1.10.50/rest/products/search?q=qwert%27%29%29%20UNION%20SELECT%20id%2C%20email%2C%20password%2C%20%274%27%2C%20%275%27%2C%20%276%27%2C%20%277%27%2C%20%278%27%2C%20%279%27%20FROM%20Users--

   - The result should be a request rejected response message triggered by **nginx_waf** policy

   .. image:: ./images/supportid.png
        :width: 500

   - Copy the ``Support ID``
   - Examine **nap_log** to list the blocked attempts

   .. NOTE::

      Note Attack Type of SQL Injection and Rating Violation of 5 which indicates request most likely a threat     



