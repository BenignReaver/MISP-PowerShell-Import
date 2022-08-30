#region SETTERS
$headers = @{
    'Authorization' = '<MISP_USER_API_KEY>' #API Key for user account: Eg.(svc-misp@misp.local)
    'Accept' = 'application/json'
    'Content-Type'= 'application/json'
}
 
$resource = "HTTPS://YOUR_MISP_INSTANCE_ADDRESS/attributes/restSearch"
$filepath = "YOUR_LOGRHYTHM_IMPORT_DIRECTORY"
#endregion SETTERS
 
#region SSL Ignore
if (-not ([System.Management.Automation.PSTypeName]'ServerCertificateValidationCallback').Type)
{
$certCallback = @"
    using System;
    using System.Net;
    using System.Net.Security;
    using System.Security.Cryptography.X509Certificates;
    public class ServerCertificateValidationCallback
    {
        public static void Ignore()
        {
            if(ServicePointManager.ServerCertificateValidationCallback ==null)
            {
                ServicePointManager.ServerCertificateValidationCallback +=
                    delegate
                    (
                        Object obj,
                        X509Certificate certificate,
                        X509Chain chain,
                        SslPolicyErrors errors
                    )
                    {
                        return true;
                    };
            }
        }
    }
"@
    Add-Type $certCallback
}
 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
[ServerCertificateValidationCallback]::Ignore
#endregion SSL Ignore
 
#region Domain
 
$domain_body = '{
"returnFormat":"text",
    "type":{
        "OR": ["domain"]
     }
}'
 
Invoke-RestMethod -Method POST -UseBasicParsing -Uri $resource -Headers $headers -Body $domain_body -OutFile $filepath+misp-domains.txt
#endregion Domain
 
