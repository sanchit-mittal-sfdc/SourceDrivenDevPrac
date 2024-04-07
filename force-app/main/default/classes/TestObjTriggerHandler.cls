public class TestObjTriggerHandler
{
    public static void handleBeforeInsert( List<testObj__c> newtestObj )
    {
       List<testObj__c> lst = [SELECT id, name from TestObj__c WITH SECURITY_ENFORCED];

       for(TestObj__c obj : lst)
       {
           obj.Name= 'sanchit';
       }
       update lst;

    }
}