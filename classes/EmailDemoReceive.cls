global class EmailDemoReceive implements Messaging.InboundEmailHandler {
	global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope) {
		Case newCase=new Case();
		Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		List<Messaging.Emailfileattachment> adjuntos = new List<Messaging.Emailfileattachment>();
                                                             
		try {
  			//Creamos el caso nuevo
            newCase.Subject = email.subject;
            newCase.Description=email.plainTextBody;
    		newCase.Status='New';
    		newCase.Origin='Email';
  			insert newCase;

            // Guardamos los adjuntos, si los tenemos, asociados al caso
    		if(email.textAttachments!=null){
            	for (Messaging.Inboundemail.TextAttachment  tAttachment :email.textAttachments) {
                	Attachment attachment = new Attachment();
                	attachment.Name = tAttachment.fileName;
                	attachment.Body = Blob.valueOf(tAttachment.body);
                	attachment.ParentId = newCase.Id;
                	insert attachment;
            
           			Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                	efa.setBody(Blob.valueOf(tAttachment.body));
                	efa.setFileName(tAttachment.fileName);
                	adjuntos.add(efa);              
                }
     		}
            
            if(email.binaryAttachments!=null){
        		Attachment attachment = new Attachment();
                for (Messaging.Inboundemail.BinaryAttachment  bAttachment :email.binaryAttachments) {   
                	attachment.Name = bAttachment.fileName;
                    attachment.Body = bAttachment.body;
                    attachment.ParentId = newCase.Id;
                    insert attachment;
            
            		Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
                    efa.setBody(attachment.body);
                    efa.setFileName(attachment.Name);
                    efa.setContentType(attachment.ContentType);
                    adjuntos.add(efa);  
                }
            }
            //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attachment.Name});
      		result.success = true;
      		result.message = (email.subject + ' enviado');
    
        	String[] toAddresses = new String[] {'monchodeveloper@gmail.com', 'ocettaperez@gmail.com'};
        	mail.setToAddresses(toAddresses);
        	mail.setSubject(email.subject);
        	mail.setPlainTextBody(email.plainTextBody);
            //Attachment attachment = new Attachment();
            //mail.setFileAttachments(new Messaging.EmailFileAttachment[] {adjuntos});
            mail.setFileAttachments(adjuntos);
        	Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    
		} catch (Exception e) {
    		result.success = false;
    		result.message = 'Error en el mensaje';
		}                                                             
    	return result;
	}
}