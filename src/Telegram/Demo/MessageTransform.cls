Class Telegram.Demo.MessageTransform Extends Ens.DataTransform [ DependsOn = (Telegram.JSONRequest, Telegram.Request) ]
{

ClassMethod Transform(source As Telegram.JSONRequest, ByRef target As Telegram.Request) As %Status
{
    Set tSC = $$$OK
    Try {
        Set filename = "/irisdev/app/IRIS-logo.png" 

        Set target = ##class(Telegram.Request).%New()

        If ( ##class(%File).Exists(filename)) {
            Set target.Method = "sendPhoto"
            Set data = {
                "chat_id": (source.Data.message.chat.id),
                "photo": (filename),
                "caption": ("IRIS Echo: "_source.Data.message.text),
                "reply_to_message_id": (source.Data.message."message_id"),
                "protect_content": 1
            }
            Do target.Files.Insert(filename)
        } Else {
            Set target.Method = "sendMessage"
            Set data = {
                "chat_id": (source.Data.message.chat.id),
                "text": ("IRIS Echo: "_source.Data.message.text),
                "reply_to_message_id": (source.Data.message."message_id")
            }
        }
        Set target.Data = data
    } Catch ex {
        Set tSC = ex.AsStatus()
    }
    Return tSC
}

}
