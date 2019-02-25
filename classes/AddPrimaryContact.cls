public class AddPrimaryContact implements Queueable {
    
    private Contact contacto;
    private String estado;

    public AddPrimaryContact(Contact contactoArg, String estadoArg){
        this.contacto = contactoArg;
        this.estado = estadoArg;
    }
    
    public void execute(QueueableContext context) { 
		List<Account> listaCuentas = [SELECT Id FROM Account WHERE BillingState = :estado LIMIT 200];
        for(Account cuenta : listaCuentas){
            Contact contactoAux = contacto.clone(false,false,false,false);
            contactoAux.AccountId = cuenta.Id;
            insert contactoAux;
        }
    }
    
}