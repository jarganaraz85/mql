//+------------------------------------------------------------------+
//|                                           Milito_chichi_vega.mq4 |
//|                                                   Juan Argañaraz |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Juan Argañaraz"
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

#include "stdlib.mqh"
#include "Telegram.mqh"		// Necesario para que funcione enviar mensajes a Telegram
//--- input parameters
input double lotSizeParam=0.04;
input double maxLotSizeAllowed=0.4;
extern int numberOfOrdersParam = 3;
extern bool usecalculatelot = true;
extern bool closeAfterExecute = true;
extern  bool useStopLossProtection = true;
extern bool sendTelegramMessages = true;
extern bool sendPushNotifications = false; 
extern bool showLogs = true; 
extern int slippage  = 3;
extern double tickdiffanul = 0.00005; 
 extern bool useautomaticmagicnumber = true;
 extern int SetOrderID=1543583;       //Magic Number to use for the orders
extern int SecondOrderID=1543584;       //Magic Number to use for the orders
extern int ThirorderID=1543585;       //Magic Number to use for the orders
extern bool coinflip = false;
input string          InpName="orderTriggerLine"; // Line name
input string          InpName2="stopLossLine"; // Line name
input string          InpName3="anulationLine"; // Line name
input color           InpColor=clrGreen;     // Line color
input color           InpColor2=clrRed;     // Line color
input color           InpColor3=clrRed;     // Line color
input ENUM_LINE_STYLE InpStyle=STYLE_DASH; // Line style
input ENUM_LINE_STYLE InpStyle2=STYLE_DASH; // Line style
input ENUM_LINE_STYLE InpStyle3=STYLE_DASHDOT; // Line style
input int             InpWidth=1;          // Line width
input bool            InpBack=false;       // Background line
input bool            InpSelection=true;   // Highlight to move
input bool            InpHidden=true;      // Hidden in the object list
input long            InpZOrder=0;         // Priority for mouse click

 //extern string TELEGRAM_MESSAGES;
    //string 	aaa			= "====== Configuracion Telegram ========";	// =================
    ENUM_LANGUAGES    InpLanguage=LANGUAGE_EN;//Language
   string 	InpToken		= "762665781:AAGBkpf6yaOhRap4m87ixOyqdEnnmXnRMpM";	// Token del bot // test "854948219:AAGqWAj4IYiTlLY-t0J8CMKnn6EWPSJWaSI";//
    string 	userauth		= "@argjuan85"; //usuarios permitidos por el bot para operar
//--- definitions for telegram messaged

//+------------------------------------------------------------------+
//|   CMyBot                                                         |
//+------------------------------------------------------------------+
class CMyBot: public CCustomBot
  {
private:
   ENUM_LANGUAGES    m_lang;
public:
   //+------------------------------------------------------------------+
   void CMyBot::CMyBot(void)
     {
     }
   //+------------------------------------------------------------------+
  };
  CMyBot bot;
  
  
// internal variables 
double lotSize,orderLots[],orderTriggerLevel, stopLossLevel, value, value1, value2, value3, value4, lotCalc, buyGoal, sellGoal, stopLossOrder, stopLoss, takeProfit, orderStopLossLevel, orderTypeSet,orderOpenLevel, takeProfitCalc, anulationLine, stopLossProtection;
string strMyObjectName, textSend, messageText;
bool confirmationOp,resultTicket,orderSetConfirmation,opanulada, orderTypeToClose, ordersSetted,confirmAnulation,hideButtonsGlobal;
int orderTicket, ticket, orderId,openOrderType, message, orderTypeClicked, tickets[], orderTypes[],numberOfOrders;

