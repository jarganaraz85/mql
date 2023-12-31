//+------------------------------------------------------------------+
//|                                            Milito vega v6.2mq4   |
//|                                                   JUAN ARGAÑARAZ |
//|                                              argjuan85@gmail.com |
//+------------------------------------------------------------------+


// se agrega el break even al abrir un segundo nivel para prevenir perdidas abultadas
#property copyright "JUAN ARGAÑARAZ"
#property version     "6.3"  
#property description      "argjuan85@gmail.com"

#include "stdlib.mqh"
#include "Telegram.mqh"		// Necesario para que funcione enviar mensajes a Telegram

enum operationtype
{
   Select, //Seleccione el tipo de operacion a verificar
   Buy,    // Only open long positions
   Sell,    // Only short positions
    Manual,   
   
};

enum fiboclose
{
   Seleccionar, //Seleccione el tipo de operacion a verificar
   Si,    // Use fibo part close
   No,    // Not
    
   
};

enum operationnumber
{
   Select1, //Seleccione cantidad de operaciones por zona
   Simple,    // Una operacion
   Double,    // Dos operaciones
    
};

enum operationform
{
   Select2, //Seleccione forma de operativa...
   Sinpatronauto,    // Sin Patron (Automatico)
   Sinpatron,    // Sin Patron (Manual)
   Conpatron,    // Con Patron (Manual)
    
};

enum lottype
{
   Select3, //Seleccione % de riesgo...
   full,    // 100%
   half,    // 50%
    
};

extern string Milito_Vega;
input string BASIC_SETUP          = "====== !!!!!DEFINIR OPERACION Y LOTAJE!!!!!!!  ========"; // =================
extern operationtype       startorder     = Select;          // tipo de operacion que abrira el ea
extern lottype       riesgoop     = Select3;  //riesgo de la operacion
//extern operationnumber       opnumb     = Select1;          // tipo de operacion que abrira el ea
 int zonesize = 50; //para calculos sin patron automatico
extern operationform       formaoperativa     = Sinpatron; 
 int cantidadop = 1;
extern double LotSize = 0.04;
extern bool extremofollow = false;
extern int stopSize = 25;
extern bool usemaxminfiboseg = false;
extern fiboclose usefibopartial = No;  //ojo, si quiero usar esto debo activar tambien  usemaxminfiboseg si no se va partir
extern bool usepartialcloseloss = true;
extern bool usemanuallotcontrol = true; 
extern bool usebreakeven = true; 
extern bool usecalculatelot = true;
extern bool sendtelegrammessages = true;
extern bool sendpushnotification = true; 
extern double Riskperop = 40; //riesgo maximo por zona en usd
extern double maxlot = 0.56; //lot max a operar
extern double rmainparam = 4; //RR principal a utilizar
extern double rsecparam = 6; //RR secundario a utilizar
extern bool showlogs = false;
extern double tickdiff = 0.00005; //maxima diferencia entre el nivel seteado y el precio actual
extern double tickdiffanul = 0.00005; 
extern double tickdifflimitorder = 2; //pips de diferencia entre activacion y  bid/ask actual para actualizar ordenes pendientes
extern bool issecondtrade = false; 
extern bool isthirdtrade = false;
extern bool isfourthtrade = false;
extern bool isfifthtrade = false;
extern bool Showinfo = false;  //muestra info de la operacion

 //extern string TELEGRAM_MESSAGES;
    //string 	aaa			= "====== Configuracion Telegram ========";	// =================
    ENUM_LANGUAGES    InpLanguage=LANGUAGE_EN;//Language
   string 	InpToken		= "762665781:AAGBkpf6yaOhRap4m87ixOyqdEnnmXnRMpM";	// Token del bot // test "854948219:AAGqWAj4IYiTlLY-t0J8CMKnn6EWPSJWaSI";//
    string 	userauth		= "@argjuan85"; //usuarios permitidos por el bot para operar
//--- para mensajes a telegram
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
  
  //-- fin mensajes telegram
//--- input parameters of the script
input string          InpName="PartialCloseLine";     // Line name
input string          InpName2="StartLevelLine";     // Line name
input string          InpName3="StopLevelLine";     // Line name
input string          InpName4="TakeProfitLevelLine";     // Line name
input string          InpName5="AnulationLine";     // Line name
input string          InpName6="BreakEvenLine";     // Line name
input string          InpName7="ActivationLine";     // Line name
input string          InpNamef="fiboline";     // Line name
input int             InpPrice=25;         // Line price, %
input color           InpColor=clrRed;     // Line color
input color           InpColor2=clrGreen;     // Line color
input color           InpColor3=clrOrange;     // Line color
input color           InpColor4=clrWhite;     // Line color
input color           InpColor5=clrYellow;     // Line color
input color           InpColor6=clrAqua;     // Line color
input ENUM_LINE_STYLE InpStyle=STYLE_DASH; // Line style
input ENUM_LINE_STYLE InpStyle2=STYLE_DASHDOT; // Line style
input int             InpWidth=1;          // Line width
input bool            InpBack=false;       // Background line
input bool            InpSelection=true;   // Highlight to move
input bool            InpHidden=true;      // Hidden in the object list
input long            InpZOrder=0;         // Priority for mouse click

//--- input parameters of the script
input string          VInpName="VLine";     // Line name
input int             VInpDate=25;          // Event date, %
input color           VInpColor=clrRed;     // Line color
input ENUM_LINE_STYLE VInpStyle=STYLE_DASH; // Line style
input int             VInpWidth=1;          // Line width
input bool            VInpBack=false;       // Background line
input bool            VInpSelection=true;   // Highlight to move
input bool            VInpHidden=true;      // Hidden in the object list
input long            VInpZOrder=0;         // Priority for mouse click

 double startlevel,activationlevel,nivelinicioorden,stoptemp,tptemp,neworderlevel;  //nivel de apertura de orden, activacion de ea (simil confirmacion), mantienen el valor de la orden pendiente en los extremos ya que se ira moviendo
double orderdiff,bidaskinicioorden,tickdifflimitordercalc; // diferencia entre nivel de ejecucion de orden y el tick actual, bid o ask al momento de mandar orden limite
double Takeprofit; // Segundo TP
 double StopLoss;  // SL fijo al comienzo
   int Font_Size           = 10;         // Font Size
 string Font_Face        = "Impact"; 
double comisionbroker = 4.71;// cometa fxtm expresada en usd

 string  Setup           = "--------------------------------------------------------";         // ------- SETUP INDICATOR
 int AccountMoney    = 1;    // Money For The Calculation
 string Mode             = "Percentage"; // Mode For The Calculation
double StopLossPips;           // Stop Loss In Pips
 double RiskPercentage   = 0.005;          // Risk In Percentage
  int Lotstd   = 100000;          // Lot standard
    int Lotstdcfd   = 100;          // Lot standard
 double RiskMoney;         // Risk In Money
 static bool tfcontrol = False;

 color paircolour        = White;  // Color Of Common Fonts
     double size ;
     double MyPoint = 0.0;
        string aName = "Account";
        extern int Slippage  = 3;
 extern bool useautomaticmagicnumber = true;
extern int SetOrderID=1548583;       //Magic Number to use for the orders
extern int SecondOrderID=1548584;       //Magic Number to use for the orders
extern int ThirorderID=1548585;       //Magic Number to use for the orders 
extern int FourthorderID=1548586;  
extern int FifthorderID=1548587;  
extern bool usestrategytest = false;  //para que abra long short automaticamente en el strategy tester
extern int strategytestdir=0;       //0 = sell 1 = buy
int checkopen,cpt, minmaxshift;
int ticket,barshift,orderticketsave,ordertypesave;
datetime LastActiontime,LastActiontime1,ordertime;
double MyPip = Point * 10;
bool Enter = True; //para que no coloque mas de una grilla
bool breakevenset = false;  //control be level -1
bool orderset = false;
bool REBOOT = false;
bool orderclosed = false;
bool activationconfirm = false;
bool res,cierreparcialperdidarealizado = False,cierreparcialrealizado = False,cierreparcialrealizadofibo = False,breakevenrealizado = False,firstbar = true, confirmationop = false;
int ordenesopen,maxbar,minbar,maxbar61,minbar61,tf_val,openordertype,OrderID,shiftvl,Orderticket,firstordertype;
double spread_value = MarketInfo(NULL,MODE_SPREAD);
double Lotorder, BuyGoal, SellGoal,maxvalue,minvalue,maxvalue61,minvalue61,partialclosedinamic,partialclosedinamicperdida, breakevendinamic, lineaanulacion,sldistance;
double usdpip, gridstart, positionSize, riskMoney, StopLossorder,orderlots,value22;
double minbardinamic, maxbardinamic, minvaluedinamic, maxvaluedinamic, barshiftdinamic, PREVLOW, PREVHIGH,fibocalc, fibo61, fibo809,Takeprofitorder,lotcalc = -1;
double LOW = -99;
double HIGH = -99;
double value2,valuee2,value,value3,value4,value5,value6;
   string strMyObjectName,strMyObjectName1,textsend;
    bool sendmail = false;
    bool opanulada = false;
    int xx,xxx,bars;
