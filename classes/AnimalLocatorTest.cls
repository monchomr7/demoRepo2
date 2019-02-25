@isTest
private class AnimalLocatorTest {
    @isTest static void testPostCallout() {

    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new AnimalLocatorMock()); 
    // This causes a fake response to be sent
    // from the class that implements HttpCalloutMock. 
    String response = AnimalLocator.getAnimalNameById(1);
    System.debug(response);
    response = AnimalLocator.getAnimalNameById(2);
    System.debug(response);
    //System.assertEquals('chicken',response);
    //System.assertEquals('bear',response);
	}
}