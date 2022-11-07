Class Telegram.API Extends %RegisteredObject
{

Property Token As %String;

Property Server As %String;

Property SSLConfiguration As %String;

Method %OnNew(server As %String, token As %String, ssl As %String) As %Status [ Private ]
{
	If ( (server="") || (token="") || (ssl="") ) {
        $$$ThrowStatus($$$ERROR($$$GeneralError, "Server, token and SSL-configuration are required"))
    }
	Set ..Server = server
	Set ..Token = token
	Set ..SSLConfiguration = ssl
	Return $$$OK
}

Method ExecuteRequest(request As %Net.HttpRequest, method As %String) As %DynamicObject
{
    Set request.Server = ..Server
	Set request.SSLConfiguration = ..SSLConfiguration
	Set request.Https = 1 
    $$$ThrowOnError(request.Post("bot"_..Token_"/"_method))
	Return ##class(%Library.DynamicObject).%FromJSON(request.HttpResponse.Data)
}

Method GetUpdates(offset As %Integer = "", limit As %Integer = 100, timeout As %Integer = 0) As %DynamicObject
{
	Set request = ##class(%Net.HttpRequest).%New()
	Set request.Server = ..Server
	Set request.SSLConfiguration = ..SSLConfiguration
	Set request.Https = 1 

	If (offset'="") {
		Do request.InsertFormData("offset",offset)
	}
	Do request.InsertFormData("limit",limit)
	Do request.InsertFormData("timeout",timeout)
	Return ..ExecuteRequest(request, "getUpdates")
}

}
