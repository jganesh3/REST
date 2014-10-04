package bankservice.helper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import utilities.dataBase.DBUtil;

public class Helper {
	
	
	
	
	public boolean validAccountNumber(String accountNumber) {
		// TODO Auto-generated method stub
		
		try {
			Connection connect=DBUtil.getConnection();
			PreparedStatement preStatement;
			String sql="select count(*) from balance where account_number = ?";
			preStatement=connect.prepareStatement(sql);
			preStatement.setString(1, accountNumber);
			ResultSet rs=preStatement.executeQuery();
			int resultCount=0;
			while(rs.next()){
				resultCount++;
			}
			if(resultCount ==1)
				return true;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
		return false;
	}
	
	
	
	
public double getAvailableBalance(String accNumber) {
		
		Connection connection=DBUtil.getConnection();
		double bal=0;
		ResultSet resultSet=null;
		
		try {
			String sql="select available_balance from balance where account_number = ?";
			PreparedStatement preStmt= connection.prepareStatement(sql);
			preStmt.setString(1, accNumber);
			resultSet=preStmt.executeQuery();
			while(resultSet.next()){
				bal=resultSet.getDouble("available_balance");
			}
			
			return bal;
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
				
		
		
		return bal;
	}



}
