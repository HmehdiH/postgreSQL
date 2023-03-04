
import java.sql.*; // JDBC stuff.
import java.util.Properties;

import javax.xml.namespace.QName;

public class PortalConnection {

    // Set this to e.g. "portal" if you have created a database named portal
    // Leave it blank to use the default database of your database user
    static final String DBNAME = "";
    // For connecting to the portal database on your local machine
    static final String DATABASE = "jdbc:postgresql://localhost/"+DBNAME;
    static final String USERNAME = "postgres";
    static final String PASSWORD = "00000000";

    // For connecting to the chalmers database server (from inside chalmers)
    // static final String DATABASE = "jdbc:postgresql://brage.ita.chalmers.se/";
    // static final String USERNAME = "tda357_nnn";
    // static final String PASSWORD = "yourPasswordGoesHere";


    // This is the JDBC connection object you will be using in your methods.
    private Connection conn;

    public PortalConnection() throws SQLException, ClassNotFoundException {
        this(DATABASE, USERNAME, PASSWORD);  
    }

    // Initializes the connection, no need to change anything here
    public PortalConnection(String db, String user, String pwd) throws SQLException, ClassNotFoundException {
        Class.forName("org.postgresql.Driver");
        Properties props = new Properties();
        props.setProperty("user", user);
        props.setProperty("password", pwd);
        conn = DriverManager.getConnection(db, props);
    }

//------------------------------------------------Reg------------------------------------------
    // Register a student on a course, returns a tiny JSON document (as a String)
    public String register(String student, String courseCode){
      
      /*intro
      // placeholder, remove along with this comment. 
      return "{\"success\":false, \"error\":\"Registration is not implemented yet :(\"}";
      
      // Here's a bit of useful code, use it or delete it 
      // } catch (SQLException e) {
      //    return "{\"success\":false, \"error\":\""+getError(e)+"\"}";
      // } 
      */  
      boolean ErrFlag = false;  
      try(PreparedStatement pS = conn.prepareStatement("INSERT INTO Registrations VALUES (?,?)");)
      {
        pS.setString(1, student);
        pS.setString(2, courseCode);
        pS.executeUpdate();
      }catch(SQLException e)
      {
        ErrFlag =true;
        return "{\"success\":false, \"error\":\""+getError(e)+"\"}";
      }
      if(!(ErrFlag)){
        return "{\"success\":true}"; 
      }
      
      return "";
    }//------------------------------------------End Reg-------------------------------------------

    // Unregister a student from a course, returns a tiny JSON document (as a String)
    public String unregister(String student, String courseCode){
      //return "{\"success\":false, \"error\":\"Unregistration is not implemented yet :(\"}";
      String idNr = student; 
      String code = courseCode;
      String query = "DELETE FROM Registrations WHERE student ='" +idNr+ "' AND course ='" +code+ "'";

      try(Statement us = conn.createStatement();){
        int num = us.executeUpdate(query);
        if(num>0){return "{\"success\":true}";}
      } catch (SQLException e) {
        // TODO: handle exception
        return "{\"success\":false, \"error\":\""+getError(e)+"\"}";
      }
       return "{\"success\":false, \"error\":\"student not on registrations/ course doesnt exist\"}";

    }

    // Return a JSON document containing lots of information about a student, it should validate against the schema found in information_schema.json
    public String getInfo(String student) throws SQLException{
        
        try(PreparedStatement st = conn.prepareStatement(
            // replace this with something more useful
            "SELECT jsonb_build_object('student', idnr,\r\n"
            + " 'name', name,\r\n"
            + "	'login', login,\r\n"
            + "	'program', program,\r\n"
            + "	'branch', branch,\r\n"
            + "	'finished', (SELECT COALESCE (jsonb_agg\r\n"
            + " (jsonb_build_object(\r\n"
            + " 'course', (SELECT to_json(name) AS jsondata\r\n"
            + " FROM courses\r\n"
            + " WHERE code = FinishedCourses.course),\r\n"
            + "	'code', course,\r\n"
            + "	'credits', credits,\r\n"
            + "	'grade', grade\r\n"
            + "	)),'[]') \r\n"
            + " FROM FinishedCourses WHERE student = BasicInformation.idnr),\r\n"
            + "	\r\n"
            + "	'registered', (SELECT COALESCE (jsonb_agg\r\n"
            + " (jsonb_build_object(\r\n"
            + " 'course', (SELECT to_json(name) AS jsondata\r\n"
            + " FROM courses\r\n"
            + " WHERE code = Registrations.course),\r\n"
            + "	'code', course,\r\n"
            + "	'status', status,\r\n"
            + "	'position', (SELECT to_json(place) AS jsondata\r\n"
            + " FROM CourseQueuePositions\r\n"
            + " WHERE course = Registrations.course\r\n"
            + "	AND student = BasicInformation.idnr)\r\n"
            + "	)),'[]') \r\n"
            + " FROM Registrations WHERE student = BasicInformation.idnr),\r\n"
            + "	\r\n"
            + "	'seminarCourses', (SELECT to_json(seminarCourses) AS jsondata\r\n"
            + " FROM PathToGraduation\r\n"
            + " WHERE student = BasicInformation.idnr),\r\n"
            + "	\r\n"
            + "	'mathCredits', (SELECT to_json(mathCredits) AS jsondata\r\n"
            + " FROM PathToGraduation\r\n"
            + " WHERE student = BasicInformation.idnr),\r\n"
            + "	\r\n"
            + "	'researchCredits', (SELECT to_json(researchCredits) AS jsondata\r\n"
            + " FROM PathToGraduation\r\n"
            + " WHERE student = BasicInformation.idnr),\r\n"
            + "	\r\n"
            + "	'totalCredits', (SELECT to_json(totalCredits) AS jsondata\r\n"
            + " FROM PathToGraduation\r\n"
            + " WHERE student = BasicInformation.idnr),\r\n"
            + "	\r\n"
            + "	'canGraduate', (SELECT to_json(qualified) AS jsondata\r\n"
            + " FROM PathToGraduation\r\n"
            + " WHERE student = BasicInformation.idnr)\r\n"
            + "	\r\n"
            + "	) AS jsondata \r\n"
            + " \r\n"
            + " FROM BasicInformation \r\n"
            + " WHERE idnr =?"
            );){
            
            st.setString(1, student);
            
            ResultSet rs = st.executeQuery();
            
            if(rs.next())
              return rs.getString("jsondata");
            else
              return "{\"student\":\"does not exist :(\"}"; 
            
        } 
  
    }

    // This is a hack to turn an SQLException into a JSON string error message. No need to change.
    public static String getError(SQLException e){
       String message = e.getMessage();
       int ix = message.indexOf('\n');
       if (ix > 0) message = message.substring(0, ix);
       message = message.replace("\"","\\\"");
       return message;
    }
}



//Carl Agrell
