trigger PersonTrigger on Person__c (before insert)
{
    system.debug('Inside trigger , checking StaticVariablesClass.isRunOnce='+StaticVariablesClass.isRunOnce);
    if(!StaticVariablesClass.isRunOnce)
    {
        StaticVariablesClass.isRunOnce = true;
        system.debug('trigger size is'+trigger.size);
        system.debug('Trigger PersonTrigger called at '+system.now() +' with trigger.size as'+trigger.size);
        
        
        integer i=1;
        
        for(Person__c p : trigger.new)
        {
            p.name += i;
            i++;
        }
    }
}