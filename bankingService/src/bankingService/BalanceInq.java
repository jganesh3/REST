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
import javax.ws.rs.core.Response;

import bankservice.helper.Helper;
import utilities.dataBase.DBUtil;

@Path("/balanceinq")
public class BalanceInq {
	
	Response rs;
	
	private Helper helper=new Helper();
	@GET
	@Path("{accountNumber}")
	@Consumes("application/text")
	@Produces("application/json")
	public Response getBalance(@PathParam("accountNumber") String accountNumber){
		
		
		//check if the input account number is null.
		if(accountNumber==null)
			return Response.status(400).entity("Account number can't be null").build();
		
		//check if the account number is present
		if(helper.validAccountNumber(accountNumber)){
			
		double balance=helper.getAvailableBalance(accountNumber);
		
		//return Double.toString(balance);
		
		return rs.ok(Double.toString(balance)).build();
		
			
		}else
			return rs.status(400).entity("Please enter valid account number").build();
		
		
		
		
	}
	
	
}
