//+------------------------------------------------------------------+
//|                                                MT5toTelegram.mq5 |
//|              Copyright 2021, Kiganjani Technologies Company Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
   #property copyright "Copyright 2021, Kiganjani Technologies Company Ltd."
   #property link      "https://www.mql5.com"
   #property version   "1.00"
   
   #property strict
   #include <Telegram.mqh>

//+------------------------------------------------------------------+
//| CMyBot                                                           |
//+------------------------------------------------------------------+

   class CMyBot: public CCustomBot{
   
         public: void ProcessMessages(void){
         
               for(int i=0; i<m_chats.Total(); i++){
               
                  CCustomChat *chat=m_chats.GetNodeAtIndex(i);
                  
                  //--- If Message is not Processed
                  if(!chat.m_new_one.done){
                  
                     chat.m_new_one.done = true;
                     string text=chat.m_new_one.message_text;
                     
                     //-- Start
                     if(text=="/start")
                        SendMessage(chat.m_id, "Hello, I am FX four_The$20s Bot.\n\n My commands list: \n/start - Start chatting with me. \n/help - Get help (FAQs)");
                        
                     //-- Help
                     if(text=="/help")
                        SendMessage(chat.m_id,"FAQ \n ");
                     }
                     
                  }
                  
               }
               
            };
   
   input string InpChannelName ="";       //Channel Name
   input string InpToken       ="";       //Bot Token
   input long   ChatID         = 0;
   
   CMyBot bot;
   int getme_result;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+

   int OnInit()
     {
   //---
      bot.Token(InpToken);          //Set Token
      getme_result=bot.GetMe();     //Check Token
      
      EventSetTimer(3);             //Run Timer
      OnTimer();
   //---
      return(INIT_SUCCEEDED);
     }
  
  
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+

   void OnDeinit(const int reason)
     {
      Comment("");
     }
     
  
//+------------------------------------------------------------------+
//| OnTimer                                                          |
//+------------------------------------------------------------------+

   void OnTimer()
     {
         //--- Show Error Message and Exit
         if(getme_result!=0){
         Comment("Error: ",GetErrorDescription(getme_result));
         return;
         }
      
         //--- Show Bot Name
         Comment("Bot Name: ",bot.Name());
         
         //--- Reading Messages
         bot.GetUpdates();
         
         //--- Processing Messages
         bot.ProcessMessages();   
     }
  
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
   void OnTick()
     {
   //---
      
     }


//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
   void OnTradeTransaction(const MqlTradeTransaction &trans, const MqlTradeRequest &request, const MqlTradeResult &result)
      {
      TRADE_TRANSACTION_ORDER_ADD – adding a new active order
      TRADE_TRANSACTION_ORDER_UPDATE – changing an existing order
      TRADE_TRANSACTION_ORDER_DELETE – deleting an order from the list of active ones
      TRADE_TRANSACTION_POSITION – position change not related to a trade execution
      
      if( )
         {
            string msg=StringFormat("Trade Signal \nSymbol: %s \nOrder Type: %s \nEntry Price: %s \nStop Loss: %s \nTake Profit: %s",
                                    _Symbol,
                                    StringSubstr(EnumToString((ENUM_TIMEFRAMES)_Period),7),
                                    DoubleToString(SymbolInfoDouble(_Symbol,SYMBOL_ASK),_Digits),
                                    TimeToString(time[0]));
            int res=bot.SendMessage(InpChannelName,msg);
            if(res!=0)
               Print("Error: ",GetErrorDescription(res));
         }
      }
//+------------------------------------------------------------------+                        