abstract class StringUtil{
  static String cutFromString(String string, String pattern){
    String sub1 = "";
    String sub2 = "";
    if(string.indexOf(pattern) >= 1) {
      sub1 = string.substring(
      0, string.indexOf(pattern));
    }
    if(string.indexOf(pattern)+pattern.length < string.length){
      sub2 = string.substring(
          string.indexOf(string) + pattern.length + 1, string.length
      );
    }
    return sub1+sub2;
  }

  static String getRetardedDateFormat(String normalDate){
    String freedomString = "";
    List<String> spliString = normalDate.split(".");
    for(int i = spliString.length -1; i >= 0 ; i--){
      if(i == 0){
        freedomString = freedomString + spliString[i];
      }
      else{
        freedomString = "$freedomString${spliString[i]}-";
      }
    }
    return freedomString;
  }
}