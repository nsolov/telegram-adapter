Class Telegram.BusinessOperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "Telegram.OutboundAdapter";

Property Adapter As Telegram.OutboundAdapter;

Method ProcessRequest(pRequest As Telegram.Request, Output pResponse As Ens.StringContainer) As %Status
{
    Try {
      Set tSC = ..Adapter.ExecuteRequest(.jo, pRequest.GetRequest(), pRequest.Method)
      If (jo.ok = 0) {
        $$$ThrowStatus($$$ERROR($$$GeneralError,jo."error_code"_": "_jo.description))
      }
      Set pResponse = ##class(Ens.StringContainer).%New(jo.%ToJSON())
    } Catch ex {
      Set tSC = ex.AsStatus()
    }
    Return tSC
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Telegram.Request">
    <Method>ProcessRequest</Method>
  </MapItem>
</MapItems>
}

}
