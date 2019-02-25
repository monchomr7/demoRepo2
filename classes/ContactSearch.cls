public class ContactSearch {
    public static List<Contact> searchForContacts(String lName, String cp){
        List<Contact> listaNueva = new List<Contact>();
        	listaNueva = [SELECT Id,Name FROM Contact WHERE LastName=:lName AND MailingPostalCode=:cp ];
        return listaNueva;
    }
}