public with sharing class CarController {
    // @AuraEnabled  -> makes this method callable from LWC/Aura.
    // (cacheable=true) -> lets LWC cache the result and use @wire.
    //   Rule: a cacheable method must be READ-ONLY (no DML). It only queries.
    @AuraEnabled(cacheable=true)
    public static List<Car__c> getCars(
        String searchKey,
        Decimal maxPrice,
        String[] categories,
        String[] makeType
    ) {
        // Wrap the search text with % so SOQL LIKE does a "contains" match.
        // searchKey '' -> '%%' which matches everything (good default).
        String key = '%' + searchKey + '%';

        // Bind variables (:key, :maxPrice, ...) are the SAFE way to put
        // values into SOQL. They prevent SOQL injection. Never concatenate
        // user input straight into the query string.
        return [
            SELECT Id, Name, MSRP__c, Picture_URL__c, Category__c, Make__c
            FROM Car__c
            WHERE Name LIKE :key
            AND MSRP__c <= :maxPrice
            AND Category__c IN :categories
            AND Make__c IN :makeType
            WITH USER_MODE
            ORDER BY Name
        ];
    }

    // Single-record fetch for the detail panel on the right.
    @AuraEnabled(cacheable=true)
    public static Car__c getCarById(Id carId) {
        return [
            SELECT Id, Name, MSRP__c, Picture_URL__c, Category__c, Make__c,
                   Description__c, Fuel_Type__c, Number_Of_Seats__c, Control__c
            FROM Car__c
            WHERE Id = :carId
            WITH USER_MODE
            LIMIT 1
        ];
    }
}
