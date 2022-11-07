Include Ensemble

Class Telegram.OutboundAdapter Extends Ens.OutboundAdapter
{

Property Server As %String [ InitialExpression = "api.telegram.org" ];

Property Token As %String;

Property SSLConfig As %String;

Parameter SETTINGS As %String = "Server:Connection,Token:Connection,SSLConfig:Connection:sslConfigSelector";

Property API As Telegram.API [ Private ];

Method OnInit() As %Status
{
    Try {
        Set ..API = ##class(Telegram.API).%New(..Server, ..Token, ..SSLConfig)
    } Catch ex {
        Return ex.AsStatus()
    }
    Return $$$OK
}

Method ExecuteRequest(Output resultMessage As %DynamicAbstractObject, request As %Net.HttpRequest, method As %String) As %Status
{
    Try {
        If ('$IsObject(..API)) {
            $$$ThrowStatus($$$ERROR($$$GeneralError, "Сonnection not initialized"))
        }
        Set resultMessage = ..API.ExecuteRequest(request, method)
    } Catch ex {
        Return ex.AsStatus()
    }
    Return $$$OK
}

Method SendSimpleMessage(Output resultMessage As %DynamicAbstractObject, chatId As %Integer, text As %String, ReplyToMessageId) As %Status
{
    Set HTTPrequest = ##class(%Net.HttpRequest).%New()
    Do HTTPrequest.InsertFormData("chat_id",chatId)
	Do HTTPrequest.InsertFormData("text",text)
    Do HTTPrequest.InsertFormData("parseMode","MarkdownV2")
    Try {
        Set resultMessage = ..API.ExecuteRequest(HTTPrequest, "sendMessage")
    } Catch ex {
        Return ex.AsStatus()
    }
    Return $$$OK
}

}
