# Telegram adapter for InterSystems IRIS

IRIS Telegram adapter allows you to easily add connection to telegram API to your integration solution.

You can use the Telegram adapter to solve simple tasks, such as sending notifications from IRIS to telegram chats, or to create more complex scenarios for using one or more Telegram bots.

Telegram adapter includes:
+ Telegram package - main classes
+ The Telegram.Demo package is a demo example of using the adapter.
+ Web application /tg for webhooks

## Using  the Telegram adapter

### Outbound Adapter

The Telegram API provides a set of methods https://core.telegram.org/bots/api#available-methods that allow you to send various types of messages or perform other actions to manage chats.

To call any of these methods, you should:

1. Install telegram adapter
2. Add a business-operation Telegram.BusinessOperation to your Production
3. Specify the required parameters for connecting to the telegram API (Connection Settings block)
   + Server (обычно api.telegram.org)
   + Token (как получить токен)
   + SSL Configuration
4. Create a message object of the Telegram.Request class, specify its properties, and send to business operation Telegram.BusinessOperation

Example 1

```
    Set msg = ##class(Telegram.Request).%New()
    Set msg.Method = "sendMessage"
    Set msg.Data = {
        "chat_id" : (сhatId),
        "text": "Some text here"
    }
    Return ..SendRequestAsync("Telegram.BusinessOperation", msg)
```

Property `Method` - The Telegram API Method
Property `Data` – JSON object, the fields of which correspond to those described in the documentation https://core.telegram.org/bots/api#available-methods.

If the Telegram API method involves sending files/photos/videos/audio, then you should specify the full file name in the corresponding field, and at the same time add this file name to the Files collection. The specified file must exist and be readable.

Example 2

```
    Set msg = ##class(Telegram.Request).%New()
    Set msg.Method = "sendPhoto"
    Set msg.Data = {
            "chat_id": (chatId),
            "photo": "/my/photo/1.jpg"
       }
    Do msg.Files.Insert("/my/photo/1.jpg")
    Return ..SendRequestAsync("Telegram.BusinessOperation", msg)
```

The data received from the Telegram API is available in the response object.

Example 3. 
```
    Set msg = ##class(Telegram.Request).%New()
    Set msg.Method = "getMe"
    Set tSC = ..SendRequestSync("Telegram.BusinessOperation", msg, .response)
    $$$TRACE(response.Data.%ToJSON())
```

### Inbound Adapter

Allows you to receive data from telegram (messages written by other users in the chat).
 
2 options are supported:
* Webhook
* Periodic polling of the Telegram API to get updates

## How to get a token

Use telegram bot @BotFather. Use the /newbot command to create a new bot - you will receive a token (token example 110201543:AAHdqTcvCH1vGWJxfSeofSAs0K5PALDsaw). Read more here https://core.telegram.org/bots/features#botfather.

## Demo Echo demo app 

With this App bot answers to any message in a chat

To Run it:
1. Install telegram adapter
2. Open production Telegram.Demo.EchoProduction
3. Create a telegram bot and get a token (see below)
4. Specify the required parameters for connecting to the telegram API in the Telegram.BusinessOperation business operation and in the Telegram.Demo.TGBusinessService business service (Connection Settings block)
   * Server (usually api.telegram.org)
   * Token
   * SSL Configuration
5. Create a chat in telegram
6. Add the created bot as a user to the created chat and give it administrator rights
7. Launch production
8. Add another user to the chat - you will see a greeting from IRIS
9. Write something in the chat - you will see Echo from IRIS

