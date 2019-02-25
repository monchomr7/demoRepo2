public class ContactAndLeadSearch {
    public static List<List< SObject>> searchContactsAndLeads(String cadena){
        List<List<sObject>> searchList = [FIND 'Smith' IN ALL FIELDS RETURNING Lead,Contact];
		//Account[] searchAccounts = (Account[])searchList[0];
		//Contact[] searchContacts = (Contact[])searchList[1];
        return searchList;
    }
}