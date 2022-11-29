Class Telegram.JSONContainer Extends (%Persistent, %XML.Adaptor)
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
<Subscript>"Telegram.JSONContainer.Data"</Subscript>
</Data>
<Data name="JSONContainerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^Telegram.JSONContainerD</DataLocation>
<DefaultData>JSONContainerDefaultData</DefaultData>
<IdLocation>^Telegram.JSONContainerD</IdLocation>
<IndexLocation>^Telegram.JSONContainerI</IndexLocation>
<StreamLocation>^Telegram.JSONContainerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
