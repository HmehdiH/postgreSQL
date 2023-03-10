public class TestPortal {

   // enable this to make pretty printing a bit more compact
   private static final boolean COMPACT_OBJECTS = false;

   // This class creates a portal connection and runs a few operation

   public static void main(String[] args) {
      try{
         PortalConnection c = new PortalConnection();
   
         // Write your tests here. Add/remove calls to pause() as desired. 
         // Use println instead of prettyPrint to get more compact output (if your raw JSON is already readable)
   
         //System.out.println(c.unregister("2222222222", "CCC333")); 
         //pause();

         //test1: get student info 
         prettyPrint(c.getInfo("6666666666")); 
         pause();

         //test2: register student for an unrestricted course
         System.out.println(c.register("6666666666", "CCC444"));
         prettyPrint(c.getInfo("6666666666")); 
         pause();

         //test3: Register student from test2 agin to same course
         System.out.println(c.register("6666666666", "CCC444"));
         pause();

         //test4: unregister student from the course twice 
         System.out.println(c.unregister("1111111111", "CCC111"));
         System.out.println(c.unregister("1111111111", "CCC111"));
         prettyPrint(c.getInfo("1111111111"));
         pause();

         //test5: register a student that not fufills the requirment to a prerequisities  course
         System.out.println(c.register("1111111111", "CCC777"));
         pause();

         //test6: unregister a student from restricted courses that they are registered to 
         // and wich has at least two students in the queue
         //register again to same course, student should get last position in waitinglist
         prettyPrint(c.getInfo("5555555555"));
         System.out.println(c.unregister("5555555555","CCC333"));
         System.out.println(c.register("5555555555", "CCC333"));
         prettyPrint(c.getInfo("5555555555"));
         pause();
         

         //test7: unregister and re-register the same student for the same limited course 
         System.out.println(c.unregister("22222222222","CCC222"));
         System.out.println(c.register("2222222222", "CCC222"));
         prettyPrint(c.getInfo("2222222222"));
         pause();


         //test8: unregister student from an overfull course
         System.out.println(c.unregister("5555555555", "CCC222"));
         pause();

         //test9: unregister student with SQL-injection
         System.out.println(c.unregister("1111111111","x' OR 'a'='a"));
         pause();

      } catch (ClassNotFoundException e) {
         System.err.println("ERROR!\nYou do not have the Postgres JDBC driver (e.g. postgresql-42.2.18.jar) in your runtime classpath!");
      } catch (Exception e) {
         e.printStackTrace();
      }
   }
   
   
   
   public static void pause() throws Exception{
     System.out.println("PRESS ENTER");
     while(System.in.read() != '\n');
   }
   
   // This is a truly horrible and bug-riddled hack for printing JSON. 
   // It is used only to avoid relying on additional libraries.
   // If you are a student, please avert your eyes.
   public static void prettyPrint(String json){
      System.out.print("Raw JSON:");
      System.out.println(json);
      System.out.println("Pretty-printed (possibly broken):");
      
      int indent = 0;
      json = json.replaceAll("\\r?\\n", " ");
      json = json.replaceAll(" +", " "); // This might change JSON string values :(
      json = json.replaceAll(" *, *", ","); // So can this
      
      for(char c : json.toCharArray()){
        if (c == '}' || c == ']') {
          indent -= 2;
          breakline(indent); // This will break string values with } and ]
        }
        
        System.out.print(c);
        
        if (c == '[' || c == '{') {
          indent += 2;
          breakline(indent);
        } else if (c == ',' && !COMPACT_OBJECTS) 
           breakline(indent);
      }
      
      System.out.println();
   }
   
   public static void breakline(int indent){
     System.out.println();
     for(int i = 0; i < indent; i++)
       System.out.print(" ");
   }   
}