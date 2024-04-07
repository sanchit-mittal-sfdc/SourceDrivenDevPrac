public with sharing class CTLocationTracingController 
{
    public static List<Location_Tracing__c> getVisitors(String locationId)
    {
        if(String.isBlank(locationId))
            return null;

        return [SELECT Id, Name, Person__c,Person__r.Name, Person__r.Health_Status__c, Person__r.Token__c, Location__c, Visit_Date__c 
                FROM Location_Tracing__c
                WHERE Location__c = :locationId
                ORDER BY Visit_Date__c DESC];
    }


    public static List<Location_Tracing__c> getLocationsByPersonIds(Set<Id> personIds)
    {
        if(personIds != null && personIds.size() > 0)
        {   
            return [SELECT Id, Name, Person__c, Person__r.Name, Person__r.Health_Status__c, Person__r.Token__c, Location__c, Visit_Date__c 
                    FROM Location_Tracing__c
                    WHERE Person__c IN :personIds
                    AND Visit_Date__c = Last_n_days:10];
        }
        return null;
    }



    public static List<Location_Tracing__c> getLocationsByLocationIds(Set<Id> locationIds)
    {
        if(locationIds != null && locationIds.size() > 0)
        {   
            return [SELECT Id, Name, Person__c,Person__r.Name, Person__r.Health_Status__c, Person__r.Token__c, Location__c, Visit_Date__c 
                    FROM Location_Tracing__c
                    WHERE Location__c IN :locationIds
                    AND Visit_Date__c = Last_n_days:10 
                    AND Person__r.Health_Status__c = 'Green'];
        }
        return null;
    }


    public static List<Location_Tracing__c> checkDuplicates(List<Location_Tracing__c> locationTraces)
    {
        Set<Id> locationIds = new Set<Id>();
        Set<Id> personIds = new Set<Id>();

        for(Location_Tracing__c lt : locationTraces)
        {
            locationIds.add(lt.Location__c);
            personIds.add(lt.Person__c);
        }

        //Set<String> setOfPersonIdLocationIdComb = new Set<String>();
        Map<Id, Set<Id>> mapLocationIdToPersonIds = new Map<Id, Set<Id>>();

        for(Location_Tracing__c existingLT : [SELECT Id, Name, Person__c,Person__r.Name, Person__r.Health_Status__c, Person__r.Token__c, Location__c, Visit_Date__c 
                                                FROM Location_Tracing__c
                                                WHERE Location__c IN :locationIds
                                                AND Person__c IN :personIds])
        {
            //setOfPersonIdLocationIdComb.add(String.valueOf(existingLT.Person__c) + String.valueOf(existingLT.Location__c) );    
            if( !mapLocationIdToPersonIds.containsKey(existingLT.Location__c) )
            {
                mapLocationIdToPersonIds.put( existingLT.Location__c, new Set<Id>() );
            }
            mapLocationIdToPersonIds.get(existingLT.Location__c).add(existingLT.Person__c);
        }

        if(mapLocationIdToPersonIds.size() == 0)
            return null;

        List<Location_Tracing__c> duplicates = new List<Location_Tracing__c>();
        for(Location_Tracing__c lt : locationTraces)
        {
            /*
            if( setOfPersonIdLocationIdComb.contains(String.valueOf(lt.Person__c) + String.valueOf(lt.Location__c) ))
            {
                duplicates.add(lt);
            }
            */

            if( mapLocationIdToPersonIds.containsKey(lt.Location__c) && mapLocationIdToPersonIds.get(lt.Location__c).contains(lt.Person__c) )
            {
                duplicates.add(lt);
            }
        }

        return duplicates;

    }
}