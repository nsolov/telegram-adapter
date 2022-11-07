Class Telegram.InboundAdapter Extends Ens.InboundAdapter
{

Property Server As %String [ InitialExpression = "api.telegram.org" ];

Property Token As %String;

Property SSLConfig As %String;

Property API As Telegram.API [ Private ];

Property Updates As %DynamicArray [ Private ];

Parameter SETTINGS As %String = "Server:Connection,Token:Connection,SSLConfig:Connection:sslConfigSelector";

Method OnInit() As %Status
{
    Try {
        $$$TRACE(..Server_" "_ ..Token_" "_ ..SSLConfig)
	    Set ..API = ##class(Telegram.API).%New(..Server, ..Token, ..SSLConfig)
        
        Set ..Updates = []
    } Catch ex {
        Return ex.AsStatus()
    }
	return $$$OK
}

Method ProcessUpdates(pOutput) As %Status
{
	Set updateObj = ..Updates.%Get(0) 
	Return:(updateObj="") $$$OK
	
	Set tSC = ..BusinessHost.ProcessInput(updateObj,.pOutput)
	If ($$$ISOK(tSC)) {
		Set ^Telegram.ProcessedUpdateId = updateObj."update_id"
		Do ..Updates.%Remove(0)
	}
	Return tSC
}

Method OnTask() As %Status
{
	Try {
		Set updateObj = ..Updates.%Get(0) 
		If (updateObj="") {
			Set res = ..API.GetUpdates(1+$Get(^Telegram.ProcessedUpdateId))
			If (res.ok) {
				Set ..Updates = res.result
			} Else {
				Return $$$ERROR($$$GeneralError,"No data received from API, check Bot token")
			}
		}
		Set st = ..ProcessUpdates(.pOutput)
	} Catch ex {
		Return ex.AsStatus()
	}	
	Return st
}

}
