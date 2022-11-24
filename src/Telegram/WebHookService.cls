Class Telegram.WebHookService Extends Ens.BusinessService
{

Property Target;

Parameter SETTINGS = "Target:aaa:selector?context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId}";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{
    If (..Target = "") {
        Return $$$ERROR(5001, "Target property required")
    }
    Set msg = ##class(Ens.StringContainer).%New(pInput.%ToJSON())
    Return ..SendRequestAsync(..Target, msg)
}

}
