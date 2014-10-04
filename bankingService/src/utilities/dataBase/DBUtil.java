package utilities.dataBase;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBUtil {
	
	private static Connection connection=null;
	
	
	public DBUtil(){
		
	}
	
	
	public static Connection getConnection(){
		
		if(connection!=null)
			return connection;
		else
		{
			
			
			
			try {
				
				String driver = "com.mysql.jdbc.Driver";
				String url="jdbc:mysql://localhost:3306/host";
				String user = "DBapp";
				String password = "desiboy";
				
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				connection=DriverManager.getConnection(url,user,password);
			} catch (InstantiationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IllegalAccessException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
			
			
		}
		
		
		return connection;
		
	}
	
	

}