// FUNCION PARA NORMALIZAR PRECIOS Y EVITAR ERRORES EN ORDEN SEND
double ND(double val)
  {
   return(NormalizeDouble(val, Digits));
  }

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  {
       string baseCurr = StringSubstr(Symbol(),0,3);
    string crossCurr = StringSubstr(Symbol(),3,3);
   sldistance = stopSize; //por si alguna vez no muevo linea de start o sl y esta variable queda sin asignar lo cual puede traer error en el calculo del lotaje
    strMyObjectName = "Milito Vega 4.2";
    strMyObjectName1 = "Milito Vega ";

   string strMyObjectText;
activationconfirm = False;
   // Create text object with given name

   ObjectCreate(strMyObjectName, OBJ_LABEL, 0, 0, 0, 0);
   ObjectCreate(strMyObjectName1, OBJ_LABEL, 0, 0, 0, 0);

   // Set pixel co-ordinates from top left corner (use OBJPROP_CORNER to set a different corner)

   ObjectSet(strMyObjectName, OBJPROP_XDISTANCE, 200);

   ObjectSet(strMyObjectName, OBJPROP_YDISTANCE, 95);
   
   ObjectSet(strMyObjectName1, OBJPROP_XDISTANCE, 500);

   ObjectSet(strMyObjectName1, OBJPROP_YDISTANCE, 95);

   // Set text, font, and colour for object
//Print ( " start: " + startorder);

   //set magicnumber 
   
   if (useautomaticmagicnumber)
   OrderID = jenkinsHash(Symbol(),Period());
   else
   OrderID = SetOrderID;
   if (showlogs)
    Print ( "hi my magic numer is: " +  OrderID + " - " + StringLen(OrderID));
 if ( OrderID >= 2147483647)
  {Print ( " Magin numer out of range, check!!!!!!!");
     OrderID = 0;
 }
 else {
       if (showlogs) Print ( " originalid " + OrderID );
       if (!useautomaticmagicnumber)  
      { if (issecondtrade)
        OrderID = SecondOrderID;
   
         if (isthirdtrade)
           OrderID = ThirorderID;
   
            if (isfourthtrade)
            OrderID = FourthorderID;
   
            if (isfifthtrade)
              OrderID = FifthorderID;
         }
         else
          {
          if (showlogs)
          Print ( "calculated id " + AutosetOrderID());
           if ( AutosetOrderID() != -1)
           OrderID = OrderID+AutosetOrderID();
          else
            {Print ( " More than 5 orders on same pair?, check!!!!!!!");
             OrderID = 0;
            }
          /* if (issecondtrade)
        OrderID = OrderID+1;
   
         if (isthirdtrade)
           OrderID = OrderID+2;
   
            if (isfourthtrade)
            OrderID = OrderID+3;
   
            if (isfifthtrade)
              OrderID = OrderID+4;*/
          }
        }
    
    if (showlogs)
   Print ( "hi my magic numer is: " +  OrderID + " - " + StringLen(OrderID));

if (tfcontrol == True)  // hay ordenes abiertas previamente por este bot no hago nada
   {  xx=200;
         strMyObjectText = "ATENCION!! CAMBIO DE TIMEFRAME, REVISAR GESTION";
  ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Red);
  CreateButton("button11","Close EA" ,xx,60,80,30,White,Gray,White,10);
   REBOOT = true;
   if (sendmail) SendMail("Milito Vega ", Symbol() +  " Alerta por cambio de timeframe ");
      }
      else   //no hay ordenes previas abiertas por este bot entonces trabajo
         {   
//Print ( " test: " + CheckCurrentOrders());
if (CheckCurrentOrders(6) == 1)  // hay ordenes abiertas previamente por este bot no hago nada
   { xx=200;
         strMyObjectText = "ATENCION!! YA EXISTE ORDEN CON ESTE MAGIC N° HUBO REINICIO?";
  ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Red);
  CreateButton("button11","Close EA" ,xx,60,80,30,White,Gray,White,10);
   REBOOT = true;
   if (sendmail) SendMail("Milito Vega ", Symbol() +  " Alerta por reinicio ");
      }
      else   //no hay ordenes previas abiertas por este bot entonces trabajo
         {
    
        
   if(startorder == "0")
  { xxx=200;
    strMyObjectText = "ATENCION!!!! DEBE SETEAR EL TIPO DE OPERACION PARA  EL ROBOT!!!";
  ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Red);
  CreateButton("button11","Close EA" ,xxx,60,80,30,White,Gray,White,10);
  }
  else
   { 
        if(LotSize == "0")
     { xxx=200;
       strMyObjectText = "ATENCION!!!! DEBE SETEAR EL LOTAJE PARA OPERAR!!!";
       ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Red);
       CreateButton("button11","Close EA" ,xxx,60,80,30,White,Gray,White,10);
     }
      else
       { 
       
       //--
         if(usefibopartial == "0")
           { xxx=200;
             strMyObjectText = "ATENCION!!!! DEBE SELECCIONAR SI SE USARA FIBO CLOSE";
             ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Red);
             CreateButton("button11","Close EA" ,xxx,60,80,30,White,Gray,White,10);
              }
            else
         { 
       
       //--
                 if(LotSize > maxlot)
       {
       strMyObjectText = "ATENCION!! EL LOTAJE SETEADO EXCEDE EL MAXIMO DEFINIDO!!";
       ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Red);
       }
        else
       { 
         //-- control de seteo de riesgo ESTE DEBE QUEDAR
         if(riesgoop == "0")
           { xxx=200;
             strMyObjectText = "ATENCION!!!! DEBE SELECCIONAR RIESGO DE LA OPERACION";
             ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Red);
             CreateButton("button11","Close EA" ,xxx,60,80,30,White,Gray,White,10);
              }
            else
         { 
           //-- control de seteo de forma de operativa ESTE DEBE QUEDAR
         if(formaoperativa == "0")
           { xxx=200;
             strMyObjectText = "ATENCION!!!! DEBE SELECCIONAR FORMA DE OPERATIVA";
             ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial Black", Red);
             CreateButton("button11","Close EA" ,xxx,60,80,30,White,Gray,White,10);
              }
            else
         { 
           
     //fin controles, ejecuto tareas de inicio
       
        strMyObjectText = "POR FAVOR CONFIRMAR SETEO";
   //     strMyObjectText = "ESPERANDO OPERACION A GESTIONAR =)";
         ObjectSetText(strMyObjectName, strMyObjectText, 8, "Arial Black", Orange);
            ObjectSetText(strMyObjectName1, "", 8, "Arial Black", Orange);
          
 //Chequeo si hay ordenes abiertas por el bot en el par para los casos que se cierre el mt4 a mitad de operativa asi quedan seteadas las variables que corresponden
      
int x=200;
 MyPoint = Point;
/*
CreateButton("button1" ,"Buy" ,x,20,80,30,Yellow,Green,White,10);
x= x +10;
CreateButton("button2","Buy half" ,x,20,80,30,Yellow,Green,White,10);
x= x +10;

x=200;
CreateButton("button5" ,"Sell "  ,x,60,80,30,Yellow,Red,White,10);
x= x +10;
CreateButton("button6","Sell half " ,x,60,80,30,Yellow,Red,White,10);
x= x +10;*/


CreateButton("button4","Close order ",x,20,80,30,White,Gray,White,10);
x= x -90;
CreateButton("button7","Show Logs" ,x,60,80,30,White,Gray,White,10);
x= x +10;
CreateButton("button8","R Main" ,x,20,80,30,White,Gray,White,10);
x= x -90;
CreateButton("button9","R Sec" ,x,60,80,30,White,Gray,White,10);
x= x +10;
CreateButton("button10","Calculate Lot" ,x,20,80,30,White,Gray,White,10);
x= x -90;
CreateButton("button11","Close EA" ,x,60,80,30,White,Gray,White,10);
x= x +10;
CreateButton("button13","Set Lot" ,x,20,80,30,White,Gray,White,10);
x= x -90;
CreateButton("button12","Show Info" ,x,60,80,30,White,Gray,White,10);
x= x +10;
CreateButton("button14","Breakeven" ,x,20,80,30,White,Gray,White,10);
x= x -90;
CreateButton("button15","Part Close" ,x,60,80,30,White,Gray,White,10);
x= x +10;
CreateButton("button16","Confirmar" ,x,20,80,30,White,Red,White,10);
x= x -90;
CreateButton("button17","Market" ,x,60,80,30,Black,Orange,White,10);
x= x +10;
CreateButton("button18","Confirmar activacion" ,x,20,160,30,White,Red,White,10);
if(spread_value >= 35)
  { 
 
  strMyObjectText = "ATENCION!!!! ESTE PAR EN ESTE MOMENTO TIENE SPREAD ALTO !!!";
  ObjectSetText(strMyObjectName, strMyObjectText, 10, "Arial", Red);
  }
  
  //coloco linea de inicio si corresponde
  
      if (startorder == 2)
     {  
     //seteo linea de activacion
     if(!HLineCreate(0,InpName7,0,Bid-150*Point,InpColor6,InpStyle,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de activacion , revisar ");
     }
      else 
        { 
         
         ObjectGetDouble(0,InpName7,OBJPROP_PRICE,0,valuee2);
         Print("Activacion de EA seteado en: " + ND(valuee2)); 
         //startlevel = NormalizeDouble(value2,5); 
           /*   if (baseCurr == "XAU")
          activationlevel = NormalizeDouble(valuee2,2); 
         else if (crossCurr == "JPY")
          activationlevel = NormalizeDouble(valuee2,3); 
         else //usd
         activationlevel = NormalizeDouble(valuee2,5); */
         activationlevel = NormalizeDouble(valuee2,Digits);
          }
          
     // seteo linea de inicio
     if(!HLineCreate(0,InpName2,0,Bid-100*Point,InpColor2,InpStyle2,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de inicio , revisar ");
     }
      else 
        { 
         
         ObjectGetDouble(0,InpName2,OBJPROP_PRICE,0,value2);
         Print("Ejecucion de operacion seteado en: " + ND(value2)); 
         //startlevel = NormalizeDouble(value2,5); 
        /*      if (baseCurr == "XAU")
          startlevel = NormalizeDouble(value2,2); 
         else if (crossCurr == "JPY")
          startlevel = NormalizeDouble(value2,3); 
         else //usd
         startlevel = NormalizeDouble(value2,5); */
         startlevel = NormalizeDouble(value2,Digits);
          }
          
        //---- end seteo linea de inicio  
          
          //---  SETEO LINEA MAX MIN
          //--- check correctness of the input parameters
          if (usemaxminfiboseg){
   if(VInpDate<0 || VInpDate>100)
     {
      Print("Error! Incorrect values of input parameters!");
      //return;
     }
//--- number of visible bars in the chart window
    bars=(int)ChartGetInteger(0,CHART_VISIBLE_BARS);
//--- array for storing the date values to be used
//--- for setting and changing line anchor point's coordinates
   datetime date[];
//--- memory allocation
   ArrayResize(date,bars);
//--- fill the array of dates
   ResetLastError();
   if(CopyTime(Symbol(),Period(),0,bars,date)==-1)
     {
      Print("Failed to copy time values! Error code = ",GetLastError());
      //return;
     }
//--- define points for drawing the line
   int d=(VInpDate*(bars-1)/100)+25;
  // Print ( " date -time -  d: " + date[d] + " - " + Time[d] + " - " + d );
        if(!VLineCreate(0,VInpName,0,date[d],VInpColor,VInpStyle,VInpWidth,VInpBack,
      VInpSelection,VInpHidden,VInpZOrder))
     {
       Print("No se pudo colocar la linea de MIN/MAX , revisar ");
     }
      else 
        { 
         ObjectGetDouble(0,VInpName,OBJPROP_PRICE,0,value22);
         Print("Linea de min/max seteada en: " + value22); 
                 shiftvl=iBarShift(NULL,0,value22);
        Print("index of the bar for the time ",TimeToStr(value22)," is ",shiftvl);
         //startlevel = NormalizeDouble(value2,5); 
          }
          }
          ///--- FIN LINEA MAX MIN
                    
          
     if(!HLineCreate(0,InpName3,0,Bid+100*Point,InpColor,InpStyle2,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de stop , revisar ");
     }
       else 
        { 
              
         ObjectGetDouble(0,InpName3,OBJPROP_PRICE,0,value3);
         Print("Stop Loss seteado en: " + ND(value3)); 
        // StopLoss = NormalizeDouble(value3,5);
        /* if (baseCurr == "XAU")
          StopLoss = NormalizeDouble(value3,2); 
         else if (crossCurr == "JPY")
          StopLoss = NormalizeDouble(value3,3); 
         else //usd
         StopLoss = NormalizeDouble(value3,5); */
         
         StopLoss = NormalizeDouble(value3,Digits); 
          } 
     if(!HLineCreate(0,InpName4,0,Bid-500*Point,InpColor,InpStyle2,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de takeprofit , revisar ");
     }
      else 
        { 
           
         ObjectGetDouble(0,InpName4,OBJPROP_PRICE,0,value4);
         Print("Take Profit seteado en: " + ND(value4)); 
        // Takeprofit = NormalizeDouble(value4,5);
          /*              if (baseCurr == "XAU")
          Takeprofit = NormalizeDouble(value4,2); 
         else if (crossCurr == "JPY")
          Takeprofit = NormalizeDouble(value4,3); 
         else //usd
         Takeprofit = NormalizeDouble(value4,5); */
         
           Takeprofit = NormalizeDouble(value4,Digits); 
          }
     if(!HLineCreate(0,InpName,0,Bid-300*Point,InpColor2,InpStyle,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de cierre parcial , revisar ");
     }
        else 
        { 
      
         ObjectGetDouble(0,InpName,OBJPROP_PRICE,0,value);
         Print("Cierre parcial en ganancia seteado en: " +  ND(value)); 
        // partialclosedinamic = NormalizeDouble(value,5);  
        /*          if (baseCurr == "XAU")
          partialclosedinamic = NormalizeDouble(value,2); 
         else if (crossCurr == "JPY")
          partialclosedinamic = NormalizeDouble(value,3); 
         else //usd
         partialclosedinamic = NormalizeDouble(value,5); */
         
               partialclosedinamic = NormalizeDouble(value,Digits); 
        }
        //linea de break even
           if(!HLineCreate(0,InpName6,0,Bid-200*Point,InpColor3,InpStyle,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de break even, revisar ");
     }
        else 
        { 
      
         ObjectGetDouble(0,InpName6,OBJPROP_PRICE,0,value6);
         Print("Break Even seteado en: " +  ND(value6)); 
         //breakevendinamic = NormalizeDouble(value6,5); 
         /*           if (baseCurr == "XAU")
          breakevendinamic = NormalizeDouble(value6,2); 
         else if (crossCurr == "JPY")
          breakevendinamic = NormalizeDouble(value6,3); 
         else //usd
         breakevendinamic = NormalizeDouble(value6,5);   */
             breakevendinamic = NormalizeDouble(value6,Digits);  
        }
        
          //coloco linea de anulacion
     if(!HLineCreate(0,InpName5,0,Bid+120*Point,InpColor,InpStyle,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de anulacion , revisar ");
     }
      else 
        {                 
         ObjectGetDouble(0,InpName5,OBJPROP_PRICE,0,value5);
         Print("Linea de anulacion seteada en: " + ND(value5)); 
       //  lineaanulacion = NormalizeDouble(value5,5); 
        /*   if (baseCurr == "XAU")
          lineaanulacion = NormalizeDouble(value5,2); 
         else if (crossCurr == "JPY")
          lineaanulacion = NormalizeDouble(value5,3); 
         else //usd
         lineaanulacion = NormalizeDouble(value5,5);  */
         lineaanulacion = NormalizeDouble(value5,Digits);  
     }
     }
     else 
        {  
        
        //seteo linea de activacion
        
             //seteo linea de activacion
     if(!HLineCreate(0,InpName7,0,Bid+150*Point,InpColor6,InpStyle,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de activacion , revisar ");
     }
      else 
        { 
         
         ObjectGetDouble(0,InpName7,OBJPROP_PRICE,0,valuee2);
         Print("Activacion de EA seteado en: " + ND(valuee2)); 
         //startlevel = NormalizeDouble(value2,5); 
         /*     if (baseCurr == "XAU")
          activationlevel = NormalizeDouble(valuee2,2); 
         else if (crossCurr == "JPY")
          activationlevel = NormalizeDouble(valuee2,3); 
         else //usd
         activationlevel = NormalizeDouble(valuee2,5);*/ 
         
         activationlevel = NormalizeDouble(valuee2,Digits); 
          }
        //seteo linea de inicio
     if(!HLineCreate(0,InpName2,0,Ask+100*Point,InpColor2,InpStyle2,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de inicio , revisar ");
     }
     else
     {
         ObjectGetDouble(0,InpName2,OBJPROP_PRICE,0,value2);
         Print("Ejecucion de operacion seteado en: " + ND(value2)); 
         //startlevel = NormalizeDouble(value2,5); 
         /*     if (baseCurr == "XAU")
          startlevel = NormalizeDouble(value2,2); 
         else if (crossCurr == "JPY")
          startlevel = NormalizeDouble(value2,3); 
         else //usd
         startlevel = NormalizeDouble(value2,5); */
         
            startlevel = NormalizeDouble(value2,Digits); 
     }
     //-- end linea de inicio
     
     
               //---  SETEO LINEA MAX MIN
          
          //--- check correctness of the input parameters
          if (usemaxminfiboseg) {
   if(VInpDate<0 || VInpDate>100)
     {
      Print("Error! Incorrect values of input parameters!");
      //return;
     }
//--- number of visible bars in the chart window
   int vlbars=(int)ChartGetInteger(0,CHART_VISIBLE_BARS);
//--- array for storing the date values to be used
//--- for setting and changing line anchor point's coordinates
   datetime vldate[];
//--- memory allocation
   ArrayResize(vldate,bars);
//--- fill the array of dates
   ResetLastError();
   if(CopyTime(Symbol(),Period(),0,vlbars,vldate)==-1)
     {
      Print("Failed to copy time values! Error code = ",GetLastError());
      //return;
     }
//--- define points for drawing the line

   int vld=(VInpDate*(bars-1)/100)+25;
  // Print ( " date -time -  d: " + date[d] + " - " + Time[d] + " - " + d );
        if(!VLineCreate(0,VInpName,0,vldate[vld],VInpColor,VInpStyle,VInpWidth,VInpBack,
      VInpSelection,VInpHidden,VInpZOrder))
     {
       Print("No se pudo colocar la linea de MIN/MAX , revisar ");
     }
      else 
        { 
     
         
         ObjectGetDouble(0,VInpName,OBJPROP_PRICE,0,value22);
         Print("Linea de min/max seteada en: " + value22); 
                 shiftvl=iBarShift(NULL,0,value22);
                 if (showlogs)
                 Print("Indice de la barra de la fecha ",TimeToStr(value22)," es ",shiftvl);
         //startlevel = NormalizeDouble(value2,5); 
          }
          
          }
          ///--- FIN LINEA MAX MIN
     
     if(!HLineCreate(0,InpName3,0,Ask-100*Point,InpColor,InpStyle2,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de stop , revisar ");
     }
        else
     {
         ObjectGetDouble(0,InpName3,OBJPROP_PRICE,0,value3);
         Print("Stop Loss seteado en: " + ND(value3)); 
         //StopLoss = NormalizeDouble(value3,5); 
         /*if (baseCurr == "XAU")
          StopLoss = NormalizeDouble(value3,2); 
         else if (crossCurr == "JPY")
          StopLoss = NormalizeDouble(value3,3); 
         else //usd
         StopLoss = NormalizeDouble(value3,5);*/ 
         
         StopLoss = NormalizeDouble(value3,Digits); 
      }
     if(!HLineCreate(0,InpName4,0,Ask+500*Point,InpColor,InpStyle2,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de takeprofit , revisar ");
     }
            else
      {
         ObjectGetDouble(0,InpName4,OBJPROP_PRICE,0,value4);
         Print("Take Profit seteado en: " + ND(value4)); 
        // Takeprofit = NormalizeDouble(value4,5);
        /*                if (baseCurr == "XAU")
          Takeprofit = NormalizeDouble(value4,2); 
         else if (crossCurr == "JPY")
          Takeprofit = NormalizeDouble(value4,3); 
         else //usd
         Takeprofit = NormalizeDouble(value4,5);*/ 
         
         Takeprofit = NormalizeDouble(value4,Digits); 
      }    
     if(!HLineCreate(0,InpName,0,Bid+300*Point,InpColor2,InpStyle,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de cierre parcial , revisar ");
     }
             else
      {
     
         ObjectGetDouble(0,InpName,OBJPROP_PRICE,0,value);
         Print("Cierre parcial en ganancia seteado en: " +  ND(value)); 
        // partialclosedinamic = NormalizeDouble(value,5);  
          /*                if (baseCurr == "XAU")
          partialclosedinamic = NormalizeDouble(value,2); 
         else if (crossCurr == "JPY")
          partialclosedinamic = NormalizeDouble(value,3); 
         else //usd
         partialclosedinamic = NormalizeDouble(value,5); */
         
         partialclosedinamic = NormalizeDouble(value,Digits); 
     }
     
             //linea de break even
           if(!HLineCreate(0,InpName6,0,Bid+200*Point,InpColor3,InpStyle,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de break even, revisar ");
     }
        else 
        { 
    
         ObjectGetDouble(0,InpName6,OBJPROP_PRICE,0,value6);
         Print("Break Even seteado en: " +  ND(value6)); 
        // breakevendinamic = NormalizeDouble(value6,5);  
         /*           if (baseCurr == "XAU")
          breakevendinamic = NormalizeDouble(value6,2); 
         else if (crossCurr == "JPY")
          breakevendinamic = NormalizeDouble(value6,3); 
         else //usd
         breakevendinamic = NormalizeDouble(value6,5);  */
         
         breakevendinamic = NormalizeDouble(value6,Digits);  
        }
          //coloco linea de anulacion
     if(!HLineCreate(0,InpName5,0,Ask-120*Point,InpColor,InpStyle,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder))
     {
       Print("No se pudo colocar la linea de anulacion , revisar ");
     }
                else
      {
         ObjectGetDouble(0,InpName5,OBJPROP_PRICE,0,value5);
         Print("Linea de anulacion seteada en: " + ND(value5)); 
        // lineaanulacion = NormalizeDouble(value5,5); 
          /*                         if (baseCurr == "XAU")
          lineaanulacion = NormalizeDouble(value5,2); 
         else if (crossCurr == "JPY")
          lineaanulacion = NormalizeDouble(value5,3); 
         else //usd
         lineaanulacion = NormalizeDouble(value5,5); */ 
         
         lineaanulacion = NormalizeDouble(value5,Digits);  
      }
     }
      
   //solo para testear botones en strateg tester
   if (usestrategytest) {
    if (strategytestdir == 1)
    Action_Button1();//test buy
    else
    Action_Button5();//test sell
    }
   }}}}}}}
    }
    
    //--- set token for telegram bot
   bot.Token(InpToken);
 
   return(INIT_SUCCEEDED);
  }



//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   //EndSession();
   DeleteButtons();  
      HLineDelete(0,InpName);HLineDelete(0,InpName2);  HLineDelete(0,InpName3);HLineDelete(0,InpName4);HLineDelete(0,InpName5);HLineDelete(0,InpName6);HLineDelete(0,InpName7);
      //lineas fibo, si no fueron usasas no fueron creadas
      if (usemaxminfiboseg)
      {HLineDelete(0,InpNamef+(string)0);HLineDelete(0,InpNamef+(string)1);HLineDelete(0,InpNamef+(string)2);HLineDelete(0,InpNamef+(string)3);VLineDelete(0,VInpName);}
      
      
   Comment("");
   ObjectDelete(strMyObjectName);ObjectDelete(strMyObjectName1);
  }



//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int start()
  {
      
   return(0);
  }

//+-----------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
  string baseCurr = StringSubstr(Symbol(),0,3);
          string crossCurr = StringSubstr(Symbol(),3,3);
 // Print ( " orderset -  startord " + orderset + " - " + startorder );
     //--- control por reinicio inesperado
        if  (!REBOOT) 
           {
             
             if  (confirmationop)  // esta variable se confirma con un envio de orden con boton market o bien con el evento confirmationevent (al pasar por linea de activacion celeste) o click en boton "confirmar"
             {
             //chequeo de operacion anulada
                if  (opanulada)
           {orderset = false; orderclosed = true; confirmationop = false;
               
                 
                   textsend = "Seteo anulado " + _Symbol;
                   Sendnotifications (textsend);
                 //borro lineas de parcial y brak even 
                  if(ObjectFind(0,InpName2) == 0)
                   HLineDelete(0,InpName2);
                   if(ObjectFind(0,InpName6) == 0)
                   HLineDelete(0,InpName6);        
                  
           }
           
           //---- control distancia op limite con el precio si es extremo, si el precio se separa x pips del lugar donde triggereo la orden entonces actualizo
         
                       
         tickdifflimitordercalc =  tickdifflimitorder * (_Point * 10);
           if (startorder == 1) //buy
           orderdiff = activationlevel-Ask;
           else
           orderdiff = Bid-activationlevel;
           //ojooooooooooooooo contemplar spread!!! de momento no lo estoy usando
         //  Print ( " orderdiff - tickdifflimitorder - activationleve - Ask - bid - orderset: " + orderdiff + " - " + tickdifflimitordercalc + " -"  + activationlevel + " - " +  Ask + " - " + Bid + " - " + orderset);
           if((extremofollow) && (!orderset) &&  (orderdiff >= tickdifflimitordercalc ) )//si parametro activo y el precio se movio x pips actualizo
           {
           movelimitorder();
           }
           
           
         //--- control ejecucion ordenes pendientes
           if ((!orderset) && (CheckCurrentOrders(2)))
                      {orderset = true; //Print ( " cambio orderset a true ");
      //Creo fibo
      if (usemaxminfiboseg) { //solo uso fibo si lo defino por parametro ya que hay casos que no me interesa
      HLineCreate(0,InpNamef+(string)0,0,InpPrice,InpColor4,InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder);  //hi
      HLineCreate(0,InpNamef+(string)1,0,InpPrice,InpColor4,InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder);  //low
      HLineCreate(0,InpNamef+(string)2,0,InpPrice,InpColor5,InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder);  //61
      HLineCreate(0,InpNamef+(string)3,0,InpPrice,InpColor5,InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder);  //80.9
      HLineMove(0,InpNamef+(string)0,InpPrice);
      HLineMove(0,InpNamef+(string)1,InpPrice);
      HLineMove(0,InpNamef+(string)2,InpPrice);     
      HLineMove(0,InpNamef+(string)3,InpPrice); 
      }
         //borro inciales
          HLineDelete(0,InpName2);
           HLineDelete(0,InpName3);
           HLineDelete(0,InpName4);
             HLineDelete(0,InpName5);
              HLineDelete(0,InpName6);
            if (usemaxminfiboseg)
             VLineDelete(0,VInpName);
      ObjectDelete(strMyObjectName1);
                  ObjectSetText(strMyObjectName, "Gestionando orden pendiente seteada", 12, "Arial Black", Orange);
           }
      

        if  (orderset) 
           {
            if(LastActiontime1!=Time[0]){
             LastActiontime1=Time[0];
             
            //chequeo  de finalizacion de orden
           if  (!CheckCurrentOrders(2))  //degox debo controlar que sea op simple
           {orderset = false; orderclosed = true; confirmationop = false; activationconfirm = false;
               
                   textsend= "Finalizó la gestión de la orden en: " + _Symbol;
                   Sendnotifications (textsend);
                   //borro lineas
                   if(ObjectFind(0,InpName2) == 0)
                   HLineDelete(0,InpName2);
                   if(ObjectFind(0,InpName6) == 0)
                   HLineDelete(0,InpName6);
                  
                   
           }
       
           // fin chequeo finalizacion
           
          //29/01/2022 agrego usemaxminfiboseg a la condicion para que no haga estos calculos 
           if ((orderset) && (usemaxminfiboseg))
           {
           
           barshiftdinamic=iBarShift(NULL,0,ordertime);

         if (openordertype == 1)   //buy
         {
          //busco barra con el max para calcular fibo
          maxbardinamic = iHighest(NULL,0,MODE_HIGH,barshiftdinamic+1,0);
          maxvaluedinamic = iHigh(NULL,0,maxbardinamic);
          //seteo el maximo segun si es retrace o no
        
           if (maxvalue61 < maxvaluedinamic)
            HIGH = maxvaluedinamic;
            else
            HIGH = maxvalue61;
       
          
        
            if (PREVHIGH != HIGH)
             if (showlogs)
          Print ( " Nuevo maximo seteado en: " + HIGH);
          PREVHIGH = HIGH;
          if (showlogs)
          Print ( " Max bar dinamic  - Value: " + maxbardinamic + " - " + maxvaluedinamic + " - " + barshiftdinamic);
          }
          else
          {
                    //busco barra con el min
          minbardinamic = iLowest(NULL,0,MODE_LOW,barshiftdinamic+1,0);
          minvaluedinamic = iLow(NULL,0,minbardinamic);
             //seteo el maximo segun si es retrace o no
        
           if (minvalue61 < minvaluedinamic)
            LOW = minvalue61;
            else
            LOW = minvaluedinamic;
    
          
                       // if (firstbar)  
                      //  LOW = iClose(NULL,0,0); 
                     //   firstbar = False;
          if (PREVLOW != LOW)
           if (showlogs)
          Print ( " Nuevo minimo seteado en: " + LOW);
          
          PREVLOW = LOW;
          if (showlogs)
          Print ( " Min bar dinamic  - Value -  barshift: " + minbardinamic + " - " + minvaluedinamic + " - " + barshiftdinamic);
          }
                 // fibo de seguimiento 
         
               fibocalc  =  HIGH-LOW;
              if(fibocalc < 0) fibocalc=fibocalc*(-1);
              fibocalc  =  NormalizeDouble(fibocalc,Digits);
             
             
                HLineMove(0,InpNamef+(string)0,LOW);
                HLineMove(0,InpNamef+(string)1,HIGH);
   //
                   if(openordertype == 1) //UP
                  {
  
                         HLineMove(0,InpNamef+(string)2,HIGH-fibocalc*0.618);
                         HLineMove(0,InpNamef+(string)3,HIGH-fibocalc*0.809);
     
                           fibo61 = HIGH-fibocalc*0.618;
                           fibo809 =HIGH-fibocalc*0.809; 
                   }
                   else if(openordertype == 0) //DOWN
                    {

                         HLineMove(0,InpNamef+(string)2,LOW+fibocalc*0.618);
                         HLineMove(0,InpNamef+(string)3,LOW+fibocalc*0.809);
                         
                                  fibo61 = LOW+fibocalc*0.618;
                                   fibo809 =LOW+fibocalc*0.809; 
                   
                   //-- fin fibo seguimiento
                    }
                    //Print ( " fibo de seguimiento actualizado");
          
             }
           }
  //  Print ( " fibo open close 61 " + LOW + " - " + HIGH + " - " + LOW+fibocalc*0.618);
           
            //chequeo break even
            if (showlogs)
            Print ( " usebreakeven? - Break even realizado? " + usebreakeven + " - " + breakevenrealizado);
            if ((usebreakeven) && (!breakevenrealizado))
            breakevendinamic();
           
           //chequeo cierre parcial en ganancia
           if (!cierreparcialrealizado)
             {checkpartialclose();
               if (cierreparcialrealizado) dobreakeven(2);
             }
             
           //chequeo cierre parcial en perdida
          // Print( " use partial? -  cierre realizado " +  usepartialcloseloss + " - " + cierreparcialperdidarealizado);
           if ((usepartialcloseloss) && (!cierreparcialperdidarealizado))
             checkpartialcloseper();
             
            //gestion por fibo
            if ((usefibopartial == "1") &&(!cierreparcialrealizadofibo))
             checkpartialclosefibo();
             
                   
         
           }
           else   {
           
            //--- Colocacion de order limit con metodologia sin patron en base a fibo calculado
           
            //--- fin order limit sin patron 
           
            //--- control anulacion 
                     if (( (startorder == 2) && (MathAbs(Bid-NormalizeDouble(lineaanulacion,MarketInfo(Symbol(),MODE_DIGITS))) <= tickdiffanul ) ) || ((startorder == 1) && (MathAbs(Ask-NormalizeDouble(lineaanulacion,MarketInfo(Symbol(),MODE_DIGITS))) <= tickdiffanul ) ) )
           {
                if (showlogs)
              Print (" Borrando lineas....");
              
              EndSession();  // revisar si da error con la parte que borra las lineas
           opanulada = true;
           textsend = "Seteo anulado " + _Symbol;
           Sendnotifications(textsend);
           HLineDelete(0,InpName);
           HLineDelete(0,InpName2);
           HLineDelete(0,InpName3);
           HLineDelete(0,InpName4);
           HLineDelete(0,InpName5);
           HLineDelete(0,InpName6);
           if (usemaxminfiboseg)
           VLineDelete(0,VInpName);
           
           
           //quito orden pendiente si la hay
           
                 textsend= "Seteo anulado " + _Symbol;
                 Sendnotifications(textsend);
            }
 
       }
 } //end control confirm
 //Print ( " op anul - activationconfirm " + opanulada + " - " + activationconfirm);
 // Print ( " start order - niveldiff - tickdiff anul " + startorder + " - " + MathAbs(Bid-NormalizeDouble(activationlevel,MarketInfo(Symbol(),MODE_DIGITS)))+ " - " + tickdiffanul);
 if ((!opanulada)&&(activationconfirm)) {
             //--- control activacion  ( linea celeste) 
                     if (( (startorder == 2) && (MathAbs(Bid-NormalizeDouble(activationlevel,MarketInfo(Symbol(),MODE_DIGITS))) <= tickdiffanul ) ) || ((startorder == 1) && (MathAbs(Ask-NormalizeDouble(activationlevel,MarketInfo(Symbol(),MODE_DIGITS))) <= tickdiffanul ) ) )
            {
                if (showlogs)
              Print (" Confirmacion de ejecucion");
              confirmationevent();
          
              Print (" Operativa activada correctamente.");
              activationconfirm = false;
            
            }
   }
 } //end control reboot
}//end ontick


//+------------------------------------------------------------------+
//start = operacion 0=sell 1=buy , halflot = selfexplanatory , auto = 1 (por boton) = 0 por tick
void setorder(int start, int halflot, int auto)
{
if ((confirmationop) && (!orderset)) //si no esta confirmada la operacion o si ya hay una orden abierta no abre nada
{

//--- orden market inicial y calculo de tp para la grilla
if (halflot == 0)   // si inicio ciclo con buy coloco la orden a la altura del precio y apartir de ahi calculo las otras, y las opuestas tienen doble distancia inicial
{
Lotorder = LotSize/2;
}
else
Lotorder = LotSize;
if ( Lotorder > 0.01)
{
if (start == 1)   // buy
{
StopLossorder = StopLoss;
ticket = OrderSend(Symbol(),OP_BUY,Lotorder,Ask,Slippage,0,0,NULL,OrderID,0,Green);
if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
    {
  
     ordertime = OrderOpenTime();
     StopLossorder = StopLoss;
     BuyGoal  = Takeprofit;
     
        // Print ( " sl , tp " + StopLossorder + " - " + BuyGoal);
       res = OrderModify(ticket, 0, StopLossorder, BuyGoal, 0);// coloco  tp
     if(!res) {  
                textsend="IMPORTANT: ORDER # " + ticket + " HAS NO STOPLOSS AND TAKEPROFIT" + _Symbol + "Error: " + GetLastError();
                Sendnotifications(textsend);
                 }
                else {;orderset = true;openordertype =1;tfcontrol = True;partialclosedinamicperdida = NormalizeDouble(OrderOpenPrice() - ((OrderOpenPrice() - StopLossorder) / 2),Digits) ;
                 if (showlogs) 
                Print ( " mi magic numer es: " + OrderMagicNumber());
                textsend="Apertura buy exitosa en: " + _Symbol;
                Sendnotifications(textsend);
                }
                Orderticket = ticket;
    }
  else
    {textsend="Error al buscar informacion de la orden , Error: " + GetLastError();
    Sendnotifications(textsend);
    }
}
else if (start == 0)    //  venta
{

 StopLossorder = StopLoss;
 SellGoal  = Takeprofit;
ticket = OrderSend(Symbol(),OP_SELL,Lotorder,Bid,Slippage,0,0,NULL,OrderID,0,Red);

if(OrderSelect(ticket, SELECT_BY_TICKET)==true)
    {
       
               ordertime = OrderOpenTime();
               
     res = OrderModify(ticket, 0, StopLossorder, SellGoal, 0);// coloco  tp
     if(!res) { 
                textsend="IMPORTANT: ORDER # " +  ticket + " HAS NO STOPLOSS AND TAKEPROFIT" + _Symbol + " Error: " + GetLastError();
                Sendnotifications(textsend);
                 }
                else {orderset = true;openordertype =0;tfcontrol = True; partialclosedinamicperdida = NormalizeDouble(OrderOpenPrice() + ((StopLossorder - OrderOpenPrice() ) / 2),Digits);
                if (showlogs) 
                Print ( " mi magic numer es: " + OrderMagicNumber());
               // Print ( " open - sl " + OrderOpenPrice() + " - " + OrderStopLoss());
               textsend ="Apertura sell exitosa en: " + _Symbol;
               Sendnotifications(textsend);
                }
                Orderticket = ticket;
    }
    
  else
    {textsend="Error al buscar informacion de la orden " + GetLastError();
    Sendnotifications(textsend);
    }
}
}
  else
    Print("El lotaje indicado no permitira realizar cierres parciales, revisar ");



//--- creo lineas fibo 
//InpPrice = Bid;
//Print ( "Creando fibo de seguimiento...");
     if (usemaxminfiboseg) {
      HLineCreate(0,InpNamef+(string)0,0,InpPrice,InpColor4,InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder);  //hi
      HLineCreate(0,InpNamef+(string)1,0,InpPrice,InpColor4,InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder);  //low
      HLineCreate(0,InpNamef+(string)2,0,InpPrice,InpColor5,InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder);  //61
      HLineCreate(0,InpNamef+(string)3,0,InpPrice,InpColor5,InpStyle,InpWidth,InpBack,InpSelection,InpHidden,InpZOrder);  //80.9
      HLineMove(0,InpNamef+(string)0,InpPrice);
      HLineMove(0,InpNamef+(string)1,InpPrice);
      HLineMove(0,InpNamef+(string)2,InpPrice);     
      HLineMove(0,InpNamef+(string)3,InpPrice); }
      ObjectDelete(strMyObjectName1);
//Print ( "Creando fibo de seguimiento creado...");

} //end if confirmacion op
} //end setorder


 // GESTION DE BOTONES


void CreateButton(string btnName,string btnText,int &x,int y,int w,int h,color clrText,color clrBg,color clrBorder,int fontSize)
  {
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
  
void DeleteButtons()
  {
   for(int i=ObjectsTotal()-1; i>-1; i--)
     {
      if(StringFind(ObjectName(i),"button")>=0) ObjectDelete(ObjectName(i));
     }
  }
  
  
  void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
        string baseCurr = StringSubstr(Symbol(),0,3);
          string crossCurr = StringSubstr(Symbol(),3,3);
     if(sparam=="button4") // Close order
        {
         int testb =   MessageBox("Realmente desea cerrar la orden?","Confirmacion", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
         if (testb == 6)
         {Action_Button4();
         ObjectSetInteger(0,"button4",OBJPROP_STATE,false);
         }
        }
     if(sparam=="button7") // Show / Hide Logs
        {
        if (ObjectGetString(0,"button7",OBJPROP_TEXT) == "Show Logs")
        {showlogs = True;
        ObjectSetString(0,"button7",OBJPROP_TEXT,"Hide Logs");
        }
        else if(ObjectGetString(0,"button7",OBJPROP_TEXT) == "Hide Logs")
         {showlogs = False;
         ObjectSetString(0,"button7",OBJPROP_TEXT,"Show Logs");
         }
         
         ObjectSetInteger(0,"button7",OBJPROP_STATE,false);
        }
        
                if(sparam=="button8") // Buy/Sell RRMAIN
        {
         SetRRMain();
         ObjectSetInteger(0,"button8",OBJPROP_STATE,false);
        }
       
       
               if(sparam=="button9") // Buy/Sell RRSEC
        {
         SetRRSec();
         ObjectSetInteger(0,"button9",OBJPROP_STATE,false);
        }
        
                  if(sparam=="button10") // Calculo lotaje
        {    
        lotcalc = NormalizeDouble(Calculatelot2(),3);//aca no va digits ya que quiero redondear el lotaje calculado y no va influir en otros calculos como es el caso del precio
        //linea vieja la conservo por si necesito algo
        //lotcalc = NormalizeDouble(Calculatelot(),3);
            ObjectSetText(strMyObjectName, "El lotaje calculado es: " + lotcalc , 8, "Arial Black", LimeGreen);
         ObjectSetInteger(0,"button10",OBJPROP_STATE,false);
        }
        
                      if(sparam=="button11") // Cierre EA
        {
         int testb1 =   MessageBox("Realmente desea cerrar el EA?","Confirmación", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
         if (testb1 == 6)
         {
          ExpertRemove();
         ObjectSetInteger(0,"button11",OBJPROP_STATE,false);
         }
        }
          if(sparam=="button12") // info variables
        {
          Showinfovar();
         ObjectSetInteger(0,"button12",OBJPROP_STATE,false);
        }
             if(sparam=="button13") // Set Lot
        {    LotSize = lotcalc;
            if (lotcalc != -1)
            ObjectSetText(strMyObjectName, "Lotaje seteado en: " + LotSize, 8, "Arial Black", LimeGreen);
            else
             ObjectSetText(strMyObjectName, "Calcular primero el lotaje", 8, "Arial Black", Orange);
         ObjectSetInteger(0,"button13",OBJPROP_STATE,false);
        }
        
         if(sparam=="button16")  // Boton confirmar
        {   
                confirmationevent();
         ObjectSetInteger(0,"button16",OBJPROP_STATE,false);
        }
        
             if(sparam=="button18")  // Boton Confirmacion activacion
        {   
               // confirmationevent();
               activationconfirm = True;
                ObjectSetInteger(0,"button18",OBJPROP_BGCOLOR,Green);
         ObjectSetInteger(0,"button18",OBJPROP_STATE,false);
        }
        
        
                     if(sparam=="button15") // info variables
        {
         int testc =   MessageBox("Realmente desea realizar un cierre parcial?","Confirmación", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
         if (testc == 6)
         {
          dopartialclose();
         ObjectSetInteger(0,"button15",OBJPROP_STATE,false);
        }
         }
                  if(sparam=="button14") // info variables
        {
          int testd =   MessageBox("Realmente desea realizar un breakeven?","Confirmación", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
         if (testd == 6)
         {
          dobreakeven(1);
         ObjectSetInteger(0,"button14",OBJPROP_STATE,false);
        }
        }
                       if(sparam=="button17") // envio orden market
        {
     int testf =   MessageBox("Realmente desea enviar orden de mercado?","Confirmación", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
         if (testf == 6)
         {
           lotcalc = NormalizeDouble(Calculatelot2(),3);
            if ((LotSize > lotcalc) && (usecalculatelot))
                  ObjectSetText(strMyObjectName, "El lotaje seteado excede el riesgo definido!!", 8, "Arial Black", Red);
            else if (( HIGH == -99 ) && ( LOW == -99)&& (usemaxminfiboseg))
                  ObjectSetText(strMyObjectName, "No se ha definido maximo/minimo para la operación ", 8, "Arial Black", Red);
            else
              {
                confirmationop = True;
        //set order
        if  (startorder == 1)
         {setorder(1,1,0);
              if (showlogs)
            Print (" Borrando lineas iniciales....");
            if (orderset)
             {
           HLineDelete(0,InpName2);
           HLineDelete(0,InpName3);
           HLineDelete(0,InpName4);
             HLineDelete(0,InpName5);
               HLineDelete(0,InpName7);
               if (usemaxminfiboseg)
             VLineDelete(0,VInpName);
            
              }
             }
         else   if  (startorder == 2)
        {  setorder(0,1,0); 
               if (showlogs)
            Print (" Borrando lineas iniciales....");
            if (orderset)
             {
           HLineDelete(0,InpName2);
           HLineDelete(0,InpName3);
           HLineDelete(0,InpName4);
             HLineDelete(0,InpName5);
               HLineDelete(0,InpName7);
               if (usemaxminfiboseg)
             VLineDelete(0,VInpName);
           
             }
             }
         }    
           if (orderset)
             { ObjectSetText(strMyObjectName, "Seteo confirmado con lotaje: " + LotSize, 8, "Arial Black", LimeGreen); ObjectSetInteger(0,"button16",OBJPROP_BGCOLOR,Green);   }
         else   
        { ObjectSetText(strMyObjectName, " Hubo un error al enviar la orden, revisar ", 8, "Arial Black", Red);}
        
         ObjectSetInteger(0,"button17",OBJPROP_STATE,false);
         }
        }
        
   //seteo el cierre parcial en base a la posicion de la linea
  
          if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "PartialCloseLine")  //valido que sea la linea de parcial
         { 
         
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,value);
         Print("Cierre parcial en ganancia seteado en: " +  ND(value)); 
         partialclosedinamic = NormalizeDouble(value,Digits); 
         /*  if (baseCurr == "XAU")
          partialclosedinamic = NormalizeDouble(value,2); 
         else if (crossCurr == "JPY")
          partialclosedinamic = NormalizeDouble(value,3); 
         else //usd
         partialclosedinamic = NormalizeDouble(value,5);  */
         }
        }
        
             //seteo el punto de activacion 
  
          if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "ActivationLine")  
         { 
         double valuee2;
       
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,valuee2);
         Print("Activacion ea seteado en: " + ND(valuee2)); 
        /* if (baseCurr == "XAU")
          activationlevel = NormalizeDouble(valuee2,2); 
         else if (crossCurr == "JPY")
          activationlevel = NormalizeDouble(valuee2,3); 
         else //usd
         activationlevel = NormalizeDouble(valuee2,5); */
         activationlevel = NormalizeDouble(valuee2,Digits);
         }
        }
        
          //seteo el punto de inicio 
  
          if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "StartLevelLine")  
         { 
         double value2;
       
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,value2);
         Print("Ejecucion de operacion seteado en: " + ND(value2)); 
         /*if (baseCurr == "XAU")
          startlevel = NormalizeDouble(value2,2); 
         else if (crossCurr == "JPY")
          startlevel = NormalizeDouble(value2,3); 
         else //usd
         startlevel = NormalizeDouble(value2,5); */
         startlevel = NormalizeDouble(value2,Digits); 
         sldistance = MathAbs(StopLoss-startlevel)/ MyPip;
         lotcalc = NormalizeDouble(Calculatelot2(),3);
         ObjectSetText(strMyObjectName1, "Distancia SL: " + sldistance + " Lotaje: " + lotcalc, 8, "Arial Black", LimeGreen);
          if (showlogs) 
         Print ( " distancia sl : " + sldistance);
          LotSize = lotcalc;
         }
        }
        
        
              //seteo linea min max
              
          if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "VLine")  //valido que sea la linea de parcial
         { 
         datetime value222 = ObjectGet(sparam, OBJPROP_TIME1);
         //ObjectGetTimeByValue(0,sparam,OBJPROP_TIME,0,value222);
         string t_lineav =  TimeToString(ObjectGet(sparam, OBJPROP_TIME1),TIME_DATE|TIME_MINUTES);
         Print("Linea de min/max seteada en: " + t_lineav); 
                        minmaxshift=iBarShift(NULL,0,value222);
        if (showlogs)
        Print("El indice para la barra del ",TimeToStr(value222)," es ",minmaxshift);
             minmaxshift = minmaxshift + 1;
                if (showlogs)
              Print("El indice para la barra (calc) del ",TimeToStr(value222)," es ",minmaxshift);
        SetMaxMin (); 
        // startlevel = NormalizeDouble(value2,5); 
         }
        }
        
            //seteo el stop 
  
          if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "StopLevelLine")  //valido que sea la linea de parcial
         { 
         
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,value3);
         Print("Stop Loss seteado en: " + ND(value3)); 
         StopLoss = NormalizeDouble(value3,Digits);
        /* if (baseCurr == "XAU")
          StopLoss = NormalizeDouble(value3,2); 
         else if (crossCurr == "JPY")
          StopLoss = NormalizeDouble(value3,3); 
         else //usd
         StopLoss = NormalizeDouble(value3,5); */
         sldistance = MathAbs(StopLoss-startlevel)/ MyPip;
           lotcalc = NormalizeDouble(Calculatelot2(),3);
         ObjectSetText(strMyObjectName1, "Distancia SL: " + sldistance + " Lotaje: " + lotcalc, 8, "Arial Black", LimeGreen);
          if (showlogs) 
         Print ( " distancia sl : " + sldistance); 
          LotSize = lotcalc;
         }
        }
        
            //seteo el TP
  
          if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "TakeProfitLevelLine")  //valido que sea la linea de parcial
         { 
         
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,value4);
         Print("Take Profit seteado en: " + ND(value4)); 
         Takeprofit = NormalizeDouble(value4,Digits); 
          /*        if (baseCurr == "XAU")
          Takeprofit = NormalizeDouble(value4,2); 
         else if (crossCurr == "JPY")
          Takeprofit = NormalizeDouble(value4,3); 
         else //usd
         Takeprofit = NormalizeDouble(value4,5); */
         }
        }
                 //seteo linea de breakeven
  
          if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "BreakEvenLine")  //valido que sea la linea de parcial
         { 
        
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,value6);
         Print("Linea de breakeven seteada en: " + ND(value6)); 
         breakevendinamic = NormalizeDouble(value6,Digits);
           /*         if (baseCurr == "XAU")
          breakevendinamic = NormalizeDouble(value6,2); 
         else if (crossCurr == "JPY")
          breakevendinamic = NormalizeDouble(value6,3); 
         else //usd
         breakevendinamic = NormalizeDouble(value6,5);  */
         }
        }
        
                 //seteo linea de anulacion
  
          if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "AnulationLine")  //valido que sea la linea de parcial
         { 
         
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,value5);
         Print("Linea de anulacion seteada en: " + ND(value5)); 
         lineaanulacion = NormalizeDouble(value5,Digits); 
           /*                 if (baseCurr == "XAU")
          lineaanulacion = NormalizeDouble(value5,2); 
         else if (crossCurr == "JPY")
          lineaanulacion = NormalizeDouble(value5,3); 
         else //usd
         lineaanulacion = NormalizeDouble(value5,5);  */
         }
        }
  
  
  }

