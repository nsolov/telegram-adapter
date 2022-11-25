Class Telegram.JSONRequest Extends Ens.Request
{

Method %OnNew(data As %DynamicAbstractObject) As %Status
{
    Set ..Data = data
    Return $$$OK
}

Property Data As %DynamicAbstractObject;

Storage Default
{
<Data name="Data">
<Attribute>Data</Attribute>
<Structure>node</Structure>
<Subscript>"Telegram.JSONRequest.Data"</Subscript>
</Data>
<Type>%Storage.Persistent</Type>
}

}
