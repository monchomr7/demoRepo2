global class SoapSpecialAccounts {

  global class AccountInfo {
     webService String AcctName;
     webService Integer AcctNumber;
  }

  webService static Account createAccount(AccountInfo info) {
    system.debug(info.AcctName);
    Account acct = new Account();
    acct.Name = info.AcctName;
    acct.AccountNumber = String.valueOf(info.AcctNumber); 
    insert acct;
    return acct;
  }

  webService static Id [] createAccounts(Account parent, 
       Account child, Account grandChild) {

        insert parent;
        child.parentId = parent.Id;
        insert child;
        grandChild.parentId = child.Id;
        insert grandChild;

        Id [] results = new Id[3];
        results[0] = parent.Id;
        results[1] = child.Id;
        results[2] = grandChild.Id;
        return results;
    }
    
    webService static String prueba(){
        return 'correcto';
    }
}