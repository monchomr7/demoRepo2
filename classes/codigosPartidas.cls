public class codigosPartidas {
    
    //private static String body;
    public static List<Resultado> listaResultados {get; set;}
    public static list<String> listaGremios {get; set;}
    public static List<string> listaPartidasPorGremio {get; set;}
    public static String gremioSeleccionado {get; set;}
    public static String partidaSeleccionada {get; set;}
    public String temp {get; set;}
    public String temp1 {get; set;}
    
    public class Resultado implements Comparable{
        public String idPartida = '';
        public String codigoPartida = '';
        public String codigoGremio = '';
        public String descripcion = '';
        
        public Integer compareTo(Object compareTo) {
            Resultado compareToRes = (Resultado)compareTo;
            
            Integer returnValue = 0;
            if (codigoPartida > compareToRes.codigoPartida) {
                returnValue = 1;
            } else if (codigoPartida < compareToRes.codigoPartida) {
                returnValue = -1;
            }
            return returnValue;       
        }
    }
    
    public codigosPartidas(){
        consultaCodigos('507508', null);
        system.debug('Partidas' + listaResultados);
    }
    
    public static void consultaCodigos(String procedencia, String gremio){
        
        //List<Resultado> listaResultados = new List<Resultado>();
        Resultado res = new Resultado();
    	Http http = new Http();
        HttpRequest request = new HttpRequest();
        //request.setEndPoint('https://homeservetest.bigmachines.com/rest/v1/customOriginCode?q={guildcode:{$eq:\'44\'}}');
        String endPoint = 'https://homeservetest.bigmachines.com/rest/v1/customOriginCode?q={origincode:{$eq:';
        endPoint += procedencia;
        endPoint += '}}';
        
        //request.setEndPoint('https://homeservetest.bigmachines.com/rest/v1/customOriginCode?q={$and:[{origincode:{$eq:' + procedencia + '}},{guildcode:{$eq:\'3\'}}]}');
        request.setEndPoint(endPoint);
        system.debug(request.getEndpoint());
        request.setHeader('content-type','application/json');
        request.setMethod('GET');
        request.setHeader('Authorization', 'Basic b25saW5lQm9va2luZ0FwaVVzZXI6TWFyem9fMjAxOA==');
        //request.setTimeout(Integer.valueOf(ws_CASV.TimeOut__c));
        
        HttpResponse response;
        response = http.send(request);
        system.debug('verResponse: ' + response);
        system.debug('verCuerpo: ' + response.getBody());
        //return res;
        
        JSONParser parser = JSON.createParser(response.getBody());
		listaResultados = analizarRespuestaConsultaCodigos(parser);
        system.debug('listaResultados(' + listaResultados.size() + '): ' + listaResultados);
        rellenaGremios();
        system.debug('listaGremios(' + listaGremios.size() + '): ' + listaGremios);
        //creaPartidas(listaResultados);
    }
    
    private static void rellenaGremios(){
        listaGremios = new List<String>();
        for(Resultado res : listaResultados){
            if(!listaGremios.contains(res.codigoGremio)){
            	listaGremios.add(res.codigoGremio);
            }
        }
    }
    
    private static List<Resultado> analizarRespuestaConsultaCodigos(JSONParser response){
        Resultado res = new Resultado();
        List<Resultado> lista = new List<Resultado>();
		if (response != null){
			while(response.nextToken() != null){
				if('id'.equals(response.getText())){
					response.nextToken();
					res.idPartida = response.getText();
				}
                if('guildcode'.equals(response.getText())){
					response.nextToken();
					res.codigoGremio = response.getText();
				}
				if('homeserveproductcode'.equals(response.getText())){
					response.nextToken();
					res.codigoPartida = response.getText();
                    lista.add(res);
                    res = new Resultado();
				}
			}
		}
        return lista;
    }
    
    public static void creaPartidas(List<Resultado> lista){
        System.debug('RPM gremio seleccionado: ' + gremioSeleccionado);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endPoint = 'https://homeservetest.bigmachines.com//rest/v3/commerceDocumentsOraclecpqo_bmClone_1Transaction';
        
        String body = '{"transactionLine": {"items": [';
        for(Resultado res : lista){
            body += '{"_part_number":"' + res.codigoPartida + '"},';
        }        
        body = body.substring(0, body.length()-1);
        //body += '{"_part_number":"ABMT8"}';
        body += ']}}';
        
        request.setEndpoint(endPoint);
        request.setMethod('POST');
        request.setHeader('content-type','application/json');
        request.setHeader('Authorization', 'Basic b25saW5lQm9va2luZ0FwaVVzZXI6TWFyem9fMjAxOA==');
        request.setBody(body);
		
        HttpResponse response;
        response = http.send(request);
        system.debug('verResponse2: ' + response);
        system.debug('verCuerpo2: ' + response.getBody());
        
        JSONParser parser = JSON.createParser(response.getBody());
        analizarRespuestaCrearPartidas(parser);
    }
    
    private static void analizarRespuestaCrearPartidas(JSONParser response){
        //Resultado res = new Resultado();
        // List<Resultado> lista = new List<Resultado>();
        if (response != null){
            String codigoPart;
            String descrip;
            while(response.nextToken() != null){
                if('_part_display_number'.equals(response.getText())){
                    response.nextToken();
                    codigoPart = response.getText();
                }
                if('displayedItemName_l'.equals(response.getText())){
                    response.nextToken();
                    descrip = response.getText();
                    for(Resultado res : listaResultados){
                        if(res.codigoPartida == codigoPart){
                            res.descripcion = descrip;
                        }
                    } 
                }
                
            }
        }
        listaResultados.sort();
        for(Resultado res : listaResultados){
            System.debug(res);
        }
    }
    
    public List<SelectOption> getItemsGremios() {
        system.debug('RPM gS: ' + gremioSeleccionado);
        if(gremioSeleccionado != null){
            consultaCodigos('507508', gremioSeleccionado);
        }else{
            consultaCodigos('507508', null);
        }
        
        system.debug('Gremios.' + listaResultados);
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('-','Seleccione Gremio'));
        if(listaGremios != null){
            for(String gremio : listaGremios){
                options.add(new SelectOption(gremio,gremio));
            }
        }
        return options;
    }
    
    public void filtraPartidas(){
        //consultaCodigos('507508');
        creaPartidas(listaResultados);
        listaPartidasPorGremio = new List<string>();
        system.debug('LLega' + gremioSeleccionado);
        for(Resultado res : listaResultados){
            system.debug('LLega2 ' + res);
            if(gremioSeleccionado == res.codigoGremio){
                listaPartidasPorGremio.add(res.descripcion);
            }
        }
        system.debug('LLega3 ' + listaPartidasPorGremio);
        //return null;
    }
    
    public List<SelectOption> getItemsPartidas() {
        //consultaCodigos('507508');
        //listaPartidasPorGremio = new List<string>();
        List<SelectOption> options = new List<SelectOption>();
        if(listaPartidasPorGremio != null){
            for(String partida : listaPartidasPorGremio){
                options.add(new SelectOption(partida,partida));
            }
        }
        return options;
    }
      

}