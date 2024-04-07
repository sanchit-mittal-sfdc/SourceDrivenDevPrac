trigger TestObjTrigger on TestObj__c (before insert, after insert) 
{
    switch on trigger.operationType 
    {
        
        when BEFORE_INSERT
        {
            TestObjTriggerHandler.handleBeforeInsert(trigger.new);
        }
    }
}