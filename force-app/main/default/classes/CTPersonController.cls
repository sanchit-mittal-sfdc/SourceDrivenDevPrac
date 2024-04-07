public with sharing class CTPersonController 
{
    public static String getToken(String mobileNo)
    {
        if(String.isNotBlank(mobileNo) && mobileNo.isNumeric())
        {
            Blob val = Blob.valueOf(mobileNo);
            Blob hash = Crypto.generateDigest('MD5', val);

            return EncodingUtil.base64Encode(hash);
        }   
        return null;
    }


    public static List<Person__c> getRecentHealthChanges()
    {
        return [SELECT Id, OwnerId, Name, CreatedDate, LastModifiedDate, LastModifiedById, LastViewedDate, 
                LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c 
                ORDER BY Status_Update_Date__c DESC NULLS LAST
                LIMIT 100];
    }

    public static List<Person__c> searchPeople(String searchTerm)
    {
        if(String.isBlank(searchTerm))
            return null;

        searchTerm += '%';    
        return [SELECT Id, OwnerId, Name, CreatedDate, LastModifiedDate, LastModifiedById, LastViewedDate, 
                LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                FROM Person__c 
                WHERE Name LIKE :searchTerm OR Mobile__c LIKE :searchTerm OR Token__c LIKE :searchTerm
                ORDER BY Status_Update_Date__c DESC NULLS LAST];
    }

    public static Person__c getPersonById(String personId)
    {
        if(String.isBlank(personId))
            return null;

        List<Person__c> result = [SELECT Id, OwnerId, Name, CreatedDate, LastModifiedDate, LastModifiedById, LastViewedDate, 
                                    LastReferencedDate, Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c 
                                    FROM Person__c 
                                    WHERE Id = :personId];
        if(result != null && result.size() == 1)
            return result[0];
        return null;                
    }


    public static Map<String, Integer> getHealthStatusCount()
    {
        Map<String, Integer> mapHealthStatusToCount = new Map<String, Integer>();

        for(AggregateResult eachGroupResult : [SELECT COUNT(Id) total, Health_Status__c FROM Person__c GROUP BY Health_Status__c])
        {
            mapHealthStatusToCount.put( String.valueOf(eachGroupResult.get('Health_Status__c')), Integer.valueOf(eachGroupResult.get('total')) );
        }
        return mapHealthStatusToCount;
    }
}