void Action_Button1(){
  setorder(1,1,1);
   PlaySound("ok.wav");
   
}
void Action_Button2(){
  
   setorder(1,0,1);
   PlaySound("ok.wav");
   
}


void Action_Button5(){
   
   setorder(0,1,1);
   PlaySound("ok.wav");
   
}
void Action_Button6(){
   
   setorder(0,0,1);
   PlaySound("ok.wav");
   
}


void Action_Button4(){
     
     EndSession();
      PlaySound("ok.wav");
       

}



  //+------------------------------------------------------------------+
//| Cierre parcial con linea de cierre parcialdinamica                |
//+------------------------------------------------------------------+


bool checkpartialclose()
  {
     double ope,lots;
     int type, ticketp;
 int i, ordersCount = OrdersTotal();
   for (i = ordersCount - 1; i >= 0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID)
        {
        ope = OrderOpenPrice();
        type = OrderType();
        lots = OrderLots();
        ticketp = OrderTicket();
   
       
        if (type == OP_BUY && Bid  >= partialclosedinamic)
           {
                if (lots  > 0.01)
                { 
           //splpage parece q es 30 no 3 revisar
            if(!OrderClose(ticketp,lots/2,Bid,30,clrRed))
            {
            textsend ="Fallo al realizar cierre parcial (line) " + _Symbol;
            return false;
            }
            else 
            { 
             textsend="Cierre parcial realizado (line) " + _Symbol;
             cierreparcialrealizado = True;
            }
             }
             else
             {
           textsend= "ALERTA!!! No se realizo cierre parcial (line) debido a que el lotaje restante en la orden no lo permite, revisar ";
           cierreparcialrealizado = True; 
             }
              Sendnotifications(textsend);
           }
             
        else if (type == OP_SELL && Ask  <= partialclosedinamic)
            {
                 if (lots  > 0.01)
                 { 
            if(!OrderClose(ticketp,lots/2,Ask,30,clrRed))
            {
            textsend="Fallo al realizar cierre parcial (line) " + _Symbol;
            return false;
            }
            else 
            { 
            textsend ="Cierre parcial realizado (line) " + _Symbol;
            cierreparcialrealizado = True;   
            
            }
             }
             else
              {
           textsend="ALERTA!!! No se realizo cierre parcial (line) debido a que el lotaje restante en la orden no lo permite, revisar ";
           cierreparcialrealizado = True; 
              }
              Sendnotifications(textsend);
            }
           
         
       
         }
     }
   return (true);
  }

  //+------------------------------------------------------------------+
