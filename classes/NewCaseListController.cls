public class NewCaseListController {
    public List<Case> getNewCases(){
        List<Case> miLista = new List<Case>();
        miLista = [SELECT Id,CaseNumber FROM Case WHERE Status='New' ];
        return miLista;
    }
}