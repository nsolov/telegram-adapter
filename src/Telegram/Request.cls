Class Telegram.Request Extends Ens.Request
{

Property Method As %String;

Property Data As %DynamicAbstractObject;

Property Files As list Of %String;

Property HttpRequest As %Net.HttpRequest [ Private, Transient ];

Property RootMIMEPart As %Net.MIMEPart [ Private, Transient ];

Property FilesFound As list Of %String [ Private, Transient ];

Method GetRequest() As %DynamicObject
{
    Set ..HttpRequest = ##class(%Net.HttpRequest).%New()
    Set jo = ..Data
    If (..Files.Count() = 0 ) {
        Set iter = jo.%GetIterator()
        While iter.%GetNext(.key, .value, .type ) { 
            If ( (type="object") || (type="array") ) {
                Do ..HttpRequest.InsertFormData(key,value.%ToJSON())
            } Else {
                Do ..HttpRequest.InsertFormData(key,value)
            }
        }
    } Else {
        Set ..RootMIMEPart = ##class(%Net.MIMEPart).%New()

        Set iter = jo.%GetIterator()
        While iter.%GetNext(.key, .value, .type ) { 
            Do $case(type,
                            "object":..AddObjectValue(key, value),
                            "number":..AddNumberValue(key, value),
                            "string":..AddStringValue(key, value),
                            "array":..AddArrayValue(key, value),
                            "boolean":..AddBooleanValue(key, value)
                    )
        }

        For i=1:1:..FilesFound.Count() {
            Set filename = ""
            Set file = ..FilesFound.GetAt(i)
            If ##class(%File).Exists(file) {
                Set stream = ##class(%Stream.FileBinary).%New()
                Set sc = stream.LinkToFile(file)
                If ($$$ISOK(sc)) {
                    Set filename = ##class(%File).GetFilename(file)
                }
            }
            If (filename '= "") {
                Set BinaryMIMEPart=##class(%Net.MIMEPart).%New()
                Set BinaryMIMEPart.Body = stream
                Do BinaryMIMEPart.SetHeader("Content-Disposition","form-data; name="""_filename_"""; filename="""_filename_"""")
                Do ..RootMIMEPart.Parts.Insert(BinaryMIMEPart)        
            } Else {
                $$$ThrowStatus($$$ERROR($$$GeneralError, "Unable to open file: "_file))
            }
        }

        Set writer=##class(%Net.MIMEWriter).%New()
        Set status=writer.OutputToStream(..HttpRequest.EntityBody)
        Set status=writer.WriteMIMEBody(..RootMIMEPart)
        
        Do ..HttpRequest.SetHeader("Content-Type","multipart/form-data; boundary="_..RootMIMEPart.Boundary)
    }

    Return ..HttpRequest
}

Method AddArrayValue(key As %String, value As %DynamicArray)
{
    Set mediaProp = "media"
    If (key = mediaProp) {
        Set iter = value.%GetIterator()
        While iter.%GetNext(.k, .v) {
            If (v.media '= "") {
                If (..FileFind(v.media, .filename)) {
                    Do value.%Get(k).%Set("media", "attach://"_filename)
                } Else {
                    $$$ThrowStatus($$$ERROR($$$GeneralError,"File not found "_v.media))
                }
            }
        }
    }
    Do ..AddTextPart(key, value.%ToJSON())
}

Method AddObjectValue(key As %String, value As %DynamicObject)
{
    Do ..AddTextPart(key, value.%ToJSON())
}

Method AddNumberValue(key, value)
{
    Do ..AddTextPart(key, value)
}

Method AddBooleanValue(key, value)
{
    Do ..AddTextPart(key, value)
}

Method AddStringValue(key, value)
{
    Set inputFilePropsList = $LISTBUILD("photo", "audio", "thumb", "document", "video", "animation", "voice", "video_note")
    If ( $LISTFIND(inputFilePropsList, key) '= 0 ) {
        If (..FileFind(value, .filename)) {
            Set value = "attach://"_filename
        } Else {
            $$$ThrowStatus($$$ERROR($$$GeneralError,"File not found "_value))
        }
    }
    Do ..AddTextPart(key, value)
}

Method FileFind(filePath As %String, Output fileName As %String) As %Boolean
{
    Set fileName = ""
    If ( "" = ..Files.Find(filePath) ) {
        Return 0
    }
    If ##class(%File).Exists(filePath) {
        Set fileName = ##class(%File).GetFilename(filePath)
        If fileName '= "" {
            Do ..FilesFound.Insert(filePath)
            Return 1
        }
    }
    Return 0
}

Method AddTextPart(name As %String, value As %String) As %Status [ Private ]
{
    Set value = $ZCONVERT(value,"O","UTF8")
	Set TextMIMEPart=##class(%Net.MIMEPart).%New()
	Set TextMIMEPart.Body=##class(%Stream.GlobalCharacter).%New()
	Do TextMIMEPart.Body.Write(value)
	Do TextMIMEPart.SetHeader("Content-Disposition","form-data; name="""_name_"""")
	Do ..RootMIMEPart.Parts.Insert(TextMIMEPart)
}

Storage Default
{
<Data name="Data">
<Attribute>Data</Attribute>
<Structure>node</Structure>
<Subscript>"Telegram.Request.Data"</Subscript>
</Data>
<Data name="RequestDefaultData">
<Subscript>"Request"</Subscript>
<Value name="1">
<Value>Method</Value>
</Value>
<Value name="2">
<Value>Files</Value>
</Value>
</Data>
<DefaultData>RequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
