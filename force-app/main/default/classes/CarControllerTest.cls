@isTest
private class CarControllerTest {
    // @TestSetup runs once before the test methods and creates shared data.
    // Tests NEVER see your real org data, so we must build our own.
    @TestSetup
    static void makeData() {
        List<Car__c> cars = new List<Car__c>();
        // Note: every field below is REQUIRED on Car__c, so a test insert
        // is forced to supply all of them — exactly the trade-off of
        // field-level "required". Number_Of_Seats has precision 1 -> max 9.
        cars.add(new Car__c(
            Name = 'Test Hatch',
            Make__c = 'Ford',
            Category__c = 'Hatchback',
            Control__c = 'Manual',
            Fuel_Type__c = 'Petrol',
            MSRP__c = 500000,
            Number_Of_Seats__c = 5,
            Picture_URL__c = '/resource/carhubimages/test.png'
        ));
        cars.add(new Car__c(
            Name = 'Test SUV',
            Make__c = 'Honda',
            Category__c = 'SUV',
            Control__c = 'Automatic',
            Fuel_Type__c = 'Diesel',
            MSRP__c = 1500000,
            Number_Of_Seats__c = 7,
            Picture_URL__c = '/resource/carhubimages/test2.png'
        ));
        insert cars;
    }

    @isTest
    static void getCars_filtersByPriceAndCategory() {
        Test.startTest();
        List<Car__c> results = CarController.getCars(
            '',                                  // searchKey: blank = match all names
            1000000,                             // maxPrice: should exclude the 15L SUV
            new List<String>{ 'Hatchback' },     // categories
            new List<String>{ 'Ford', 'Honda' } // makeType
        );
        Test.stopTest();

        System.assertEquals(1, results.size(), 'Only the Ford Hatchback should match');
        System.assertEquals('Test Hatch', results[0].Name);
    }

    @isTest
    static void getCarById_returnsOneCar() {
        Car__c known = [SELECT Id FROM Car__c WHERE Name = 'Test SUV' LIMIT 1];

        Test.startTest();
        Car__c result = CarController.getCarById(known.Id);
        Test.stopTest();

        System.assertEquals('Test SUV', result.Name);
        System.assertEquals('Diesel', result.Fuel_Type__c);
    }
}
