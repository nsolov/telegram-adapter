Class App.Installer
{

XData setup
{
<Manifest>
    <Default Name="APPPATH" Dir="#{$system.Process.CurrentDirectory()}" />
    <Default Name="SourceDir" Value="${APPPATH}src"/>
    <Default Name="NAMESPACE" Value="TG"/>
    <Default Name="DBNAME" Value="TG"/>
    <Default Name="RESOURCE" Value="%DB_${DBNAME}" /> 

    <Namespace Name="${NAMESPACE}" Code="${DBNAME}-CODE" Data="${DBNAME}-DATA" Create="yes" Ensemble="1">
        <Configuration>
            <Database Name="${DBNAME}-CODE" Dir="${APPPATH}${DBNAME}-CODE" Create="yes" Resource="${RESOURCE}"/>
            <Database Name="${DBNAME}-DATA" Dir="${APPPATH}${DBNAME}-DATA" Create="yes" Resource="${RESOURCE}"/>
        </Configuration>
        <Import File="${SourceDir}" Flags="ck" Recurse="1"/>
        <CSPApplication
            Url="/tg"
            Description="REST App for webhooks"
            name="/tg"
            Directory="/mysrc"
            AuthenticationMethods="64"
            AutoCompile="0"
            Recurse="1"
            Resource=""
            Grant="%All" />
    </Namespace>
    <Invoke Class="App.Installer" Method="createSSLConfig" CheckStatus="1"></Invoke>
    <Invoke Class="App.Installer" Method="SetDispatchClass" CheckStatus="1">
        <Arg Value="/tg"/>
        <Arg Value="Telegram.WebHook"/>
    </Invoke>

</Manifest>
}

ClassMethod setup(ByRef pVars, pLogLevel As %Integer = 3, pInstaller As %Installer.Installer, pLogger As %Installer.AbstractLogger) As %Status [ CodeMode = objectgenerator, Internal ]
{
    #; Let XGL document generate code for this method. 
    Quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "setup")
}

ClassMethod SetDispatchClass(pApp As %String = "", pClass As %String = "") As %Status
{
    set $namespace = "%SYS"
    set sc = ##class(Security.Applications).Exists(pApp,.app)
    return:($$$ISERR(sc)) sc
    set app.DispatchClass = pClass
    return app.%Save()
}

ClassMethod createSSLConfig() As %Status
{
    Set configname = "tg" 
    New $NAMESPACE
    Set $NAMESPACE = "%SYS"
    If ('##class(Security.SSLConfigs).Exists(configname)) {
        Do ##class(Security.SSLConfigs).Create(configname)
    }
    Return $$$OK
}

}