//| Cierre parcial fibo seguimiento                                  |
//+------------------------------------------------------------------+


bool checkpartialclosefibo()
  {
     double ope,lots;
     int type, ticketp;
 int i, ordersCount = OrdersTotal();
   for (i = ordersCount - 1; i >= 0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID)
        {
        ope = OrderOpenPrice();
        type = OrderType();
        lots = OrderLots();
        ticketp = OrderTicket();
     
       // Print ( " ask - fibo " + Ask + " - " + fibo809);  
        if (type == OP_BUY && Bid  < fibo809)
           {
               if (lots  > 0.01)
              { 
           //splpage parece q es 30 no 3 revisar
            if(!OrderClose(ticketp,lots/2,Bid,30,clrRed))
            {textsend =" fallo al realizar cierre parcial (fibo)";
            Sendnotifications(textsend);
            return false;
            }
            else 
            { textsend ="Cierre parcial (fibo) realizado";
            Sendnotifications(textsend);
           
            cierreparcialrealizadofibo = True;
            }
            }
             else
             {
           Print("ALERTA!!! No se realizo cierre parcial (fibo) debido a que el lotaje restante en la orden no lo permite, revisar ");
           cierreparcialrealizadofibo = True;
           }  
           }
          
        else if (type == OP_SELL && Ask  > fibo809)
            {
            
                   if (lots  > 0.01)
                   { 
            if(!OrderClose(ticketp,lots/2,Ask,30,clrRed))
            {
            textsend =" fallo al realizar cierre parcial (fibo)";
            Sendnotifications(textsend);
            return false;
            }
            else 
            { textsend ="Cierre parcial (fibo) realizado";
            Sendnotifications(textsend);
            cierreparcialrealizadofibo = True;   
            
            }
            
            }
             else
             {
           Print("ALERTA!!! No se realizo cierre parcial (fibo) debido a que el lotaje restante en la orden no lo permite, revisar ");
           cierreparcialrealizadofibo = True;
           }  
            }
          
                
    
         
        }
     }
   return (true);
  }
 
  //+----------------------------------------------------------------+
