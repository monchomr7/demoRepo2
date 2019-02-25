public class PruebaSOQL {
    public void MiMetodo(){
        String nombreCuenta = 'Acme';
        List<Account> cuentas = [SELECT Name FROM Account WHERE name =: nombreCuenta];
        //List<Account> cuentas = [SELECT Name FROM Account WHERE Name = 'Acme'];
        List<List<sObject>> resultado = [FIND 'A=' IN ALL FIELDS RETURNING Account(name), Contact];
        List<Account> cuentasEmpiezanBa = (List<Account>)resultado[0];
        List<Contact> contactosEmpiezaBa = (List<Contact>)resultado[1];
        //Revisar esto de aqui abajo
        //SELECT Campsite__r FROM Garage_Schema__c
        //SELECT Objeto_Relacion_2__c FROM Objeto_Relacion__c
        
		//SELECT id,name (SELECT camposHijo FROM ObjetoHijo) FROM ObjetoPadre

        /*List<Contact> miLista = new List<Contact>();
        
        Contact contacto1 = new Contact();
        Contact contacto2 = new Contact();
        
        contacto1.Name = 'Pepe';
        contacto2.Name = 'Luis';
        
        miLista.add(contacto1);
        miLista.add(contacto2);
        
        insert miLista;*/
        
        //Database.[operacion](objeto/lista, boolean opt, allOrNone)
        //Database.insert(miLista, false);
    }
}