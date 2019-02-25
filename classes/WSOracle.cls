public class WSOracle {
    
    public static List<String> pruebaUsers(String user, String login, String password){
        
        //Configuramos el mensaje xml del request 
        String body = '<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:inf="https://infinity.telefonica.com">'+
   			'<soapenv:Header>'+
   				'<wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd" 	xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
					'<wsse:UsernameToken xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd">'+
						'<wsse:Username>'+ login +'</wsse:Username>'+
						'<wsse:Password Type="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-username-token-profile-1.0#PasswordText">'+ password +'</wsse:Password>'+
					'</wsse:UsernameToken>'+
				'</wsse:Security>'+
   			'</soapenv:Header>'+
   			'<soapenv:Body>'+
      			'<inf:GetUserInformationOperation>'+
	         		'<inf:PortaWSRequest>'+
            			'<inf:userName>'+ user +'</inf:userName>'+
         			'</inf:PortaWSRequest>'+
      			'</inf:GetUserInformationOperation>'+
   			'</soapenv:Body>'+
		'</soapenv:Envelope>';
        //Configuramos el endpoint
        String endPoint = 'https://des.infinity.telefonica.com/PortalWS/PortalWSPort';
        //Objeto request y u configuracion
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        req.setHeader('Content-Type', 'text/xml; charset=utf-8'); 
        req.setBody(body);
        req.setMethod('POST');
        //Objeto Http para la comunicacion
        Http http = new Http();
        //Objeto para almacenar el xml del response del WS
        HttpResponse result;                           
        //LLamada al WS
        result = http.send(req);
        system.debug(LoggingLevel.INFO, 'Response devuelto: ' + result.getBody());
        //Lista donde se van a guardar las aplicaciones devueltas para el usuario 
        List<String> appList=new List<String>();
        Dom.Document doc = new Dom.Document();        
        doc.load(result.getBody());        
        //Retrieve the root element for this document.        
        Dom.XMLNode Envelope = doc.getRootElement();        
        Dom.XMLNode bodyEnv= Envelope.getChildElements()[0];       //getResponse 
        Dom.XMLNode child1= bodyEnv.getChildElements()[0];   //Fault
        system.debug('Element name: ' + child1.getName());
        system.debug('child1= ' + child1);
        system.debug('names: '+ child1.getAttributeValue('name',null));
        
        List<String> appAccess = new List<String>();
        
        if(child1.getName() == 'Fault'){
            //Dom.XMLNode faultCode= child1.getChildElements()[0];  
            Dom.XMLNode faultCode= child1.getChildElement('faultcode', null); 
        	system.debug('Element name: ' + faultCode.getName() + ' Text: ' + faultCode.getText());
        	//Dom.XMLNode faultString= child1.getChildElements()[1];  
        	Dom.XMLNode faultString= child1.getChildElement('faultstring', null);
        	system.debug('Element name: ' + faultString.getName() + ' Text: ' + faultString.getText());
            //String Error;
            appAccess.add('ko');
            appAccess.add(faultString.getText());
        }else{
            system.debug(child1.getChildElements());
            Dom.XMLNode PortalWSResponse= child1.getChildElements()[0];
            system.debug('Element name2: ' + PortalWSResponse.getName());
            system.debug('PortalWSResponse= ' + PortalWSResponse);
            Dom.XMLNode applications= PortalWSResponse.getChildElements()[1];
            system.debug('Element apps: ' + applications.getName());
            system.debug('applications=' + applications);
            Dom.XMLNode app= applications.getChildElements()[0];
            system.debug('Element app: ' + app.getName());
            system.debug('application=' + app);
            
            //Dom.XMLNode name= app.getChildElements()[0];
            //system.debug('app name: ' + name.getName()+ ' Text: ' + name.getText());
            //system.debug('name=' + name);
            
            appAccess.add('ok');
            for(Dom.XmlNode node: applications.getChildren()){
		    	//Dom.XMLNode name= app.getChildElements()[0];
            	system.debug('app name: ' + node.getName());
            	system.debug('app =' + node);
                
                Dom.XMLNode name= node.getChildElements()[0];
            	system.debug('att name: ' + name.getName()+ ' Text: ' + name.getText());
            	system.debug('name=' + name);
                appAccess.add(name.getText());
            }
            
            /*for(Dom.XmlNode node: properties.getChildElements()) {
            	system.debug('names == '+ node.getAttributeValue('name',null));
            	if(node.getAttributeValue('name',null)=='a_content_type') {
                	Dom.XmlNode contentType = node;
                	tipoDocumento = contentType.getChildElements()[0].getText();
                	system.debug('tipoDocumento ========= '+tipoDocumento);
            	}
        	}*/
        }
        for(String aux : appAccess){
                system.debug('rrrrr ' + aux);
        }
        return appAccess;
    } 
}