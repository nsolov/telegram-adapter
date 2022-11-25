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
    <Setting Target="Adapter" Name="CallInterval">2</Setting>
    <Setting Target="Host" Name="Target">MessageRouting</Setting>
  </Item>
  <Item Name="Telegram.WebHookService" Category="" ClassName="Telegram.WebHookService" PoolSize="0" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Target"></Setting>
  </Item>
  <Item Name="MessageRouting" Category="" ClassName="EnsLib.MsgRouter.RoutingEngine" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="BusinessRuleName">Telegram.Demo.filterMessagesRule</Setting>
  </Item>
</Production>
}

}
