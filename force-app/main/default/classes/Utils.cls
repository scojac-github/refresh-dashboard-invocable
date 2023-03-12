public with sharing class Utils {

    public static List<String> dedupe(List<String> input) {

        Set<String> uniq = new Set<String>(input);
        return new List<String>(uniq);
    }
}