//| Cierre parcial en perdida                                        |
//+------------------------------------------------------------------+


bool checkpartialcloseper()
  {
     double ope,lots;
     int type, ticketp;
 int i, ordersCount = OrdersTotal();
 // Print ( " parcial en perdida: " +  partialclosedinamicperdida + " - " + partialclosedinamicperdida * MyPip + " - " + partialclosedinamicperdida / MyPip );
   for (i = ordersCount - 1; i >= 0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID)
        {
        ope = OrderOpenPrice();
        type = OrderType();
        lots = OrderLots();
        ticketp = OrderTicket();
   
       
        if (type == OP_BUY && Bid  <= partialclosedinamicperdida)
           {
                if (lots  > 0.01)
                { 
           //splpage parece q es 30 no 3 revisar
            if(!OrderClose(ticketp,lots/2,Bid,30,clrRed))
            {
            textsend= OrderID + "Fallo al realizar cierre parcial en perdida " + _Symbol;
            return false;
            }
            else 
            { 
            textsend= OrderID + "Cierre parcial en perdida realizado: " + _Symbol;
            cierreparcialperdidarealizado = True;
            }
             }
             else
             {
           textsend= OrderID + "ALERTA!!! No se realizo cierre parcial en perdida debido a que el lotaje restante en la orden no lo permite, revisar.";
           cierreparcialperdidarealizado = True; 
             }
             Sendnotifications(textsend);
           }
             
        else if (type == OP_SELL && Ask  >= partialclosedinamicperdida)
            {
                 if (lots  > 0.01)
                 { 
            if(!OrderClose(ticketp,lots/2,Ask,30,clrRed))
            {
             textsend=OrderID + "Fallo al realizar cierre parcial en perdida " + _Symbol;
            
            return false;
            }
            else 
            { 
            textsend=OrderID + "Cierre parcial en perdida realizado: " + _Symbol;
            cierreparcialperdidarealizado = True;   
            }
             }
             else
              {
           textsend = OrderID + "ALERTA!!! No se realizo cierre parcial (line) debido a que el lotaje restante en la orden no lo permite, revisar ";
           cierreparcialperdidarealizado = True; 
              }
               Sendnotifications(textsend);
            }
           
         
       
         }
     }
   return (true);
  }

 int CheckCurrentOrders(int control)
  {
   bool openorders= FALSE;
//---
   /*int totalorders = OrdersTotal();
      for(int i=0;i<totalorders;i++)
        {*/
int controlc;
controlc = control;
   int i, ordersCount = OrdersTotal();
   for(i = ordersCount - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID && OrderType()< controlc)
        {
         openorders=TRUE;
            ordertime = OrderOpenTime();
            orderlots = OrderLots();
             Orderticket = OrderTicket();
             if (OrderType() == 1)  //sell
             openordertype =0;
             else
             openordertype =1;//buy
             tfcontrol = True;partialclosedinamicperdida = NormalizeDouble(OrderOpenPrice() - ((OrderOpenPrice() - StopLoss) / 2),Digits) ;
         break;

        }
        //Print (" symb - magi " + Symbol() + " - " + OrderMagicNumber() + " - " + OrderID);
     }
   if(openorders)
      return (1);
   else
      return (0);
  }
  
   int AutosetOrderID(int control=6)
  {
 
//---
   /*int totalorders = OrdersTotal();
      for(int i=0;i<totalorders;i++)
        {*/
int  calculatedid=0;

   int i, ordersCount = OrdersTotal();
   for(i = ordersCount - 1; i >= 0; i--)
     {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false)
         break;

      if(OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID && OrderType()< control)
        { calculatedid=1; break;}
          else if( OrderMagicNumber()==OrderID+1 )
             {calculatedid=2; break;}
           else if( OrderMagicNumber()==OrderID+2 )
                 {calculatedid=3; break;}
              else if( OrderMagicNumber()==OrderID+3 )
                     {calculatedid=4; break;}
                   else if( OrderMagicNumber()==OrderID+4 )
                          {calculatedid=5; break;} 
                       else if( OrderMagicNumber()==OrderID+5 )
                          {calculatedid=6; break;} 
                              else if( OrderMagicNumber()==OrderID+6 )
                                 {calculatedid=7; break;} 
                                 else if( OrderMagicNumber()==OrderID+7 )
                                      {calculatedid=8; break;} 
                                       else if( OrderMagicNumber()==OrderID+8 )
                                        {calculatedid=-1; break;}    // si llegan a haber mas de 8 operaciones debo poder comprobarlo
                          
             

        }
        //Print (" symb - magi " + Symbol() + " - " + OrderMagicNumber() + " - " + OrderID);
     
        return (calculatedid);
  }

 bool EndSession()
{

Print ( " closing order at : " + Hour() + ":" + Minute()+ " ask /  bid " + Ask + "/ " + Bid);

int total = OrdersTotal();

for(cpt = total - 1; cpt >= 0; cpt--)
{
//OrderSelect(cpt,SELECT_BY_POS,MODE_TRADES);
if(OrderSelect(cpt,SELECT_BY_POS,MODE_TRADES)==false) break;
if ( OrderMagicNumber()==OrderID && OrderSymbol() == Symbol() )
{
 if (OrderType() == OP_BUY)
{
       if(!OrderClose(OrderTicket(), OrderLots(), Bid, 3, Red))
            {Print (" fallo al realizar cierre de orden buy ");
            return false;
            }
            else 
            { Print ("Se cerro la orden buy correctamente");}
//OrderClose(OrderTicket(), OrderLots(), Bid, 3, Red);
} 
else if ( OrderType() == OP_SELL)
{
   if(!OrderClose(OrderTicket(), OrderLots(), Ask, 3, Red))
            {Print (" fallo al realizar cierre de orden sell ");
            return false;
            }
            else 
            { Print ("Se cerro la orden sell correctamente");}
//OrderClose(OrderTicket(), OrderLots(), Ask, 3, Red);
}
else
  { if(!OrderDelete(OrderTicket(), Red))
            {Print (" fallo al realizar cierre de orden pendiente ");
            return false;
            }
            else 
            { Print ("Se cerro la orden pendiente correctamente");}

}}}

    //--- delete from the chart
   HLineDelete(0,InpName); HLineDelete(0,InpName2);    
   //cierre fibos
   if (usemaxminfiboseg)
   {HLineDelete(0,InpNamef+(string)0);   HLineDelete(0,InpNamef+(string)1);   HLineDelete(0,InpNamef+(string)2);   HLineDelete(0,InpNamef+(string)3);}   
    
return(true);
}


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