//not sure if its needed, i'm keeping it for now
 static bool tfControl = False;
 string testGv="GV_Test"; 
 
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() {
numberOfOrders= numberOfOrdersParam +1;
hideButtonsGlobal = false;
 bot.Token(InpToken);

  //on production I need to clear buttons when importing from analisis mt4
   DeleteButtons();  
   Comment("");
      ObjectDelete("Milito Vega Draw");
   //end prod 
   int aaa = GlobalVariableGet(testGv);
   //Print ( "Gv Value: " + aaa );
   aaa = aaa +1;
   GlobalVariableSet(testGv, aaa);
   //array initialization
    ArrayResize(tickets,4);
    ArrayResize(orderLots,4);
    ArrayResize(orderTypes,4);
    lotSize = lotSizeParam;
   confirmationOp = false; ordersSetted = false;
   confirmAnulation = false;
   strMyObjectName = "Milito Chichi 1.0";
   string strMyObjectText, msg;
   // Create text object with given name
   ObjectCreate(strMyObjectName, OBJ_LABEL, 0, 0, 0, 0);
   // Set pixel co-ordinates from top left corner (use OBJPROP_CORNER to set a different corner)
   ObjectSet(strMyObjectName, OBJPROP_XDISTANCE, 15);
   ObjectSet(strMyObjectName, OBJPROP_YDISTANCE, 95);

   int x=10;
   
   if (useautomaticmagicnumber)
      orderId = magicNumberGenerator();//jenkinsHash(Symbol(),Period());
   else
      orderId = SetOrderID;
   if (showLogs)
      Print ( "My magic numer is: " +  orderId + " - lenght: " + StringLen(orderId));
   if ( orderId >= 2147483647) {
     msg = "Magic numer out of range, check!!!!!!!";
     Print (msg);
     orderId = 0;
      strMyObjectText = msg;
   }
   else {
   
   CreateButton("button14","Hide" ,x,20,80,30,White,Gray,White,10); //not in use I added it to let .16 in the lower part
   x= x -90;
   CreateButton("button2","Buy LO" ,x,60,80,30,White,Gray,White,10);
   CreateButton("button1","Buy Market ",x,20,80,30,White,Gray,White,10);
   x= x -90;
   CreateButton("button4","Sell LO" ,x,60,80,30,White,Gray,White,10);
   CreateButton("button3","Sell Market" ,x,20,80,30,White,Gray,White,10);
   x= x -90;
   CreateButton("button6","Close EA" ,x,60,80,30,White,Gray,White,10);
   CreateButton("button5","Close order" ,x,20,80,30,White,Gray,White,10);
   x= x -90;
   CreateButton("button9",".04" ,x,60,80,30,White,Gray,White,10);
   CreateButton("button7","Confirm" ,x,20,80,30,White,Gray,White,10);
   x= x -90;
   CreateButton("button10",".08" ,x,60,80,30,White,Gray,White,10);
   CreateButton("button8","Rectangle" ,x,20,80,30,White,Gray,White,10);
   x= x -90;
   CreateButton("button11",".12" ,x,60,80,30,White,Gray,White,10);
   if (useStopLossProtection)
   CreateButton("button13","Prot On" ,x,20,80,30,White,Green,White,10);
   else
   CreateButton("button13","Prot Off" ,x,20,80,30,White,Green,White,10);
   x= x -90;
   CreateButton("button12",".16" ,x,60,80,30,White,Gray,White,10);
  
   


  

   
   
  if(!HLineCreate(0,InpName,0,Bid-300*Point,InpColor,InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder)) {
   Print("Error creating Order Trigger Line, please check");
  }
  else { 
   ObjectGetDouble(0,InpName,OBJPROP_PRICE,0,value);
   Print("Order trigger line created at: " +  ND(value)); 
   orderTriggerLevel = ND(value); 
  }
  
  if(!HLineCreate(0,InpName2,0,Bid+100*Point,InpColor2,InpStyle3,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder)) {
   Print("Error creating Stop Loss Line, please check");
  }
  else { 
   ObjectGetDouble(0,InpName2,OBJPROP_PRICE,0,value2);
   Print("Stop Loss line setted in: " + ND(value2)); 
   stopLossLevel = ND(value2); 
  } 
  
  if(!HLineCreate(0,InpName3,0,Bid+260*Point,InpColor3,InpStyle2,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder)) {
       Print("No se pudo colocar la linea de anulacion , revisar ");
  }
  else {                 
   ObjectGetDouble(0,InpName3,OBJPROP_PRICE,0,value3);
   Print("Linea de anulacion seteada en: " + ND(value3)); 
   anulationLine = ND(value3);  
  }
   strMyObjectText = "Init Ok";
   ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Green);
   return(INIT_SUCCEEDED);
  } //end else from orderid handler
  ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Green);
  return(INIT_PARAMETERS_INCORRECT);
}
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) {
   DeleteButtons();
    HLineDelete(0,InpName);   HLineDelete(0,InpName2); HLineDelete(0,InpName3);
   Comment("");
   ObjectDelete(strMyObjectName);
}
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() {

  //--- control anulacion 
  if ((confirmAnulation) && (!opanulada) && (( (orderTypeClicked == 1) && (MathAbs(Bid-ND(anulationLine)) <= tickdiffanul ) ) || ((orderTypeClicked == 0) && (MathAbs(Ask-ND(anulationLine)) <= tickdiffanul ) )))  {
     if (showLogs)
     Print (" Borrando lineas....");
     if (!orderTypeToClose){
     closeOrders(tickets,orderLots,orderTypes);  // revisar si da error con la parte que borra las lineas
     }
     else {
        closeLimitOrders(tickets);
     }
     opanulada = true;
     confirmAnulation = false;
     HLineDelete(0,InpName);
     HLineDelete(0,InpName2);
     HLineDelete(0,InpName3);
     textSend= "Seteo anulado " + _Symbol;
     sendNotifications(textSend);
   }
   
}

