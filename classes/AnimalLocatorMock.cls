@isTest
global class AnimalLocatorMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        String cadenaParametro = request.getEndpoint();
        String parametro = cadenaParametro.substring(cadenaParametro.length()-1);
        if(parametro == '1'){
            response.setBody('{"animal":{"id":1,"name":"chicken","eats":"chicken food","says":"cluck cluck"}}');
        }else if(parametro =='2'){
            response.setBody('{"animal":{"id":2,"name":"bear","eats":"berries, campers, adam seligman","says":"yum yum"}}');
        }
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        return response; 
    }
}