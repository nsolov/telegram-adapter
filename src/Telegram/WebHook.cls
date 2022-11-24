Class Telegram.WebHook Extends %CSP.REST
{

XData UrlMap
{
<Routes>
	<Route Url="/update" Method="POST" Call="ProcessUpdate" />
</Routes>
}

ClassMethod ProcessUpdate() As %Status
{
    Try {
	    Set obj = ##class(%DynamicAbstractObject).%FromJSON(%request.Content)
        Set ^updates($zdt($Now(),3,,6)) = obj.%ToJSON() // debug
        $$$ThrowOnError(##class(Ens.Director).CreateBusinessService("Telegram.WebHookService",.tService))
        $$$ThrowOnError(tService.ProcessInput(obj,.output))
    } Catch ex {
        Return ex.AsStatus()
    }
	Return $$$OK
}

}
