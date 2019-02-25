public class AccountHandler {
    public static Account insertNewAccount(String x){
        Account cuenta = new Account();
        cuenta.Name = x;
        try{
            insert cuenta;
        }catch(DMLException e){
            return null;
        }
        return cuenta;
    }
	public static void prueba(){
		
	}

}