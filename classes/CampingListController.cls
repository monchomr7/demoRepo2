public class CampingListController {
	@AuraEnabled
    public static List<Camping_Item__c> getItems() {
        // Perform isAccessible() checking first, then
        return [SELECT Id, Name, Quantity__c, Price__c, Packed__c
                FROM Camping_Item__c];
    }
    
    @AuraEnabled
    public static Camping_Item__c saveItem(Camping_Item__c item) {
        // Perform isUpdatable() checking first, then
        system.debug('RPM2');
        upsert item;
        return item;
    }
}