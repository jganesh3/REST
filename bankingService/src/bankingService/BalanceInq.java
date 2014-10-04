package bankingService;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.ws.*;
import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.MediaType;

import bankservice.helper.Helper;
import utilities.dataBase.DBUtil;

@Path("/balanceinq")
public class BalanceInq {
	
	private Helper helper=new Helper();
	@GET
	@Path("{accountNumber}")
	@Consumes("application/text")
	@Produces("application/json")
	public String getBalance(@PathParam("accountNumber") String accountNumber){
		
		
		//check if the input account number is null.
		if(accountNumber==null)
			return "Error";
		
		//check if the account number is present
		if(helper.validAccountNumber(accountNumber)){
			
		double balance=helper.getAvailableBalance(accountNumber);
		
		return Double.toString(balance);
		
			
		}else
			return "NOK";
		
		
		
		
	}
	
	
}
