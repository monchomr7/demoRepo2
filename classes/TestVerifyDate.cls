@isTest
public class TestVerifyDate {
	
    @isTest static void menos30() {
        date fecha1 = date.newInstance(1987, 12, 17);
		date fecha2 = date.newInstance(1987, 12, 20);
        VerifyDate.CheckDates(fecha1, fecha2);
    }
    
    @isTest static void mas30() {
        date fecha1 = date.newInstance(1987, 12, 17);
		date fecha2 = date.newInstance(1988, 12, 20);
        VerifyDate.CheckDates(fecha1, fecha2);
    }
    


    @isTest static void menor2() {
        date fecha1 = date.newInstance(1987, 12, 17);
		date fecha2 = date.newInstance(1987, 12, 15);
        VerifyDate.CheckDates(fecha1, fecha2);
    }
}