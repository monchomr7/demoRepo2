public class AccountProcessor {

    @future
    public static void countContacts(List<Id> accountsId){
        
        List<Account> listaCuentas = [SELECT id, Number_of_Contacts__c, (SELECT id FROM Contacts) 
                                      FROM Account 
                                      WHERE Id IN :accountsId];
        
        for(Account cuenta : listaCuentas){
            Integer contadorContactos = 0;
            for(Contact contacto: cuenta.Contacts){
            	contadorContactos++;
            }
            cuenta.Number_of_Contacts__c = contadorContactos;
        }
        
        update listaCuentas;
    }
}