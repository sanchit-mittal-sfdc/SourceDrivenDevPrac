@isTest
public class SampleTestClass
{
    @isTest
    public static void unitTest1()
    {
        Contact c = new Contact('FirstName'='Harry', 'LastName'='Potter', 'EMail'='harr@test.com');
        insert c;
    }
}