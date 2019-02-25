@isTest
public class TestRestrictContactByName {
    
    @isTest static void pruebaContactos() {
        Contact contacto = new Contact(LastName = 'johnson');
        insert contacto;
    }
    
    @isTest static void pruebaContactosInvalid() {
        Contact contacto = new Contact(LastName = 'INVALIDNAME');
        insert contacto;
    }
}