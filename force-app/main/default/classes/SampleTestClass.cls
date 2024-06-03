@isTest
public class SampleTestClass
{
    public static testMethod void unitTest1()
    {
        Contact c = new Contact(FirstName='Harry', LastName='Potter', EMail='harr@test.com');
        insert c;
        system.assertNotEquals(c.Id,null);
    }
}