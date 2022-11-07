Class Telegram.Demo.TGBusinessService Extends Ens.BusinessService
{

Parameter ADAPTER = "Telegram.InboundAdapter";

Property ImageFilename As %String [ InitialExpression = "/irisdev/app/IRIS-logo.png" ];

Parameter SETTINGS As %String = "ImageFilename:TelegramDemo";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    Set tr = ##class(Telegram.Request).%New()
    If (pInput.message."new_chat_participant" '= "") {
        Set data = {
            "chat_id": (pInput.message.chat.id),
            "text": ("Welcome "_pInput.message."new_chat_participant"."first_name")
        }
        Set tr.Data = data.%ToJSON()
        Set tr.Method = "sendMessage"
    } ElseIf (pInput.message.text '= "") {
        Set data = {
            "chat_id": (pInput.message.chat.id),
            "photo": (..ImageFilename),
            "caption": ("IRIS Echo: "_pInput.message.text),
            "reply_to_message_id": (pInput.message."message_id"),
            "protect_content": 1
        }
        Set tr.Data = data.%ToJSON()
        Set tr.Method = "sendPhoto"
        Do tr.Files.Insert(..ImageFilename)
    }
    
    If (tr.Method '= "") {  
        Return ..SendRequestAsync("Telegram.BusinessOperation",tr)
    }
    Return $$$OK
}

}
