/*
 * DuplicateLead is a wrapper class in order for
 * JSON serialization to work correctly client-side.
*/
public class DuplicateLead {

    @AuraEnabled public String name { get; set; }
    @AuraEnabled public Integer duplicityLevel { get; set; }
     
    // Trivial constructor, for server-side Apex -> client-side JavaScript
    public DuplicateLead(String name, Integer duplicityLevel) {
        this.name = name;
        this.duplicityLevel = duplicityLevel;
    }
}