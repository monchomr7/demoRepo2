public class maps2 {
    public List<Account> cuentas {get;set;}
    public maps2(){
        cuentas = [SELECT pais__c, icono__c, ciudad__c, Name, Id, direccion__c FROM account WHERE pais__c = 'spain'];
    }
}