//+------------------------------------------------------------------+
//| Create the vertical line                                         |
//+------------------------------------------------------------------+
bool VLineCreate(const long            chart_ID=0,        // chart's ID
                 const string          name="VLine",      // line name
                 const int             sub_window=0,      // subwindow index
                 datetime              time=0,            // line time
                 const color           clr=clrRed,        // line color
                 const ENUM_LINE_STYLE style=STYLE_SOLID, // line style
                 const int             width=1,           // line width
                 const bool            back=false,        // in the background
                 const bool            selection=true,    // highlight to move
                 const bool            hidden=true,       // hidden in the object list
                 const long            z_order=0)         // priority for mouse click
  {
//--- if the line time is not set, draw it via the last bar
   if(!time)
      time=TimeCurrent();
//--- reset the error value
   ResetLastError();
//--- create a vertical line
   if(!ObjectCreate(chart_ID,name,OBJ_VLINE,sub_window,time,0))
     {
      Print(__FUNCTION__,
            ": failed to create a vertical line! Error code = ",GetLastError());
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
//| Move the vertical line                                           |
//+------------------------------------------------------------------+
bool VLineMove(const long   chart_ID=0,   // chart's ID
               const string name="VLine", // line name
               datetime     time=0)       // line time
  {
//--- if line time is not set, move the line to the last bar
   if(!time)
      time=TimeCurrent();
//--- reset the error value
   ResetLastError();
//--- move the vertical line
   if(!ObjectMove(chart_ID,name,0,time,0))
     {
      Print(__FUNCTION__,
            ": failed to move the vertical line! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete the vertical line                                         |
//+------------------------------------------------------------------+
bool VLineDelete(const long   chart_ID=0,   // chart's ID
                 const string name="VLine") // line name
  {
//--- reset the error value
   ResetLastError();
//--- delete the vertical line
  if ( ObjectFind(0,name) == 0)
   { if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete the vertical line! Error code = ",GetLastError());
      return(false);
     }
    }
   else
   return(true);
//--- successful execution
   return(true);
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


void SetRRMain() {   
   double dist;double ordopen; double ordstop; int ordertype;
   if (orderset) //calculo parametros si hay orden abierta
   {
    int i, ordersCount = OrdersTotal();
   for (i = ordersCount - 1; i >= 0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID)
        {
        ordopen = OrderOpenPrice();
        ordstop = OrderStopLoss();
        ordertype =  OrderType();
        }
       }
    }
    else // calculo si no hay ordenes
      {
       ordopen = startlevel;
        ordstop = StopLoss;
       }
      
      
   dist = MathAbs(ordstop-ordopen); //calculo pips entre start y SL     
 if (orderset)   //calculo para cuando hay orden abierta
   {
     //seteo variables
   if (ordertype == 0 ) //buy
   {
    Takeprofit = ordopen + (dist * rmainparam);
    //partialclosedinamic = ordopen + (dist * (rmainparam/2));
    partialclosedinamic = ordopen + (dist * 2);
   }
   else if (ordertype == 1 )
    {
      Takeprofit = ordopen - (dist * rmainparam);
     //partialclosedinamic = ordopen - (dist * (rmainparam/2));
     partialclosedinamic = ordopen + (dist * 2);
   }
   res = OrderModify(OrderTicket(), 0, OrderStopLoss(), Takeprofit, 0);// coloco  tp
   if(!res) {  Alert("OrderModify Error: ", GetLastError());
    Alert("IMPORTANT: ORDER #", ticket, " Error al modificar TakeProfit!!!!");Print("IMPORTANT: ORDER #", ticket, " Error al modificar TakeProfit!!!!");  }
    else {Print ( " Se modifico el TP correctamente " + rmainparam/2 );}
   }
    else  //calculo teorico en seteos
      {
   
  //seteo variables
   if (startorder == 1 )
   {
     Takeprofit = ordopen + (dist * rmainparam);
     //partialclosedinamic = ordopen + (dist * (rmainparam/2));
     partialclosedinamic = ordopen + (dist * 2);
   }
   else if (startorder == 2 )
    {
     Takeprofit = ordopen - (dist * rmainparam);
     //partialclosedinamic = ordopen - (dist * (rmainparam/2));
           partialclosedinamic = ordopen - (dist * 2);
   }
      }

 if (showlogs)
  Print ( " dist - pc - tp " + dist/Point() + " - " + partialclosedinamic + " - " + Takeprofit );
  
   //muevo lineas
    HLineMove(0,"PartialCloseLine",partialclosedinamic);
    HLineMove(0,"BreakEvenLine",partialclosedinamic);
    breakevendinamic = partialclosedinamic;
    
      if (!orderset)  //esta linea no existe si la orden fue ejecutada
      {
     HLineMove(0,"TakeProfitLevelLine",Takeprofit);
     }
}

void SetRRSec() {   

   double dist;double ordopen; double ordstop; int ordertype;
   
   if (orderset)  //calculo parametros si hay orden abierta
   {
    int i, ordersCount = OrdersTotal();
   for (i = ordersCount - 1; i >= 0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID)
        {
        ordopen = OrderOpenPrice();
        ordstop = OrderStopLoss();
        ordertype =  OrderType();
        }
       }
    }
    else   // calculo si no hay ordenes
      {
       ordopen = startlevel;
        ordstop = StopLoss;
       }
      
      
   dist = MathAbs(ordstop-ordopen); //calculo pips entre start y SL  
      
 if (orderset)   //calculo para cuando hay orden abierta
   {
     //seteo variables
   if (ordertype == 0 ) //buy
   {
     Takeprofit = ordopen + (dist * rsecparam);
     //partialclosedinamic = ordopen + (dist * (rsecparam/2));
     //-- 23/2/2022 en base a la operativa planteada para este año es que ahora los cierres parciales seran en 2 tanto para ratio 1-4 como para 1-6 de forma tal que queden medias de salida 2 y 3 respectivamente
      partialclosedinamic = ordopen + (dist * 2);
   }
   else if (ordertype == 1 )
    {
     Takeprofit = ordopen - (dist * rsecparam);
     //partialclosedinamic = ordopen - (dist * (rsecparam/2));
     partialclosedinamic = ordopen - (dist * 2);
   }
       res = OrderModify(OrderTicket(), 0, OrderStopLoss(), Takeprofit, 0);// coloco  tp
         if(!res) {  Alert("OrderModify Error: ", GetLastError());
                Alert("IMPORTANT: ORDER #", ticket, " Error al modificar TakeProfit!!!!");Print("IMPORTANT: ORDER #", ticket, " Error al modificar TakeProfit!!!!");  }
                else {Print ( " Se modifico el TP correctamente");}
   }
    else  //calculo teorico en seteos
      {
   
  //seteo variables
   if (startorder == 1 )
   {
     Takeprofit = ordopen + (dist * rsecparam);
     //partialclosedinamic = ordopen + (dist * (rsecparam/2));
     partialclosedinamic = ordopen + (dist * 2);
   }
   else if (startorder == 2 )
    {
     Takeprofit = ordopen - (dist * rsecparam);
     //partialclosedinamic = ordopen - (dist * (rsecparam/2));
     partialclosedinamic = ordopen - (dist * 2);
   }
      }

 if (showlogs)
  Print ( " dist - pc - tp " + dist/Point() + " - " + partialclosedinamic + " - " + Takeprofit );
  
   //muevo lineas
    HLineMove(0,"PartialCloseLine",partialclosedinamic);
    HLineMove(0,"BreakEvenLine",partialclosedinamic);
    
     if (!orderset)  //esta linea no existe si la orden fue ejecutada
   {
     HLineMove(0,"TakeProfitLevelLine",Takeprofit);
   }
   
  
}

//nueva funcion para calcular el lotaje con el bot (esta en prueba)
double Calculatelot2() { 
       string crossCurr = StringSubstr(Symbol(),3,3);
        double lotaje, Riskperopcalc;
        //control de lot por % de riesgo
        if (riesgoop == 1)
        Riskperopcalc = Riskperop;
        else 
        Riskperopcalc = Riskperop/2;
        
        //control de lot por cantidad de disparos
        if (formaoperativa == 2)
        Riskperopcalc = Riskperopcalc/cantidadop;
      
       // Print ( " base curr - expresion " + baseCurr + " - " + (baseCurr == "USD"));
       if(crossCurr == "USD") { 
        lotaje=(Riskperopcalc / sldistance) / 10;
        } else if(crossCurr == "JPY") {  
       lotaje=(Riskperopcalc / sldistance)*Ask / 1000;  
        }
        else if(crossCurr == "CAD") {  
       lotaje=(Riskperopcalc / sldistance)*Ask / 10;  
        }
        else
        lotaje = -99;
        
        return (lotaje);
}
//funcion vieja no la toco por si necesito algo de aca
double Calculatelot() { 
 double dist,base; string paircalc;
    size  = AccountBalance(); //tamaño de cuenta
    riskMoney =  size * RiskPercentage; //riesgo en usd ( en base al % determinado
    double tickSize = MarketInfo( Symbol(), MODE_TICKSIZE )*10;  // un pip
   dist = MathAbs(StopLoss-startlevel)/ MyPip; //calculo pips  SL     
   
  // double unitCost = MarketInfo( Symbol(), MODE_TICKVALUE );
   

   

  // double tickSize = 0.0001;
    //     double unitCost = tickSize*100000*0.01;
   // Important for startup MT4, without generate an error
   //if( unitCost == 0 )return( 0 );  
       string baseCurr = StringSubstr(Symbol(),0,3);
    string crossCurr = StringSubstr(Symbol(),3,3);
    
       if(baseCurr == AccountCurrency()) { 
        //lots = (riskCapital / stopLoss) / tickValue;
        //Print("Calculated lots (A/C currency = Quote currency): ", lots);
         positionSize = ((riskMoney * Ask / dist)/tickSize)/Lotstd;
    } else if(crossCurr == AccountCurrency()) {  
        // 
          if (baseCurr == "XAU")
          positionSize = ((riskMoney / dist)/tickSize)/Lotstdcfd;
          else
          positionSize = ((riskMoney / dist)/tickSize)/Lotstd;
    
    }
    else
    {   
    Print ( " no cross, base , cross " + baseCurr + " - " + crossCurr);  
    paircalc = "USD"+crossCurr;
    base = MarketInfo(paircalc,MODE_ASK);
     positionSize = ((riskMoney * base / dist)/tickSize)/Lotstd;
     
      }
    
    // en base a la moneda base calcular lotaje con el rate  

    //positionSize = ( unitCost > 0 ) ? riskMoney / ( ( ( NormalizeDouble( dist, Digits ) ) * unitCost ) / tickSize ) : 0 ;
    if (showlogs)
   Print ( "  risk money - dist - risk/dist - ticksize - lotstp -  position size: "+ riskMoney + " - " + dist + " - "+ (riskMoney/dist) + " - " +  tickSize + " - " + Lotstd + " - " +  positionSize);
  
  
  // Print ( " base - dist - risk/dist - acc - riskp - risk money - ticksize - lotstp -  position size: "+ base + " - " + dist + " - " (riskMoney / dist) + " - " +  size + " - " + RiskPercentage + " - " + riskMoney +  " - " + tickSize + " - " + Lotstd + " - " +  NormalizeDouble(positionSize,2));
   return (positionSize);
   }

void Showinfovar () 
{ string operacion;
if (orderset)
{if (openordertype == 1)
{operacion = "Buy";
Takeprofitorder = BuyGoal;
}
else
{operacion = "Sell";
Takeprofitorder = SellGoal;
}
Print  ( " Gestionando operacion: " + operacion + " ticket: " + Orderticket +  " con cierre parcial en beneficio de : " + partialclosedinamic + " cierre por fibo en: " + fibo809 + " SL: " + StopLossorder + " TP: " + Takeprofitorder + " Lot original: " + LotSize + " Indice Min/Max seteado: " + minmaxshift );
Print  ( "Orderid: " + OrderID + " BE dinamic: " + breakevendinamic + " BE realizado: " + breakevenrealizado + " Cierre en ganacia realizado: " + cierreparcialrealizado + " Cierre en perdida realizado: " + cierreparcialperdidarealizado + " Cierre por fibo realizado : " + cierreparcialrealizadofibo);
}
else
{
if (startorder == 1)
operacion = "Buy ";
else
operacion = "Sell ";
Print  ( " Gestionando operacion: " + operacion + " ticket: " + Orderticket + " con cierre parcial en beneficio de : " + partialclosedinamic + " anulacion en: " + lineaanulacion + " SL: " + StopLoss + " TP: " + Takeprofit + " Lot original: " + LotSize  + " Indice Min/Max seteado: " + minmaxshift );
Print  ( "Orderid: " + OrderID + " BE dinamic: " + breakevendinamic + " BE realizado: " + breakevenrealizado + " Cierre en ganacia realizado: " + cierreparcialrealizado + " Cierre en perdida realizado: " + cierreparcialperdidarealizado + " Cierre por fibo realizado : " + cierreparcialrealizadofibo);

}
  }
  
  
  void SetMaxMin () 
{ 
  // busco min y max para trazar fibo de seguimiento 
         if (startorder == 2) //sell
         {
          //busco barra con el max
          maxbar = iHighest(NULL,0,MODE_HIGH,minmaxshift,0);
          maxvalue = iHigh(NULL,0,maxbar);
             HIGH = maxvalue;  // para trazado de fibo
             if (showlogs)
          Print ( " max bar base - value : " + maxbar + " - " + maxvalue );
             
              //busco barra con el min por si estoy operando un retrace
               minbar61 = iLowest(NULL,0,MODE_LOW,minmaxshift,0);
                minvalue61 = iLow(NULL,0,minbar61);
               if (showlogs)
                Print ( " min bar base61 - value : " + minbar61 + " - " + minvalue61 );
              
          }
          else if  (startorder == 1) //buy
          {
                    //busco barra con el min
          minbar = iLowest(NULL,0,MODE_LOW,minmaxshift,0);
          minvalue = iLow(NULL,0,minbar);
          LOW = minvalue; // para trazado de fibo
          if (showlogs)
          Print ( " min bar base  - value  : " + minbar + " - " + minvalue );
 
               //busco barra con el max por si estoy operando un retrace
               maxbar61 = iHighest(NULL,0,MODE_HIGH,minmaxshift,0);
                maxvalue61 = iHigh(NULL,0,maxbar61);
               if (showlogs)
                Print ( " max bar base61 - value : " + maxbar61 + " - " + maxvalue61 );
              
          }


  }
  
    void dobreakeven (int typebe) {
     //-- break even
     int total_orders = OrdersTotal();  
   for (int i = total_orders - 1; i >= 0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID ) { //chequeo q sean ordenes de este bot
      if ( (OrderOpenPrice() != OrderStopLoss())) //controlo que el sl no sea igual al precio de apertura para que no este entrando en cada tick
      {
               
               if((OrderType()==OP_SELL)  ){
                      ModifyStopLoss2(OrderOpenPrice(), Red,OrderOpenPrice(), OrderTakeProfit(),typebe);
               }
               
               if((OrderType()==OP_BUY)  ){
                      ModifyStopLoss2(OrderOpenPrice(), Green,OrderOpenPrice(), OrderTakeProfit(),typebe);
                      }
       
      }
      }}}
   }
   
       void breakevendinamic () {
       if (showlogs)
       Print ( " entro a be dinamic function ");
     //-- break even
     int total_orders = OrdersTotal();  
   for (int i = total_orders - 1; i >= 0; i--) {
    if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES)) {
      if (OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID ) { //chequeo q sean ordenes de este bot
      if ( (OrderOpenPrice() != OrderStopLoss())) //controlo que el sl no sea igual al precio de apertura para que no este entrando en cada tick
      {
               if (OrderType() == OP_SELL && Ask  <= breakevendinamic)
            {
                      ModifyStopLoss2(OrderOpenPrice(), Red,OrderOpenPrice(), OrderTakeProfit(),0);
                      cierreparcialperdidarealizado = True;  //ya no necesito controlar esto apartir de ahora
               }
                      if (OrderType() == OP_BUY && Bid  >= breakevendinamic) {
                      ModifyStopLoss2(OrderOpenPrice(), Green,OrderOpenPrice(), OrderTakeProfit(),0);
                      cierreparcialperdidarealizado = True;  //ya no necesito controlar esto apartir de ahora
                      }
                   
                      
             
      }
      }}}
   }  
   
   //+------------------------------------------------------------------+
