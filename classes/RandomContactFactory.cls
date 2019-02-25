public class RandomContactFactory {
	
    public static List<Contact> generateRandomContacts(Integer num, String cadena){
        List<Contact> listaContactos = new List<Contact>();
        for(Integer i=0 ; i<num ; i++){
            String firstName = 'test ' + i;
            Contact contacto = new Contact();
            contacto.FirstName = firstName;
            contacto.LastName = cadena;
            listaContactos.add(contacto);
        }
        return listaContactos;
    }
    
}