Class Telegram.Demo.NewUserTransform Extends Ens.DataTransform [ DependsOn = (Telegram.JSONContainer, Telegram.Request) ]
{

ClassMethod Transform(source As Telegram.JSONContainer, ByRef target As Telegram.Request) As %Status
{
    Set tSC = $$$OK
    Try {
        Set target = ##class(Telegram.Request).%New()
        Set data = {
            "chat_id": (source.Data.message.chat.id),
            "text": ("Welcome "_source.Data.message."new_chat_participant"."first_name")
        }
        Set target.Data = data
        Set target.Method = "sendMessage" 
    } Catch ex {
        Set tSC = ex.AsStatus()
    }
    Return tSC
}

}
