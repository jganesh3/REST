package bankingService;

import javax.ws.rs.core.MediaType;

import com.sun.jersey.api.client.Client;
import com.sun.jersey.api.client.ClientResponse;
import com.sun.jersey.api.client.WebResource;
import com.sun.jersey.api.client.config.ClientConfig;
import com.sun.jersey.api.client.config.DefaultClientConfig;

public class TestClient {
	
	
public static void main(String[] args) {
	String acctNo="111111";
			
	try {
		 
		Client client = Client.create();
 
		//WebResource webResource = client.resource("http://localhost:8080/bankingService/api/balanceinq/111111");
		//WebResource webResource = client.resource("http://localhost:8080/bankingService/api/balanceinq/hello").queryParam("name", "ganesh");
		//WebResource webResource = client.resource("http://localhost:8080/bankingService/api/balanceinq").queryParam("accountNumber", acctNo);
		WebResource webResource = client.resource("http://localhost:8080/bankingService/api/fundtransfer").queryParam("fromAccount", "111111").queryParam("toAccount", "111112").queryParam("txnAmmount", "50");
		ClientResponse response = webResource.accept("application/json")
                   .get(ClientResponse.class);
 
		if (response.getStatus() != 200) {
		   throw new RuntimeException("Failed : HTTP error code : "
			+ response.getStatus());
		}
 
		String output = response.getEntity(String.class);
 
		System.out.println("Output from Server .... \n");
		System.out.println(output);
 
	  } catch (Exception e) {
 
		e.printStackTrace();
 
	  }
 
	
}

private static String getBas2eURI() {
	// TODO Auto-generated method stub
	return "http://localhost:8080/bankingService/api/balanceinq";
}




}
