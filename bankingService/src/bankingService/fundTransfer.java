package bankingService;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ws.*;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;




import utilities.dataBase.DBUtil;
import bankservice.helper.Helper;

@Path("/fundtransfer")
public class fundTransfer {
	
	private Helper help=new Helper();
	@GET
	@Consumes("application/text")
	@Produces("application/json")
	public String transfer(@QueryParam("fromAccount") String fromAccount,@QueryParam("toAccount") String toAccount, @QueryParam("txnAmmount") double txnAmmount){
		
		
		//http://localhost:8080/bankingService/api/balanceinq/111111
		//first get the balance of the from account
		//check if from account has sufficient ammount
		// if yes, check if the toaccount is present
		//if yes debit from account credit toaccount 
		//return balance of from account
		if(fromAccount.trim().equals("") || toAccount.trim().equals("") || txnAmmount<=0)
		{
			return "Invalid Operation";
		}
		
		
		try {
			if(!(help.validAccountNumber(fromAccount) && help.validAccountNumber(toAccount)))
			{
				return "Invalid account numbers";

			}else{
				
				
					Connection con=DBUtil.getConnection();
					java.sql.CallableStatement call= con.prepareCall("? =fundTransfer(? , ? , ?");
					
					call.registerOutParameter(1,java.sql.Types.INTEGER);
					call.setString(2, fromAccount);
					call.setString(3, toAccount);
					call.execute();
					
					if(call.getInt(1)== -1)
						return "Fund transfer is unsuccessful";
					else
					{
						double balance=help.getAvailableBalance(fromAccount);
						return Double.toString(balance);
					}
					
			
				
				
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		return "Please try again Later";
	
		
	}
	
	
}
