@isTest
public class AccountProcessorTest {

    @IsTest
    private static void testSendSms() {
        Account cuenta = new Account(name='test');
        insert cuenta;
        Contact contacto = new Contact(AccountId=cuenta.id, lastName='testcontacto');
        insert contacto;
        List<Id> listaCuentas = new List<Id>();
        listaCuentas.add(cuenta.Id);
        Test.startTest();
        AccountProcessor.countContacts(listaCuentas);
        Test.stopTest();
    }
    
}