// Order Modify function
//+------------------------------------------------------------------+
void ModifyStopLoss2(double ldStop, string opcolour,  double ldOpen, double ldTake, double typebe) {
  /*double ldOpen=OrderOpenPrice();
  double ldTake=OrderTakeProfit();*/
        //LINEA ORIGINAL COMENTADA POR Q ME CAMBIABA EL TP POR ENDE LAS ORDENES CIERRAN ANTES

  //fm=OrderModify(OrderTicket(), ldOpen, ldStop, ldTake, 0, Pink);
//Print (" stop : " + ldStop);
       res = OrderModify(OrderTicket(), ldOpen, ldStop, ldTake, 0, opcolour);
      if(!res) {  
                 //Print ( "Res: " + res);
                 Alert("SL: " + ldStop + "TP: " + ldTake );
                  Alert("OrderModify Error: ", GetLastError());
                  Alert("IMPORTANT: ORDER #", OrderTicket(), " HAS NO STOPLOSS AND TAKEPROFIT");
                     if (typebe == 1)
                    Print (OrderID + "Error al realizar break even (button)");
                    else  if (typebe == 0)
                     Print (OrderID + "Error al realizar break even dinamico (line)");
                      else
                     Print (OrderID +"Error al realizar break even(Gestion por toma de parcial)");
               }

                  else
                  {  
                    if (typebe == 1)
                    Print (OrderID + "Break even realizado (button)");
                    else if (typebe == 0)
                     Print (OrderID + "Break even dinamico realizado (line)");
                          else 
                     Print (OrderID + "Break even realizado (Gestion por toma de parcial)");
                    //Print("sl modificado correctamente.");//Alert("sl modificado correctamente");
                  } 
  
}

