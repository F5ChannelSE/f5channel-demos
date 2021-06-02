Demo 1 - Mitigating OWASP Top 10 with Advanced WAF
==================================================
Follow this script to demonstrate OWASP Top 10 compliance dashboard
and mitigation of common web attacks.

#. From Firefox browser explore BIG-IP GUI **Local Traffic -> Virtual Servers** to view juice and hackazon apps are deployed
   
   .. image:: .//media/vslist.png

#. Click **Security -> Overview** to view **juice_awaf** policy attached to **juice1** virtual server and no policy attached to **juice2**
   
   .. image:: .//media/securityoverview.png

#. Click **OWASP Compliance** then **juice_awaf** to view details of OWASP Compliance rating
   
   .. image:: .//media/owaspcompliance.png


