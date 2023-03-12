public with sharing class DashboardRefreshInvocable {

        /* 
        Invocable action to force refresh a dashboard via Flow
        when a defined action is taken.
        Takes an input of a dashboard id
         */
    
        @InvocableMethod(label='Refresh Dashboard')
        public static void RefreshDashboard(List<String> DashboardIds) {

            // Create batch
            List<String> dashBatch = new List<String>();
            List<List<String>> batches = new List<List<String>>();

            Integer batchSize = limits.getLimitCallouts();

            for (String dashboardId : dashboardIds) {
                // Check batch size, if full add to list
                if (dashBatch.size() == batchSize) {
                    batches.add(dashBatch);
                    dashBatch = new List<String>();
                }
                dashBatch.add(dashboardId);
            }

        // Add the final batch
        batches.add(dashBatch);

        // Send each batch to the callout
        for(List<String> batch : batches) {
            refreshDashboards(batch, userInfo.getSessionId());

        }

    }

    // Use @future due to callout required to use reporting REST API
    // TO DO: Add error handling
    @future(callout=true)
    public static void refreshDashboards(List<String> dashboardIds, String sessionId) {

    String paramValue = UserInfo.getOrganizationId()+''+UserInfo.getSessionId().substring(15);

        for(String dashId : dashboardIds) {
            String reqUrl = '/services/data/v33.0/analytics/dashboards/' + dashId;
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + reqUrl);
            req.setMethod('PUT');
            req.setHeader('Authorization', 'OAuth ' + sessionId);
            req.setBody('{}');
            system.debug(req);

            HttpResponse res = http.send(req);
            String output = res.getBody();
            System.debug(output);
        }
    }
}