Demo 1 - Mitigating OWASP Top 10 with Advanced WAF
==================================================
Follow this script to demonstrate OWASP Top 10 compliance dashboard
and mitigation of common web attacks.

Task – Explore BIG-IP AWAF Policy Attachement
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Virtual Servers** to view juice and hackazon apps are deployed
   
   .. image:: ./images/vslist.png

#. Click **Security -> Overview** to view **juice_awaf** policy attached to **juice1** virtual server and no policy attached to **juice2**
   
   .. image:: ./images/securityoverview.png

#. Click **OWASP Compliance** then **juice_awaf** to view details of OWASP Compliance rating
   
   .. image:: ./images/owaspcompliance.png

   .. NOTE::

      Notice A1 Injection and A7 Cross-site Scripting (XSS) have 100% compliance

Task – Demonstrate a SQL injection vulnerability
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. Attack Account Login of unprotected app

   - From Firefox browser open new tab and access **juice2** app
   - Click on **Account** then **Login**
   - Login with *\' or 1=1; \-\-* for Email and random characters for Password

   .. image:: ./images/attacklogin.png

   - Review the successful login as *admin*

   .. image:: ./images/successlogin.png

#. Attack Search API or unprotected app

   - Paste the following path in your browser's location bar 

   .. code-block:: none
      
      https://10.1.10.146/rest/products/search?q=qwert%27%29%29%20UNION%20SELECT%20id%2C%20email%2C%20password%2C%20%274%27%2C%20%275%27%2C%20%276%27%2C%20%277%27%2C%20%278%27%2C%20%279%27%20FROM%20Users--

   - The result should be a list of all the users in the database including their hashed passwords.

   .. image:: ./images/juice_shop_users.png

#. Attack Account Login of app protected by **juice_awaf** policy

   - From Firefox browser open new tab and access **juice1** app
   - Click on **Account** then **Login**
   - Login with *\' or 1=1; \-\-* for Email and random characters for Password

   .. image:: ./images/attacklogin.png

   - This should result with *invalid object* error and failed login attempt

   .. image:: ./images/blockedlogin.png

   - Click on BIG-IP GUI **Security->Event Logs->Application->Request** to list the blocked attempts
   - Click on the ``login blocked attempt`` to reveal the details

   .. image:: ./images/sqllogin.png

   .. NOTE::

      Note Attack Type of SQL Injection and Rating Violation of 4 which indicates additional examination is required to reduce false positives      

#. Attack Search API of app protected by **juice_awaf** policy

   - Paste the following path in your browser's location bar 

   .. code-block:: none
      
      https://10.1.10.145/rest/products/search?q=qwert%27%29%29%20UNION%20SELECT%20id%2C%20email%2C%20password%2C%20%274%27%2C%20%275%27%2C%20%276%27%2C%20%277%27%2C%20%278%27%2C%20%279%27%20FROM%20Users--

   - The result should be a request rejected response message triggered by **juice_awaf** policy

   .. image:: ./images/apiblockpage.png

   - Copy the ``Support ID``
   - Click on BIG-IP GUI **Security->Event Logs->Application->Request** to list the blocked attempts
   - Click on **filter** icon and paste ``Support ID`` then **Apply Filter** to reveal details of the blocked event

   .. image:: ./images/apifilter.png
   .. image:: ./images/sqlapi.png

   .. NOTE::

      Note Attack Type of SQL Injection and Rating Violation of 5 which indicates request most likely a threat     



Task Demonstrate a server side cross site scripting (XSS) vulnerability
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. From Firefox browser select **Juice1 tab** or open new tab and select **Juice1** from favorites to access protected Juice Shop

   .. image:: ./images/juice1.png

#. Visit the About page so you can see that it hasn't been hacked yet by clicking on the hamburger menu in the top left corner of the page:

   .. image:: ./images/hamburger_menu.png

#. click on **About Us**.

   .. image:: ./images/aboutus_menu.png

   - You should see a bunch of lorem ipsum text and a slider of customer feedback entries retrieved from the database.

   .. image:: ./images/aboutus_page.png

#. We will insert our cross site scripting hack into the database via the Customer Feedback form. Click on the hamburger menu again and then click on **Customer Feedback**.

   .. image:: ./images/customer_feedback.png
   
#. In the comment area paste the following:

   .. code-block:: none

      <<script>FUD</script>iframe allow="autoplay" src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/1030254214&auto_play=true>

#. Then, choose any amount of stars for the rating and answer the math challenge and then click Submit.

   .. image:: ./images/xss_cust_feedback_form.png

#. Now head back over to the About page by clicking on the hamburger menu and then clicking on About. You should hear a jingle about the Juice Shop.