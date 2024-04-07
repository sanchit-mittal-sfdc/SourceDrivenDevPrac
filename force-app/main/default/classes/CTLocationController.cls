public with sharing class CTLocationController
{
    
    public static List<Location__c> getRecentStatusChanges()
    {
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c
                ORDER BY Status_Update_Date__c DESC NULLS LAST 
                LIMIT 100];
    }


    public static List<Location__c> searchLocations(String searchTerm)
    {
        if(String.isBlank(searchTerm))
            return null;

        searchTerm += '%';    
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                FROM Location__c
                WHERE Name LIKE :searchTerm OR Pincode__c LIKE :searchTerm OR Address__c LIKE :searchTerm
                ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }



    public static Location__c getLocationById(String locationId)
    {
        if(String.isBlank(locationId))
            return null;

        List<Location__c> result = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c 
                                    FROM Location__c
                                    WHERE Id = :locationId];
        if(result != null && result.size() == 1)
            return result[0];
        return null;                
    }

    /**
     * Get count of locations in each status
     * @return Map<String, Integer>
     */
    public static Map<String, Integer> getStatusCount(){
        Map<String, Integer> healthCountMap = new Map<String, Integer>();
        
        for (AggregateResult ar : [SELECT Status__c, COUNT(Id) total 
                                    FROM Location__c 
                                    GROUP BY Status__c]) {
            healthCountMap.put(String.valueOf(ar.get('Status__c')), Integer.valueOf(ar.get('total')));
        }
        return healthCountMap;
    }
}