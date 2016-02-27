/* This is the driving engine of the program. It parses the command-line
 * arguments and calls the appropriate methods in the other classes.
 *
 * You should edit this file in two ways:
 * 1) Insert your database username and password in the proper places.
 * 2) Implement the three functions getInformation, registerStudent
 *    and unregisterStudent.
 */

import java.io.Console;
import java.sql.*;
import java.util.Properties;

public class StudentPortal
{
    /* TODO Here you should put your database name, username and password */
    static final String USERNAME = "tda357_047";
    static final String PASSWORD = "eS73ghJt";
    static final String DBNAME = "tda357_047";

    /* Print command usage.
     * /!\ you don't need to change this function! */
    public static void usage () {
        System.out.println("Usage:");
        System.out.println("    i[nformation]");
        System.out.println("    r[egister] <course>");
        System.out.println("    u[nregister] <course>");
        System.out.println("    q[uit]");
    }

    /* main: parses the input commands.
     * /!\ You don't need to change this function! */
    public static void main(String[] args) throws Exception
    {
        try {
            Class.forName("org.postgresql.Driver");
            String url = "jdbc:postgresql://ate.ita.chalmers.se/";
            Properties props = new Properties();
            props.setProperty("user",USERNAME);
            props.setProperty("password",PASSWORD);
            Connection conn = DriverManager.getConnection(url, props);

            String student = args[0]; // This is the identifier for the student.

            Console console = System.console();
            usage();
            System.out.println("Welcome!");
            while(true) {
                String mode = console.readLine("? > ");
                String[] cmd = mode.split(" +");
                cmd[0] = cmd[0].toLowerCase();
                if ("information".startsWith(cmd[0]) && cmd.length == 1) {
                    /* Information mode */
                    getInformation(conn, student);
                } else if ("register".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Register student mode */
                    registerStudent(conn, student, cmd[1]);
                } else if ("unregister".startsWith(cmd[0]) && cmd.length == 2) {
                    /* Unregister student mode */
                    unregisterStudent(conn, student, cmd[1]);
                } else if ("quit".startsWith(cmd[0])) {
                    break;
                } else usage();
            }
            System.out.println("Goodbye!");
            conn.close();
        } catch (SQLException e) {
            System.err.println(e);
            System.exit(2);
        }
    }

    /* Given a student identification number, ths function should print
     * - the name of the student, the students national identification number
     *   and their university issued login name (something similar to a CID)
     * - the programme and branch (if any) that the student is following.
     * - the courses that the student has read, along with the grade.
     * - the courses that the student is registered to.
     * - the mandatory courses that the student has yet to read.
     * - whether or not the student fulfills the requirements for graduation
     */
    static void getInformation(Connection conn, String student) throws SQLException {
        Statement statement = conn.createStatement();

        student = student.trim(); //Make sure there is no blank space.

        //Get the name, national identification number, program, branch
        String query =
                "SELECT S.name, S.personal_number, SF.program_name, SF.branch_name FROM students AS S" +
                "INNER JOIN StudentsFollowing AS SF" +
                "WHERE student_id=" + student;

        ResultSet result = statement.executeQuery(query);

        //Get finished courses
        printFinishedCourses(statement, student);

        //Get registered to
        printRegisteredTo(statement, student);

        //Get mandatory left
        printMandatoryLeft(statement, student);

        //Get fullfills for grad
        printFulfillsForGrad(statement, student);
    }

    private static void printMandatoryLeft(Statement statement, String student) {
        System.out.println("<--------START Mandatory left courses---------->");

        String query = "SELECT course_code FROM UnreadMandatory WHERE student_id=" + student;
        try {
            ResultSet result = statement.executeQuery(query);
            while (result.next()) {

            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("<--------END Mandatory left courses---------->");
    }

    private static void printFulfillsForGrad(Statement statement, String student) {
        String query = "SELECT qualified_for_graduation FROM PathToGraduation " +  "WHERE student_id=" + student;
        try {
            ResultSet result = statement.executeQuery(query);
            System.out.println("Student fullfills graduation requirements: " + result.getString("qualified_for_graduation"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private static void printRegisteredTo(Statement statement, String student) {
        System.out.println("<--------START Registered courses---------->");
        String query = "SELECT course_code FROM is_registered_for WHERE personal_number=" + student;
        try {
            ResultSet result = statement.executeQuery(query);
            while (result.next()) {
                System.out.println("Code: " + result.getString("code"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        System.out.println("<--------END Registered courses---------->");
    }

    private static void printFinishedCourses(Statement statement, String student) {
        System.out.println("<--------START Finished courses---------->");

        String query = "SELECT code, grade FROM FinishedCourses WHERE personal_number=" + student;
        ResultSet result = null;

        try {
            result = statement.executeQuery(query);
            while (result.next()) {
                System.out.println("Code: " + result.getString("code") + ", Result: "  + result.getString("grade"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        System.out.println("<--------END Finished courses---------->");
    }

    /* Register: Given a student id number and a course code, this function
     * should try to register the student for that course.
     */
    static void registerStudent(Connection conn, String student, String course) throws SQLException {
        Statement statement = conn.createStatement();

        if (student != null && course != null) {
            String insertStatement =
                    "INSERT INTO registrations VALUES ("
                    + student + ", " + course + ");";
            statement.executeUpdate(insertStatement);
        } else {
            throw new NullPointerException("You can't register if the student or course is null");
        }
    }

    /* Unregister: Given a student id number and a course code, this function
     * should unregister the student from that course.
     */
    static void unregisterStudent(Connection conn, String student, String course) throws SQLException {
        Statement statement = conn.createStatement();

        String query =
                "DELETE FROM registrations WHERE " + student + "=personal_number AND " + course +"=code;";
        statement.executeUpdate(query);
    }
}