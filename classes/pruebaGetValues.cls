public class pruebaGetValues {
    public void metodo(){
        String strResultEmail = String.valueOf(Mails__c.getValues('Mail__c').numero__c);
    }
}