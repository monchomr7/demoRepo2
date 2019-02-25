public class AnimalLocator {
    public static String getAnimalNameById(Integer id){
        Http http = new Http();
		HttpRequest request = new HttpRequest();
        String url = 'https://th-apex-http-callout.herokuapp.com/animals/' + id;
		request.setEndpoint(url);
		request.setMethod('GET');
        HttpResponse response = http.send(request);
		Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());	
        
        Map<String, Object> propiedades = (Map<String, Object>) results.get('animal');
        String valor = String.valueOf(propiedades.get('name'));
        
        return valor;

    }
}