Class Telegram.Demo.EchoProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Telegram.Demo.EchoProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="Telegram.BusinessOperation" Category="" ClassName="Telegram.BusinessOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfig">tg</Setting>
    <Setting Target="Adapter" Name="Token"></Setting>
  </Item>
  <Item Name="Telegram.Demo.TGBusinessService" Category="" ClassName="Telegram.Demo.TGBusinessService" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="SSLConfig">tg</Setting>
    <Setting Target="Adapter" Name="Token"></Setting>
  </Item>
</Production>
}

}