//confirmacion de operativa

void confirmationevent ()
{

    //primero hago una validacion de lotaje
  lotcalc = NormalizeDouble(Calculatelot2(),3);
            if ((LotSize > lotcalc) && (usecalculatelot))
                  ObjectSetText(strMyObjectName, "El lotaje seteado excede el riesgo definido!!", 8, "Arial Black", Red);
            else if (( HIGH == -99 ) && ( LOW == -99)&& (usemaxminfiboseg))
                  ObjectSetText(strMyObjectName, "No se ha definido maximo/minimo para la operación ", 8, "Arial Black", Red);
            else
              { 
          
              Lotorder = LotSize;
              ObjectSetText(strMyObjectName, "Seteo confirmado con lotaje: " + Lotorder, 8, "Arial Black", LimeGreen);
                   confirmationop= true;  activationconfirm = false;
                 //colola orden pendiente en funcion de la linea verde (startlevel)
                 if ((startlevel > Ask) && (startorder == "1"))
                 {
                   //buy stop
                   ticket = OrderSend(Symbol(),OP_BUYSTOP,Lotorder,startlevel,Slippage,StopLoss,Takeprofit,NULL,OrderID,0,Green);
                   firstordertype = 1; ordertypesave = OP_BUYSTOP; bidaskinicioorden = Ask;
                  }
                  else if ( startorder == "1"  )
                  {
                   //buy limit
                   ticket = OrderSend(Symbol(),OP_BUYLIMIT,Lotorder,startlevel,Slippage,StopLoss,Takeprofit,NULL,OrderID,0,Green);
                   firstordertype = 1;ordertypesave = OP_BUYLIMIT; bidaskinicioorden = Ask;
                  }
                  else
                  {
                  
                  if ((startlevel > Bid) && ( startorder == "2"  ))
                  {
                   //sell limit
                       ticket = OrderSend(Symbol(),OP_SELLLIMIT,Lotorder,startlevel,Slippage,StopLoss,Takeprofit,NULL,OrderID,0,Green);
                       firstordertype = 0;ordertypesave = OP_SELLLIMIT; bidaskinicioorden = Bid;
                  }
                  else if ( startorder == "2"  )
                  {
                   //sell stop
                   
                     ticket = OrderSend(Symbol(),OP_SELLSTOP,Lotorder,startlevel,Slippage,StopLoss,Takeprofit,NULL,OrderID,0,Green);
                     firstordertype = 0;ordertypesave = OP_SELLSTOP; bidaskinicioorden = Bid;
                  }
                  
                   }
                //   Print ( " ticket : " + ticket );
                       if(!ticket) {  Alert("OrderSend Error: ", GetLastError());
                Alert("IMPORTANT: NO SE PUDO COLOCAR ORDEN PENDIENTE"); }
                else {Print ( " Orden Pendiente colocada con exito") ;
                
                //borro lineas que ya no voy a utilizar
                 HLineDelete(0,InpName2);
           HLineDelete(0,InpName3);
           HLineDelete(0,InpName4);
             HLineDelete(0,InpName7);
             if (usemaxminfiboseg)
             VLineDelete(0,VInpName);
               //guardo el valor de la orden ya que luego en el caso de los extremos puedo ir moviendola
               nivelinicioorden = startlevel; orderticketsave = ticket; stoptemp = StopLoss; tptemp = Takeprofit;
                }
          
             
                    ObjectSetInteger(0,"button16",OBJPROP_BGCOLOR,Green);
              }
              return;
}

void movelimitorder()
{

//reconozco el tipo de orden

if ((ordertypesave == 2) || (ordertypesave == 4))  //si es buy se baja la orden por la diferencia detectada 
{neworderlevel = nivelinicioorden-orderdiff;StopLossorder= stoptemp -orderdiff;BuyGoal= tptemp-orderdiff;}
else if ((ordertypesave == 3) || (ordertypesave == 5))  //sell se sube la orden
{neworderlevel = nivelinicioorden+orderdiff;StopLossorder= stoptemp +orderdiff; BuyGoal= tptemp+orderdiff; }


res = OrderModify(orderticketsave, neworderlevel, StopLossorder, BuyGoal, 0);
  // Print ( " New order level:" + neworderlevel );
          
     if(!res) {  Alert("OrderModify Error: ", GetLastError());
                Alert("No se pudo actualizar orden pendiente, revisar"); }
                else {Print ( " Orden pendiente actualizada por desplazamiento del precio" );
           //actualizo nivel de activacion original para que pueda seguir comparando la diferencia
                     if (startorder == 1) //buy
            activationlevel = Ask;  //uso la variable de activationlevel para ir guardando el nivel de la nueva orden una vez que se mueve
                    else
             activationlevel = Bid;  //uso la variable de activationlevel para ir guardando el nivel de la nueva orden una vez que se mueve
              //  Print ( " New level:" + activationlevel );
                //ya que no selecciono la orden cada vez que la actualizo debeo guardar los datos
                            nivelinicioorden = neworderlevel; stoptemp = StopLossorder; tptemp = BuyGoal;
                }
}
 // cierre parcial por boton
bool dopartialclose()
  {
     double ope,lots;
     int type, ticketp;
 int i, ordersCount = OrdersTotal();
   for (i = ordersCount - 1; i >= 0; i--) {
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false) break;
      if(OrderSymbol()==Symbol() && OrderMagicNumber()==OrderID)
        {
        ope = OrderOpenPrice();
        type = OrderType();
        lots = OrderLots();
        ticketp = OrderTicket();
   
       
        if (type == OP_BUY)
           {
                if (lots  > 0.01)
                { 
           //splpage parece q es 30 no 3 revisar
            if(!OrderClose(ticketp,lots/2,Bid,30,clrRed))
            {Print (OrderID + "Fallo al realizar cierre parcial (button)");
            return false;
            }
            else 
            { Print (OrderID + "Cierre parcial realizado (button)");
           
            cierreparcialrealizado = True;
            }
             }
             else
             {
           Print(OrderID + "ALERTA! No se realizo cierre parcial (button) debido a que el lotaje restante en la orden no lo permite, revisar ");
           cierreparcialrealizado = True; 
             }
           }
             
        else if (type == OP_SELL)
            {
                 if (lots  > 0.01)
                 { 
            if(!OrderClose(ticketp,lots/2,Ask,30,clrRed))
            {Print (OrderID + " Fallo al realizar cierre parcial (button)");
            return false;
            }
            else 
            { Print (OrderID + "Cierre parcial realizado (button)");
             // Print( "check open : " + checkopen);
            cierreparcialrealizado = True;   
            
            }
             }
             else
              {
           Print(OrderID + "ALERTA! No se realizo cierre parcial (button) debido a que el lotaje restante en la orden no lo permite, revisar ");
           cierreparcialrealizado = True; 
              }
            }
           
         
       
         }
     }
   return (true);
  }  
  
    //alertas por telegram notificaciones push y print
  void Sendnotifications (string message)
  {
         if ( sendpushnotification)
         SendNotification(message);
         Print (message);
          ObjectSetText(strMyObjectName, message, 12, "Arial Black", Orange);
         if (sendtelegrammessages)
         bot.SendMessage(483136962,message);
  }