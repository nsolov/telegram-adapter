Class Telegram.WebHookService Extends Ens.BusinessService
{

Property Target;

Parameter SETTINGS = "Target:Telegram:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    If (..Target = "") {
        Return $$$ERROR(5001, "Target property required")
    }
    Set msg = ##class(Telegram.JSONContainer).%New(pInput)
    Return ..SendRequestAsync(..Target, msg)
}

}
