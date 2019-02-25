@RestResource(urlMapping='/updateLiga/*')
global class WS_Update_Ligas {
	
    global static Liga__c liga {get; set;}
    global static Clasificacion__c clasificacionGeneral {get; set;}
    global static Clasificacion__c clasificacionLocal {get; set;}
    global static Clasificacion__c clasificacionVisitante {get; set;}
    global static List<Equipo__c> listaEquipos {get; set;}
    global static String nombreLiga {get; set;}
    global static String pais {get; set;}
    
    @HttpPost
    global static void doPost(){
        String requestJSON = RestContext.request.requestBody.toString();
        System.debug('*** Request recibida: ' + requestJSON);
        
        List<Object> clasificaciones = (List<Object>) JSON.deserializeUntyped(requestJSON);
        
        for(Object clasificacion : clasificaciones){
            System.debug('RPM clasificacion: ' + clasificacion);
            String tipoClasificacion;
            String clasificacionSerialized = JSON.serialize(clasificacion);
            List<Object> listaEquipos = (List<Object>) JSON.deserializeUntyped(clasificacionSerialized);
            
            for(Object equipo : listaEquipos){
                System.debug('RPM equipo: ' + equipo);
                String valoresSerialized = JSON.serialize(equipo);
            	List<Object> listaValores = (List<Object>) JSON.deserializeUntyped(valoresSerialized);
                
                pais = String.valueOf(listaValores[9]);
                nombreLiga = String.valueOf(listaValores[10]);
                tipoClasificacion = String.valueOf(listaValores[11]);
                
                for(Object valor : listaValores){
                    System.debug('RPM valor: ' + valor);
                }
            }
            
            System.debug('RPM pais: ' + pais);
            System.debug('RPM liga: ' + nombreLiga);
            searchLiga(pais, nombreLiga);
            searchClasificaciones();
            searchEquipo(listaEquipos, tipoClasificacion);
        }

    }
    
    
    
    private static void searchLiga(String paisParam, String ligaParam){
        
        List<Liga__c> ligaSF = [SELECT Id, Name, Pais__c
                         	    FROM Liga__c
                         	    WHERE Pais__c =: paisParam AND Name =: ligaParam];
        
        if(!ligaSF.isEmpty()){
            liga = ligaSF[0];
        }else{
            Liga__c newLiga = new Liga__c();
            newLiga.Name = ligaParam;
            newLiga.Pais__c = paisParam;
            insert newLiga;
            System.debug('RPM newLigaId: ' + newLiga.Id);
            liga = newLiga;
        }
    }
    
    
    
    private static void searchClasificaciones(){
        Id idLiga = liga.Id;
        List<Clasificacion__c> clasificacionesSF = [SELECT Id, RecordType.DeveloperName, Name, liga__c, RecordTypeId
                                                  		 FROM Clasificacion__c
                                                  		 WHERE Liga__c =: idLiga];
        
        RecordType rtGeneral = [SELECT Id FROM RecordType WHERE DeveloperName = 'General'];
        RecordType rtLocal = [SELECT Id FROM RecordType WHERE DeveloperName = 'Local'];
        RecordType rtVisitante = [SELECT Id FROM RecordType WHERE DeveloperName = 'Visitante'];
        
        if(!clasificacionesSF.isEmpty() && clasificacionesSF.size() == 3){
            
            for(Clasificacion__c clasificacion : clasificacionesSF){
                if(clasificacion.RecordType.DeveloperName == 'General'){
                    clasificacionGeneral = clasificacion;
                }
                if(clasificacion.RecordType.DeveloperName == 'Local'){
                    clasificacionLocal = clasificacion;
                }
                if(clasificacion.RecordType.DeveloperName == 'Visitante'){
                    clasificacionVisitante = clasificacion;
                }
            }
            
        }else{
            delete clasificacionesSF;
            
            clasificacionesSF = new List<Clasificacion__c>();
            Clasificacion__c claGeneral = new Clasificacion__c();
            claGeneral.Name = 'General 18-19';
            claGeneral.liga__c = liga.Id;
            claGeneral.RecordTypeId = rtGeneral.Id;
            clasificacionGeneral = claGeneral;
            clasificacionesSF.add(claGeneral);
            
            Clasificacion__c claLocal = new Clasificacion__c();
            claLocal.Name = 'Local 18-19';
            claLocal.liga__c = liga.Id;
            claLocal.RecordTypeId = rtLocal.Id;
            clasificacionLocal = claLocal;
            clasificacionesSF.add(claLocal);
            
            Clasificacion__c claVisitante = new Clasificacion__c();
            claVisitante.Name = 'Visitante 18-19';
            claVisitante.liga__c = liga.Id;
            claVisitante.RecordTypeId = rtVisitante.Id;
            clasificacionVisitante = claVisitante;
            clasificacionesSF.add(claVisitante);
            
            insert clasificacionesSF;
        }
    }
    
    
    
    private static void searchEquipo(List<Object> teams, String tipo){
        listaEquipos = new List<Equipo__c>();
        Equipo__c newEquipo;
        for(Object team : teams){
            String valoresSerialized = JSON.serialize(team);
         	List<String> listaValores = (List<String>) JSON.deserialize(valoresSerialized, List<String>.class);
            
            String nombreEquipo = listaValores[1];
            List<Equipo__c> equiposSF = [SELECT Id, Liga__c, Posicion__c, Partidos_Jugados__c, Ganados__c, Empatados__c, Perdidos__c, Goles_a_Favor__c, 
                                            Goles_en_Contra__c, Puntos__c, Clasificacion_General__c, Posicion_Local__c, Partidos_Jugados_Local__c, Ganados_Local__c,
                                            Empatados_Local__c, Perdidos_Local__c, Goles_a_Favor_Local__c, Goles_en_Contra_Local__c, Puntos_Local__c, Clasificacion_Local__c,
                                            Posicion_Visitante__c, Partidos_Jugados_Visitante__c, Ganados_Visitante__c, Empatados_Visitante__c, Perdidos_Visitante__c,
                                            Goles_a_Favor_Visitante__c, Goles_en_Contra_Visitante__c, Puntos_Visitante__c, Clasificacion_Visitante__c
                                     	 FROM Equipo__c
                                     	 WHERE Name =: nombreEquipo];
            
            if(!equiposSF.isEmpty()){
            	newEquipo = equiposSF[0];
            }else{
                newEquipo = new Equipo__c();
                newEquipo.Name = listaValores[1];
            }
            if(tipo == 'General'){
                newEquipo.Posicion__c = Decimal.valueOf(listaValores[0]);
                newEquipo.Partidos_Jugados__c = Decimal.valueOf(listaValores[2]);
                newEquipo.Ganados__c = Decimal.valueOf(listaValores[3]);
                newEquipo.Empatados__c = Decimal.valueOf(listaValores[4]);
                newEquipo.Perdidos__c = Decimal.valueOf(listaValores[5]);
                newEquipo.Goles_a_Favor__c = Decimal.valueOf(listaValores[6]);
                newEquipo.Goles_en_Contra__c = Decimal.valueOf(listaValores[7]);
                newEquipo.Puntos__c = Decimal.valueOf(listaValores[8]);
                newEquipo.Clasificacion_General__c = clasificacionGeneral.Id;
            }else if(tipo == 'Local'){
                newEquipo.Posicion_Local__c = Decimal.valueOf(listaValores[0]);
                newEquipo.Partidos_Jugados_Local__c = Decimal.valueOf(listaValores[2]);
                newEquipo.Ganados_Local__c = Decimal.valueOf(listaValores[3]);
                newEquipo.Empatados_Local__c = Decimal.valueOf(listaValores[4]);
                newEquipo.Perdidos_Local__c = Decimal.valueOf(listaValores[5]);
                newEquipo.Goles_a_Favor_Local__c = Decimal.valueOf(listaValores[6]);
                newEquipo.Goles_en_Contra_Local__c = Decimal.valueOf(listaValores[7]);
                newEquipo.Puntos_Local__c = Decimal.valueOf(listaValores[8]);
                newEquipo.Clasificacion_Local__c = clasificacionLocal.Id;
            }else if(tipo == 'Visitante'){
                newEquipo.Posicion_Visitante__c = Decimal.valueOf(listaValores[0]);
                newEquipo.Partidos_Jugados_Visitante__c = Decimal.valueOf(listaValores[2]);
                newEquipo.Ganados_Visitante__c = Decimal.valueOf(listaValores[3]);
                newEquipo.Empatados_Visitante__c = Decimal.valueOf(listaValores[4]);
                newEquipo.Perdidos_Visitante__c = Decimal.valueOf(listaValores[5]);
                newEquipo.Goles_a_Favor_Visitante__c = Decimal.valueOf(listaValores[6]);
                newEquipo.Goles_en_Contra_Visitante__c = Decimal.valueOf(listaValores[7]);
                newEquipo.Puntos_Visitante__c = Decimal.valueOf(listaValores[8]);
                newEquipo.Clasificacion_Visitante__c = clasificacionVisitante.Id;
            }
            if(String.isBlank(newEquipo.Liga__c)){
                newEquipo.Liga__c = liga.Id;
            }
            
            listaEquipos.add(newEquipo);
        }

        upsert listaEquipos;
    }
    
}