//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id, const long &lparam, const double &dparam, const string &sparam) {
int i;
string strMyObjectText;
//order trigger line
   if(id==CHARTEVENT_OBJECT_DRAG) {
      if (sparam == "orderTriggerLine") { 
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,value);
         Print("OrderTriggerLine setted in: " +  ND(value)); 
         orderTriggerLevel = NormalizeDouble(value,Digits);
         ratioCalc(0,0); 
      }
   }
//stop loss line
   if(id==CHARTEVENT_OBJECT_DRAG) {
      if (sparam == "stopLossLine") { 
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,value1);
         Print("stopLossLine setted in: " +  ND(value1)); 
         stopLossLevel = ND(value1); 
         ratioCalc(0,0);
      }
   }
   //seteo linea de anulacion
   if(id==CHARTEVENT_OBJECT_DRAG) {
     if (sparam == "anulationLine") {  
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,value4);
         Print("Linea de anulacion seteada en: " + ND(value4)); 
         anulationLine = ND(value4); 
         }
     }
  
// market order send 
   if(sparam=="button1") {
     if (!ordersSetted) {
       message =   MessageBox("Do you really wish to send a buy market order?","Confirm", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
      if (message == 6) {
         lotCalc = NormalizeDouble(Calculatelot(),3);
         if ((lotSize > lotCalc) && (usecalculatelot)) //a simple control if we misstype the lotsize
                  ObjectSetText(strMyObjectName, "Please check the lot size!!", 8, "Arial Black", Red);
         else {         
            orderTypeToClose = false;
            confirmationOp = True;
            orderTypeClicked = 0;
            //setting orders
            if (coinflip) {
            for (i=1;i<numberOfOrders;i++){
            takeProfitCalc = ratioCalc(1,0,MathPow(2,i));
            orderLots[i] = lotSize/2;
            tickets[i]=setOrder(1,orderLots[i], takeProfitCalc, i);
            orderTypes[i] = 1;
            }
            }
            else {
            for (i=1;i<numberOfOrders;i++){
            takeProfitCalc = ratioCalc(1,0,MathPow(2,i));
            if (i<3) {
            orderLots[i] = lotSize/(i*2);
            } else {
            orderLots[i] = orderLots[i-1];
            }
            tickets[i]=setOrder(1,orderLots[i], takeProfitCalc, i);
            orderTypes[i] = 1;
            }
            }
            orderSendNotification(tickets[numberOfOrders-1],1);   
            if (closeAfterExecute) {
             Print ( "closing...");
             ExpertRemove();
            }
            ObjectSetInteger(0,"button1",OBJPROP_STATE,false);
         }
      }
     }   
     else {
       messageText = " There is a set of orders already open ";
       ObjectSetText(strMyObjectName, messageText, 12, "Arial Black", Black);
     } 
   }
   if(sparam=="button3") {
     if (!ordersSetted) {
       message =   MessageBox("Do you really wish to send a sell market order?","Confirm", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
      if (message == 6) {
         lotCalc = NormalizeDouble(Calculatelot(),3);
         if ((lotSize > lotCalc) && (usecalculatelot))
                  ObjectSetText(strMyObjectName, "Please check the lot size!!", 8, "Arial Black", Red);
         else {         
            orderTypeToClose = false;
            confirmationOp = True;
            orderTypeClicked = 1;
        
            //setting orders
            if (coinflip) {
            for (i=1;i<numberOfOrders;i++){
            takeProfitCalc = ratioCalc(1,0,MathPow(2,i));
            orderLots[i] = lotSize/2;
            tickets[i]=setOrder(0,orderLots[i], takeProfitCalc, i);
            orderTypes[i] = 1;
            }
            }
            else {
            for (i=1;i<numberOfOrders;i++){
            takeProfitCalc = ratioCalc(1,1,MathPow(2,i));
            if (i<3) {
            orderLots[i] = lotSize/(i*2);
            } else {
            orderLots[i] = orderLots[i-1];
            }
            Print ( "tp to set" + takeProfitCalc);
            tickets[i]=setOrder(0,orderLots[i], takeProfitCalc,i);
            orderTypes[i] = 1;
            }
            }
            
            orderSendNotification(tickets[numberOfOrders-1],1);           
            ObjectSetInteger(0,"button3",OBJPROP_STATE,false);
            if (closeAfterExecute) {
             Print ( "closing...");
             ExpertRemove();
            }
         }
      }
    }
    else {
       messageText = " There is a set of orders already open ";
       ObjectSetText(strMyObjectName, messageText, 12, "Arial Black", Black);
     }     
   }
   if(sparam=="button4") {
      if (!ordersSetted) {
       message =   MessageBox("Do you really wish to send a sell limit order?","Confirm", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
      if (message == 6) {
         lotCalc = ND(Calculatelot());
         if ((lotSize > lotCalc) && (usecalculatelot))
                  ObjectSetText(strMyObjectName, "Please check the lot size!!", 8, "Arial Black", Red);
         else {
            orderTypeToClose = true;
            // check!!! dego is this being used? )confimation o´?
            confirmationOp = True;
            orderTypeClicked = 1;
             //setting orders
            for (i=1;i<numberOfOrders;i++){
            takeProfitCalc = ratioCalc(0,1,MathPow(2,i));
            if (i<3) {
            orderLots[i] = lotSize/(i*2);
            } else {
            orderLots[i] = orderLots[i-1];
            }
            tickets[i]= setOrderLimit(0,orderLots[i], takeProfitCalc);
            orderTypes[i] = 1;
            }
            orderSendNotification(tickets[3],0);
            ObjectSetInteger(0,"button4",OBJPROP_STATE,false);
            if (closeAfterExecute) {
             Print ( "closing...");
             ExpertRemove();
            }
         }
      }
     }
     else {
       messageText = " There is a set of orders already open ";
       ObjectSetText(strMyObjectName, messageText, 12, "Arial Black", Black);
     } 
   }
   if(sparam=="button2") { 
     if (!ordersSetted) {
      message =   MessageBox("Do you really wish to send a buy limit order?","Confirm", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
      if (message == 6) {
         lotCalc = ND(Calculatelot());
         if ((lotSize > lotCalc) && (usecalculatelot))
                  ObjectSetText(strMyObjectName, "Please check the lot size!!", 8, "Arial Black", Red);
         else {            
            orderTypeToClose = true;
            // check!!! dego is this being used? )confimation o´?
            confirmationOp = True;
            orderTypeClicked = 0;
             //setting orders
            for (i=1;i<numberOfOrders;i++){
            takeProfitCalc = ratioCalc(0,1,MathPow(2,i));
            if (i<3) {
            orderLots[i] = lotSize/(i*2);
            } else {
            orderLots[i] = orderLots[i-1];
            }
            tickets[i]= setOrderLimit(1,orderLots[i], takeProfitCalc);
     
            
            orderTypes[i] = 0;
            }
            orderSendNotification(tickets[3],0);
            ObjectSetInteger(0,"button2",OBJPROP_STATE,false);
             if (closeAfterExecute) {
             Print ( "closing...");
             ExpertRemove();
            }
         }
      } 
    } 
     else {
       messageText = " There is a set of orders already open ";
       ObjectSetText(strMyObjectName, messageText, 12, "Arial Black", Black);
     }  
   } 
      if(sparam=="button7") {//  confirm
         confirmAnulation = true;
      }
      
      if(sparam=="button8") {//  this is just for test, erase it when u're done
      color rect_color = Red;
        // get screen size
    int screen_width = 80;
    int screen_height =80;
        // calculate rectangle coordinates
    int rect_x = screen_width / 2 - 50; // rectangle width is 100
    int rect_y = screen_height / 2 - 50; // rectangle height is 100
    

             // create rectangle object
    ObjectCreate("my_rectangle", OBJ_RECTANGLE, 0, 0, 0);
    // set rectangle color
    ObjectSet("my_rectangle", OBJPROP_COLOR, rect_color);
        // set rectangle coordinates
    ObjectSet("my_rectangle", OBJPROP_XDISTANCE, rect_x);
    ObjectSet("my_rectangle", OBJPROP_YDISTANCE, rect_y);
      }
      
      if(sparam=="button6") {//  EA close
        int testb1 =   MessageBox("Do you really want to close the EA?","Confirm", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
        if (testb1 == 6) {
          ExpertRemove();
          ObjectSetInteger(0,"button6",OBJPROP_STATE,false);
        }
      }
      if(sparam=="button5") { // Close order
        int testb =   MessageBox("Do you really want to close the orders?","Confirm", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
        if (testb == 6) {
          if(!orderTypeToClose) {
          closeOrders(tickets,orderLots,orderTypes);
          ObjectSetInteger(0,"button5",OBJPROP_STATE,false);
          }
          else {
          //closeLimitOrders
          closeLimitOrders(tickets);
          }
           if (orderTypeClicked == 0)
           textSend=Symbol () + " Buy Orders has been closed";
           else
           textSend=Symbol () + " Sell Orders has been closed";
           sendNotifications(textSend,Black);
        }
      }
      
      if(sparam=="button9") {//  change the lotsize parameter
      lotSize = 0.04;
      strMyObjectText = "Lotsize set on .04";
      ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Green);
                  ObjectSetInteger(0,"button9",OBJPROP_STATE,false);
      }
      if(sparam=="button10") {//  change the lotsize parameter
      lotSize = 0.08;
      strMyObjectText = "Lotsize set on .08";
      ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Green);
                  ObjectSetInteger(0,"button10",OBJPROP_STATE,false);
      }
      if(sparam=="button11") {//  change the lotsize parameter
      lotSize = 0.12;
      strMyObjectText = "Lotsize set on .12";
      ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Green);
                  ObjectSetInteger(0,"button11",OBJPROP_STATE,false);
      }
      if(sparam=="button12") {//  change the lotsize parameter
      lotSize = 0.16;
      strMyObjectText = "Lotsize set on .16";
      ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Green);
                  ObjectSetInteger(0,"button12",OBJPROP_STATE,false);
      }
      if (sparam  == "button13") {
        if (ObjectGetString(0,"button13",OBJPROP_TEXT) == "Prot Off")
        {
        ObjectSetString(0,"button13",OBJPROP_TEXT,"Prot On");
          ObjectSetInteger(0,"button13",OBJPROP_BGCOLOR,Green);
          useStopLossProtection = true;
        }
        else if(ObjectGetString(0,"button13",OBJPROP_TEXT) == "Prot On")
         {
                 ObjectSetString(0,"button13",OBJPROP_TEXT,"Prot Off");
                   ObjectSetInteger(0,"button13",OBJPROP_BGCOLOR,Red);
                   useStopLossProtection = false;
         }
         
         ObjectSetInteger(0,"button13",OBJPROP_STATE,false);
      }
               if(sparam=="button14") // Show / Hide buttons
        {
        if (ObjectGetString(0,"button14",OBJPROP_TEXT) == "Show")
        {
        ObjectSetString(0,"button14",OBJPROP_TEXT,"Hide");
         ShowButton("button1");ShowButton("button2");ShowButton("button3");ShowButton("button4");ShowButton("button5");
         ShowButton("button6");ShowButton("button7");ShowButton("button8");ShowButton("button9");ShowButton("button10");
         ShowButton("button11");ShowButton("button12");ShowButton("button13");
         hideButtonsGlobal = false;
        }
        else if(ObjectGetString(0,"button14",OBJPROP_TEXT) == "Hide")
         {
         
         ObjectSetString(0,"button14",OBJPROP_TEXT,"Show");
         hideButtons();
         }
         
         ObjectSetInteger(0,"button14",OBJPROP_STATE,false);
        }
}

//+------------------------------------------------------------------+ 
// Demas funciones
//+----------------+

//alertas por telegram notificaciones push y print
void sendNotifications (string message, color colormsg = Orange) {
   if (sendPushNotifications)
      SendNotification(message);
   Print (message);
   ObjectSetText(strMyObjectName, message, 12, "Arial Black", colormsg);
   if (sendTelegramMessages)
   bot.SendMessage(483136962,message);
}
void orderSendNotification(int ticket, int isLimitOrder) {
   if (showLogs)
   Print (" Cleaning initial lines....");
   opanulada = true; //so it doesnt scan for this
   if (tickets[numberOfOrdersParam] > 0) {
      HLineDelete(0,InpName);
      HLineDelete(0,InpName2);
      if (isLimitOrder) {
         HLineDelete(0,InpName3);
      }
      if (orderTypeClicked == 0)
      textSend= Symbol() + "Buy Orders has been set, total lotsize: " + lotSize;
      else
      textSend= Symbol() + "Sell Orders has been set, total lotsize: " + lotSize;
      
      ordersSetted = true;
      sendNotifications(textSend,LimeGreen);
       
   }
   else if (ticket == -1) {
      ObjectSetText("trying to sell below price or buy above price, please check" , message, 12, "Arial Black", Red);
   } 
   
   else {
      textSend=Symbol() + " Error sending the orders, please check..";
      sendNotifications(textSend,Red);
   }
}

void closeOrders (int &tickets[], double &orderLots[], int &orderTypes[]) {
   int i;
   double closePrice;
   for (i=1;i<4;i++){
      //Print (" tk, OL, OT " + tickets[i] + " - " +  orderLots[i] + " - " +orderTypes[i]);
      if (orderTypes[i] == 1)
      closePrice = Ask;
      else
      closePrice = Bid;
      if(!OrderClose(tickets[i], orderLots[i], closePrice, 3, Red)) {
         Print (" ERROR: Could not close the order: " +  tickets[i] + " message: " + GetLastError());
      }
   }
}

void closeLimitOrders (int &tickets[]) {
    int i;
    for (i=1;i<4;i++){
      if(!OrderDelete(tickets[i])) {
            Print (" fallo al realizar cierre de orden pendiente ");
      }
      else {
             Print ("Se cerro la orden pendiente correctamente");
      }
    }
}

double ND(double val) {
   return(NormalizeDouble(val, Digits));
}

void CreateButton(string btnName,string btnText,int &x,int y,int w,int h,color clrText,color clrBg,color clrBorder,int fontSize) {
   ObjectCreate(0,btnName,OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,btnName,OBJPROP_XDISTANCE,x);
   ObjectSetInteger(0,btnName,OBJPROP_YDISTANCE,y);
   ObjectSetInteger(0,btnName,OBJPROP_XSIZE,w);
   ObjectSetInteger(0,btnName,OBJPROP_YSIZE,h);
   ObjectSetString(0,btnName,OBJPROP_TEXT,btnText);
   ObjectSetInteger(0,btnName,OBJPROP_COLOR,clrText);
   ObjectSetInteger(0,btnName,OBJPROP_BGCOLOR,clrBg);
   ObjectSetInteger(0,btnName,OBJPROP_BORDER_COLOR,clrBorder);
   ObjectSetInteger(0,btnName,OBJPROP_BORDER_TYPE,BORDER_FLAT);
   ObjectSetInteger(0,btnName,OBJPROP_HIDDEN,true);
   ObjectSetInteger(0,btnName,OBJPROP_STATE,false);
   ObjectSetInteger(0,btnName,OBJPROP_FONTSIZE,fontSize);
   x=x+w+10;
}
  
void DeleteButtons() {
    for(int i=ObjectsTotal()-1; i>-1; i--) {
      if(StringFind(ObjectName(i),"button")>=0) ObjectDelete(ObjectName(i));
      if(StringFind(ObjectName(i),"desbal")>=0) ObjectDelete(ObjectName(i));
      }
      ObjectDelete("Milito Vega Draw");
      Comment("");
}
//calcula tp para 
double ratioCalc( int market,int type, int ratio = 1){
   double dist;double ordopen; double ordstop; int ordertype;
   if (ordersSetted) { //calculo parametros si hay orden abierta
          ordopen = orderOpenLevel;
          ordstop = stopLossLevel;
          ordertype =  orderTypeSet;
   }
   else { // calculo si no hay ordenes
         if (market)
            if (type == 1)
            ordopen = Bid;
            else
            ordopen = Ask;
         else
         ordopen = orderTriggerLevel;
         ordstop = stopLossLevel;
         ordertype =  orderTypeClicked;
   }   
   dist = ND(MathAbs(ordstop-ordopen)); //calculo pips entre start y SL 
   color colormsg = Black;
    ObjectSetText(strMyObjectName, "SL: " + ND(dist/(Point*10))+ " SL from Ask: " + ND(MathAbs(ordstop-Ask))/(Point*10) , 12, "Arial Black", colormsg);
   if (ordertype) {//sell
      takeProfit =  ordopen - (dist*ratio);
      stopLossProtection = ordopen + (dist*0.8); //stop para proteger al 80% del nivel original, lo puedo requerir para alguna operacion en particularn
   }
   else { //buy
   takeProfit =  ordopen + (dist*ratio);
   stopLossProtection = ordopen - (dist*0.8);
   }
   if (showLogs) {
   Print ( "ord open: " + ordopen + " ord stop " + ordstop );
   Print ( "Takeprofit calculated: " + takeProfit + " - Ratio: " + ratio + " -  Dist: " + dist );
   }
   
   return takeProfit;
}

//nueva funcion para calcular el lotaje con el bot (esta en prueba)
double Calculatelot() { 
   return (maxLotSizeAllowed);
}

int jenkinsHash(string symbol,int period) {         
        int magic = 0;
        string msg = symbol + "__" + period;
        for (int i=0;i<StringLen(msg);i++) {
                magic += StringGetChar(msg,i);
                magic += (magic << 10);
                magic ^= (magic >> 6);
        }
        magic += (magic << 3);
        magic ^= (magic >> 11);
        magic += (magic << 15);
        magic = MathAbs(magic);
        return(magic);
}

int magicNumberGenerator () {         
   uint  ticks = GetTickCount();
   string magicNum;
   int diff;
   magicNum = IntegerToString(ticks);
   if (StringLen(ticks) > 9){
   diff = StringLen(ticks) - 9;
   magicNum = StringSubstr(magicNum,diff,9);
   }
   else {
   magicNum = StringSubstr(magicNum,0,9);
   }
   if (showLogs)
   Print ( " ticks: " + ticks + " magic number: " + magicNum + " original ticks lenght " + StringLen(ticks));
   return(magicNum);
}

//returns a specific integer for pair that im willing to work with, default 0 in case we use one pair thats not included 
int getPairNumberForMagicNumber () {
if (Symbol() == "EURUSD")
return 1;
if (Symbol() == "USDJPY")
return 2;
if (Symbol() == "XAUUSD")
return 3;
if (Symbol() == "USDCAD")
return 4;
if (Symbol() == "GBPUSD")
return 5;
if (Symbol() == "USDCHF")
return 6;
if (Symbol() == "GBYJPY")
return 7;
if (Symbol() == "SPX500")
return 8;
if (Symbol() == "GDAXI")
return 9;
return 0;
}

//+------------------------------------------------------------------+
//start = operacion 0=sell 1=buy , halflot = selfexplanatory , auto = 1 (por boton) = 0 por tick
int setOrder(int start, double lotOrder, double orderTakeProfit, int orderNumber) {
   Print ( "setting order with " + lotOrder);
   //si no esta confirmada la operacion no abre nada
     Print ( "  slprot " + ((lotOrder == (lotSize/2)) && useStopLossProtection ));
   if (confirmationOp){ 
      //--- orden market inicial y calculo de tp para la grilla
         orderId = magicNumberGenerator();
         if ((lotOrder != (lotSize/2)) && useStopLossProtection) {
          Print ( " setting slprotection " + stopLossProtection);
          stopLossOrder = stopLossProtection;
         } else {
          stopLossOrder = stopLossLevel;
         }
         if (start == 1) {  // buy
   
            ticket = OrderSend(Symbol(),OP_BUY,lotOrder,Ask,slippage,0,0,NULL,orderId,0,Green);
            if(OrderSelect(ticket, SELECT_BY_TICKET)==true) {
               orderOpenLevel = OrderOpenPrice();
               orderTypeSet = OrderType();

               buyGoal  = orderTakeProfit;
               if ((coinflip) && ( useStopLossProtection && ((orderNumber+1) == numberOfOrders))) {
               stopLossOrder = (Ask - (Point *10 * (20 * 0.8)));
               buyGoal = Ask + (Point * 10 * (20 * 4));
               } else {
               buyGoal = orderTakeProfit;
               }
               resultTicket = OrderModify(ticket, 0, stopLossOrder, buyGoal, 0);//SL and TP set
               if(!resultTicket) {  
                  textSend="IMPORTANT: ORDER # " + ticket + " HAS NO STOPLOSS AND TAKEPROFIT" + _Symbol + "Error: " + GetLastError();
                  Print (textSend);
                  return 0;
               }
               else {
                  openOrderType =1;tfControl = True;
                  orderStopLossLevel = OrderStopLoss();
                  if (showLogs) 
                     Print ( "My magic numer is: " + OrderMagicNumber());
               }
               orderTicket = ticket;
           }
           else {
            textSend= Symbol() + " Error: could not get the order info, please check " + GetLastError();
            Print (textSend);
            return 0;
           }
         }
         else if (start == 0) {   //sell, same logic as buy
            sellGoal  = orderTakeProfit;
            ticket = OrderSend(Symbol(),OP_SELL,lotOrder,Bid,slippage,0,0,NULL,orderId,0,Red);
            if(OrderSelect(ticket, SELECT_BY_TICKET)==true) {
          Print (" trying to modify");
              orderOpenLevel = OrderOpenPrice();
              orderTypeSet = OrderType();
    
               if ((coinflip) && ( useStopLossProtection && ((orderNumber+1) == numberOfOrders))) {
               stopLossOrder = (Bid + (Point *10 * (20 * 0.8)));
               sellGoal = Bid - (Point * 10 * (20 * 4));
               } else {
               sellGoal =orderTakeProfit;
               }
              resultTicket = OrderModify(ticket, 0, stopLossOrder, sellGoal, 0);
              if(!resultTicket) { 
               textSend="IMPORTANT: ORDER # " +  ticket + " HAS NO STOPLOSS AND TAKEPROFIT" + _Symbol + " Error: " + GetLastError();
               Print (textSend);
               return 0;
              }
              else {
              openOrderType =0;tfControl = True;
              if (showLogs) 
               Print ( "My magic numer is: " + OrderMagicNumber());
              }
              orderTicket = ticket;
            }
            else {
               textSend= Symbol() + " Error: could not get the order info, please check " + GetLastError();
               Print (textSend);
               return 0;
            }
        }
        return ticket;

   } //end if confirmacion op
   return 0;
} //end setorder

//+------------------------------------------------------------------+

int setOrderLimit(int start, double lotOrder, double orderTakeProfit) {
    Print ( "setting limit order with " + lotOrder);
  
   //si no esta confirmada la operacion no abre nada
   if (confirmationOp){ 
      //--- orden market inicial y calculo de tp para la grilla
     
         orderId = magicNumberGenerator();
         if ((lotOrder != (lotSize/2)) && useStopLossProtection) {
           Print ( " setting slprotection " + stopLossProtection);
           stopLossOrder = stopLossProtection;
         } else {
           stopLossOrder = stopLossLevel;
         }
         if (start == 0) {  // sell

         //colola orden pendiente en funcion de la linea verde (orderTriggerLevel)
            if (orderTriggerLevel > Bid){
               //sell limit
               ticket = OrderSend(Symbol(),OP_SELLLIMIT,lotOrder,orderTriggerLevel,slippage,stopLossOrder,orderTakeProfit,NULL,orderId,0,Green);
            }
            else {
               //sell stop
               //ticket = OrderSend(Symbol(),OP_SELLSTOP,lotOrder,orderTriggerLevel,slippage,stopLossOrder,orderTakeProfit,NULL,orderId,0,Green);
               ObjectSetText(strMyObjectName, "Please review the set up lines (trying to sell below price)", 8, "Arial Black", Red);
               return -1;
            }
            if(!ticket) {
               Alert("OrderSend Error: ", GetLastError());
               Alert("IMPORTANT: NO SE PUDO COLOCAR ORDEN PENDIENTE");
               return 0;
            }
            return ticket;
         }
         else if (start == 1) {   
                  //colola orden pendiente en funcion de la linea verde (orderTriggerLevel)
            if (orderTriggerLevel > Ask){
               //ticket = OrderSend(Symbol(),OP_BUYSTOP,lotOrder,orderTriggerLevel,slippage,stopLossOrder,orderTakeProfit,NULL,orderId,0,Green);
               ObjectSetText(strMyObjectName, "Please review the set up lines (trying to buy above price)", 8, "Arial Black", Red);
               return -1;
            }
            else {
               ticket = OrderSend(Symbol(),OP_BUYLIMIT,lotOrder,orderTriggerLevel,slippage,stopLossOrder,orderTakeProfit,NULL,orderId,0,Green);
            }
            if(!ticket) {
               Alert("OrderSend Error: ", GetLastError());
               Alert("IMPORTANT: NO SE PUDO COLOCAR ORDEN PENDIENTE");
               return 0;
            }
            return ticket;
        }
   
   } //end if confirmacion op
   return 0;
} //end setorderLimit

//+----
//Line Management
//+----
  //+------------------------------------------------------------------+
//| Create the horizontal line                                       |
//+------------------------------------------------------------------+
bool HLineCreate(const long            chart_ID=0,        // chart's ID
                 const string          name="HLine",      // line name
                 const int             sub_window=0,      // subwindow index
                 double                price=0,           // line price
                 const color           clr=clrRed,        // line color
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                 const int             width=1,           // line width
                 const bool            back=false,        // in the background
                 const bool            selection=true,    // highlight to move
                 const bool            hidden=true,       // hidden in the object list
                 const long            z_order=0)         // priority for mouse click
  {
//--- if the price is not set, set it at the current Bid price level
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value
   ResetLastError();
//--- create a horizontal line
   if(!ObjectCreate(chart_ID,name,OBJ_HLINE,sub_window,0,price))
     {
      Print(__FUNCTION__,
            ": failed to create a horizontal line! Error code = ",GetLastError());
      return(false);
     }
//--- set line color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line display style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of moving the line by mouse
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
  
  
  //+------------------------------------------------------------------+
//| Delete a horizontal line                                         |
//+------------------------------------------------------------------+
bool HLineDelete(const long   chart_ID=0,   // chart's ID
                 const string name="HLine") // line name
  {
//--- reset the error value
   ResetLastError();
//--- delete a horizontal line

if ( ObjectFind(0,name) == 0)
   {  if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete a horizontal line! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
   }
   else
   return(true);
  }
  
  //+------------------------------------------------------------------+
//| Move horizontal line                                             |
//+------------------------------------------------------------------+
bool HLineMove(const long   chart_ID=0,   // chart's ID 
               const string name="HLine", // line name 
               double       price=0)      // line price
{ 
//--- if the line price is not set, move it to the current Bid price level 
   if(!price) 
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID); 
//--- reset the error value 
   ResetLastError(); 
//--- move a horizontal line 
   if(!ObjectMove(chart_ID,name,0,0,price)) 
     { 
      Print(__FUNCTION__, 
            ": failed to move the horizontal line! Error code = ",GetLastError()); 
      return(false); 
     } 
//--- successful execution 
   return(true); 
}

//buttons handling

  void HideButton(string btnName)
  {
  ObjectSetInteger(0,btnName,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
  }
    void ShowButton(string btnName)
  {
  ObjectSetInteger(0,btnName,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
  }
  void hideButtons () {
         ObjectSetString(0,"button14",OBJPROP_TEXT,"Show");
         HideButton("button1");HideButton("button2");HideButton("button3");HideButton("button4");HideButton("button5");
         HideButton("button6");HideButton("button7");HideButton("button8");HideButton("button9");HideButton("button10");
         HideButton("button11");HideButton("button12");HideButton("button13");
        
         ObjectSetInteger(0,"button14",OBJPROP_STATE,false);
       hideButtonsGlobal = true; 
  }