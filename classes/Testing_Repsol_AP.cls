public class Testing_Repsol_AP {
	
    public Repsol__c rep {get;set;}
    
    public Testing_Repsol_AP(ApexPages.StandardController stdController) {
        this.rep = (Repsol__c)stdController.getRecord();
        /*rep = [SELECT Id,Nombre__c,Telefono__c,Edad__c,Equipo__c
                        FROM Repsol__c
                        WHERE Id=:rep.Id];*/
        //rep=aux;
        System.debug(this.rep);
    }
    
    public PageReference actualiza(){
        update rep;
        PageReference page = new PageReference('/'+rep.Id);
        return page;
    }
}