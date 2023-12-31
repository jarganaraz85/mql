//+------------------------------------------------------------------+
//|                                        Milito Vega Draw v2.0.mq4 |
//|                                                   JUAN ARGAÑARAZ |
//|                                              argjuan85@gmail.com |
//+------------------------------------------------------------------+

#property copyright "JUAN ARGAÑARAZ"
#property version "2.0"  
#property description "argjuan85@gmail.com"

#include "stdlib.mqh"
#include "Telegram.mqh"		// Necesario para que funcione enviar mensajes a Telegram

extern string Milito_Vega_Draw;
input string BASIC_SETUP          = "====== Configuración de alertas y mensajes  ========"; // =================
extern bool showlogs = false;
extern bool sendtelegrammessages = true;
extern bool sendpushnotification = true;
extern bool Showinfo = false;  //muestra info de la operacion

//extern string TELEGRAM_MESSAGES;
//string 	aaa			= "====== Configuracion Telegram ========";	// =================
ENUM_LANGUAGES    InpLanguage=LANGUAGE_EN;//Language
string 	InpToken		= "762665781:AAGBkpf6yaOhRap4m87ixOyqdEnnmXnRMpM";	// Token del bot // test "854948219:AAGqWAj4IYiTlLY-t0J8CMKnn6EWPSJWaSI";//
string 	userauth		= "@argjuan85"; //usuarios permitidos por el bot para operar


//-- linea para setear alertas por ciclo
 string          InpNameAlert="LineAlert";     // Line name

//--- input parameters of the script
 string          InpName="FirstCicle61";     // Line name
 string          InpName2="SecondCicle61";     // Line name
 string          InpName3="ThirdCicle61";     // Line name
 string          InpName4="FourthCicle61";     // Line name
 string          InpName5="FifthCicle61";     // Line name
 string          InpName6="Alert61";     // Line name
 string          InpName7="Alert612";     // Line name
 string          InpName8="Control61";     // Line name
 string          InpName9="Seg61";     // Line name
 string          InpName10="SixthCicle61";     // Line name
 string          InpName11="SeventhCicle61";     // Line name
 string          InpName12="Control612";     // Line name
 string          InpName13="Seg612";     // Line name

//- nombre de rectangulo que almacena coordenadas para fibo de ciclo
 string          InpNamecoordlow="FirstCicle61coordlow";     // Line name
 string          InpNamecoordlow2="SecondCicle61coordlow";     // Line name
 string          InpNamecoordlow3="ThirdCicle61coordlow";     // Line name
 string          InpNamecoordlow4="FourthCicle61coordlow";     // Line name
 string          InpNamecoordlow5="FifthCicle61coordlow";     // Line name
 string          InpNamecoordlow6="Alert61coordlow";     // Line name
 string          InpNamecoordlow7="Alert612coordlow";     // Line name
 string          InpNamecoordlow8="Control61coordlow";     // Line name
 string          InpNamecoordlow9="Seg61coordlow";     // Line name
 string          InpNamecoordlow10="SixthCicle61coordlow";     // Line name
 string          InpNamecoordlow11="SeventhCicle61coordlow";     // Line name
 string          InpNamecoordlow12="Control612coordlow";     // Line name
 string          InpNamecoordlow13="Seg612coordlow";     // Line name
 string          InpNamecoordhigh="FirstCicle61coordhigh";     // Line name
 string          InpNamecoordhigh2="SecondCicle61coordhigh";     // Line name
 string          InpNamecoordhigh3="ThirdCicle61coordhigh";     // Line name
 string          InpNamecoordhigh4="FourthCicle61coordhigh";     // Line name
 string          InpNamecoordhigh5="FifthCicle61coordhigh";     // Line name
 string          InpNamecoordhigh6="Alert61coordhigh";     // Line name
 string          InpNamecoordhigh7="Alert612coordhigh";     // Line name
 string          InpNamecoordhigh8="Control61coordhigh";     // Line name
 string          InpNamecoordhigh9="Seg61coordhigh";     // Line name
 string          InpNamecoordhigh10="SixthCicle61coordhigh";     // Line name
 string          InpNamecoordhigh11="SeventhCicle61coordhigh";     // Line name
 string          InpNamecoordhigh12="Control612coordhigh";     // Line name
 string          InpNamecoordhigh13="Seg612coordhigh";     // Line name

//- nombre de rectangulo que almacena extremo61 de ciclo
 string          InpNameextremo611="FirstCicleextremo61";     // Line name
 string          InpNameextremo612="SecondCicleextremo61";     // Line name
 string          InpNameextremo613="ThirdCicleextremo61";     // Line name
 string          InpNameextremo614="FourthCicleextremo61";     // Line name
 string          InpNameextremo615="FifthCicleextremo61";     // Line name
 string          InpNameextremo618="Controlextremo61";     // Line name
 string          InpNameextremo619="Segextremo61";     // Line name
 string          InpNameextremo6110="SixthCicleextremo61";     // Line name
 string          InpNameextremo6111="SeventhCicleextremo61";     // Line name
 string          InpNameextremo6112="Control2extremo61";     // Line name
 string          InpNameextremo6113="Seg2extremo61";     // Line name

//- nombre de rectangulo que almacena extremo de parte alta de ciclo
 string          InpNamealta1="FirstCiclealta";     // Line name
 string          InpNamealta2="SecondCiclealta";     // Line name
 string          InpNamealta3="ThirdCiclealta";     // Line name
 string          InpNamealta4="FourthCiclealta";     // Line name
 string          InpNamealta5="FifthCiclealta";     // Line name
 string          InpNamealta8="Controlalta";     // Line name
 string          InpNamealta9="Segalta";     // Line name
 string          InpNamealta10="SixthCiclealta";     // Line name
 string          InpNamealta11="SeventhCiclealta";     // Line name
 string          InpNamealta12="Control2alta";     // Line name
 string          InpNamealta13="Seg2alta";     // Line name

//- nombre de rectangulo que almacena extremo de parte baja de ciclo
 string          InpNamebaja1="FirstCiclebaja";     // Line name
 string          InpNamebaja2="SecondCiclebaja";     // Line name
 string          InpNamebaja3="ThirdCiclebaja";     // Line name
 string          InpNamebaja4="FourthCiclebaja";     // Line name
 string          InpNamebaja5="FifthCiclebaja";     // Line name
 string          InpNamebaja8="Controlbaja";     // Line name
 string          InpNamebaja9="Segbaja";     // Line name
 string          InpNamebaja10="SixthCiclebaja";     // Line name
 string          InpNamebaja11="SeventhCiclebaja";     // Line name
 string          InpNamebaja12="Control2baja";     // Line name
 string          InpNamebaja13="Seg2Baja";     // Line name

//- nombre de rectangulo que almacena nivel de fin de ciclo de parte baja 
 string          InpNamefinbaja1="FirstCiclefinbaja";     // Line name
 string          InpNamefinbaja2="SecondCiclefinbaja";     // Line name
 string          InpNamefinbaja3="ThirdCiclefinbaja";     // Line name
 string          InpNamefinbaja4="FourthCiclefinbaja";     // Line name
 string          InpNamefinbaja5="FifthCiclefinbaja";     // Line name
 string          InpNamefinbaja8="Controlfinbaja";     // Line name
 string          InpNamefinbaja9="Segfinbaja";     // Line name
 string          InpNamefinbaja10="SixthCiclefinbaja";     // Line name
 string          InpNamefinbaja11="SeventhCiclefinbaja";     // Line name
 string          InpNamefinbaja12="Control2finbaja";     // Line name
 string          InpNamefinbaja13="Seg2finbaja";     // Line name

//- nombre de rectangulo que almacena nivel de fin de ciclo de parte alta 
 string          InpNamefinalta1="FirstCiclefinalta";     // Line name
 string          InpNamefinalta2="SecondCiclefinalta";     // Line name
 string          InpNamefinalta3="ThirdCiclefinalta";     // Line name
 string          InpNamefinalta4="FourthCiclefinalta";     // Line name
 string          InpNamefinalta5="FifthCiclefinalta";     // Line name
 string          InpNamefinalta8="Controlfinalta";     // Line name
 string          InpNamefinalta9="Segfinalta";     // Line name
 string          InpNamefinalta10="SixthCiclefinalta";     // Line name
 string          InpNamefinalta11="SeventhCiclefinalta";     // Line name
 string          InpNamefinalta12="Control2finalta";     // Line name
 string          InpNamefinalta13="Seg2finalta";     // Line name

//nombre rectangulos partes altas
 string          InpNameT="FirstCicleTop";     // Line name
 string          InpNameT2="SecondCicleTop";     // Line name
 string          InpNameT3="ThirdCicleTop";     // Line name
 string          InpNameT4="FourthCicleTop";     // Line name
 string          InpNameT5="FifthCicleTop";     // Line name
 string          InpNameT8="ControlTop";     // Line name
 string          InpNameT9="Segtop";     // Line name
 string          InpNameT10="SixhCicleTop";     // Line name
 string          InpNameT11="SeventhCicleTop";     // Line name
 string          InpNameT12="Control2Top";     // Line name
 string          InpNameT13="Seg2top";     // Line name

//nombre rectangulos partes bajas
 string          InpNameB="FirstCicleBot";     // Line name
 string          InpNameB2="SecondCicleBot";     // Line name
 string          InpNameB3="ThirdCicleBot";     // Line name
 string          InpNameB4="FourthCicleBot";     // Line name
 string          InpNameB5="FifthCicleBot";     // Line name
 string          InpNameB8="ControlBot";     // Line name
 string          InpNameB9="Segbot";     // Line name
 string          InpNameB10="SixCicleBot";     // Line name
 string          InpNameB11="SeventhCicleBot";     // Line name
 string          InpNameB12="Control2Bot";     // Line name
 string          InpNameB13="Seg2bot";     // Line name

//lineas 38
 string          InpName38="FirstCicle38";     // Line name
 string          InpName382="SecondCicle38";     // Line name
 string          InpName383="ThirdCicle38";     // Line name
 string          InpName384="FourthCicle38";     // Line name
 string          InpName385="FifthCicle38";     // Line name
 string          InpName386="Alert38";     // Line name
 string          InpName387="Alert382";     // Line name
 string          InpName388="ControlAlert38";     // Line name
 string          InpName389="SegAlert38";     // Line name
 string          InpName3810="SixthCicle38";     // Line name
 string          InpName3811="SeventhCicle38";     // Line name
 string          InpName3812="Control2Alert38";     // Line name
 string          InpName3813="Seg2Alert38";     // Line name

//inicios de ciclo
 string          InpNameInit="FirstCicleInit";     // Line name
 string          InpNameInit2="SecondCicleInit";     // Line name
 string          InpNameInit3="ThirdCicleInit";     // Line name
 string          InpNameInit4="FourthCicleInit";     // Line name
 string          InpNameInit5="FifthCicleInit";     // Line name
 string          InpNameInit6="AlertInit";     // Line name
 string          InpNameInit7="AlertInit2";     // Line name
 string          InpNameInit8="ControlPInit";     // Line name
 string          InpNameInit9="SegInit";     // Line name
 string          InpNameInit10="SixthCicleInit";     // Line name
 string          InpNameInit11="SeventhCicleInit";     // Line name
 string          InpNameInit12="Control2PInit";     // Line name
 string          InpNameInit13="Seg2Init";     // Line name

 string          InpNamefibo="FirstCiclefibo";     // Line name
 string          InpNamefibo2="SecondCiclefibo";     // Line name
 string          InpNamefibo3="ThirdCiclefibo";     // Line name
 string          InpNamefibo4="FourthCiclefibo";     // Line name
 string          InpNamefibo5="FifthCiclefibo";     // Line name
 string          InpNamefibo6="Alertfibo";     // Line name
 string          InpNamefibo7="Alert2fibo";     // Line name
 string          InpNamefibo8="Controlfibo";     // Line name
 string          InpNamefibo9="Seguimientofibo";     // Line name
 string          InpNamefibo10="SixthCiclefibo";     // Line name
 string          InpNamefibo11="SeventhCiclefibo";     // Line name
 string          InpNamefibo12="Control2fibo";     // Line name
 string          InpNamefibo13="Seguimiento2fibo";     // Line name

 int             InpPrice=25;         // Line price, %
 color           InpColor=clrTomato;     // Line color
 color           InpColor2=clrDodgerBlue;     // Line color
 color           InpColor3=clrSienna;     // Line color
 color           InpColor4=clrOrchid;     // Line color
 color           InpColor5=clrLightGoldenrod;     // Line color
 color           InpColor6=clrLawnGreen;     // Line color
 color           InpColor7=clrSpringGreen;     // Line color
 color           InpColor8=clrMediumTurquoise;     // Line color
 color           InpColor9=clrMediumSeaGreen;     // Line color
 color           InpColor10=clrBlack;     // Line color
 color           InpColor11=clrGold;     // Line color
 color           InpColor12=clrMoccasin;     // Line color
 ENUM_LINE_STYLE InpStyle=STYLE_SOLID; // Line style
 ENUM_LINE_STYLE InpStyle2=STYLE_DOT; // Line style
 int             InpWidth=2;          // Line width
 bool            InpBack=false;       // Background line
 bool            InpSelection=true;   // Highlight to move
 bool            InpHidden=true;      // Hidden in the object list
 long            InpZOrder=0;         // Priority for mouse click

//---  parameters of the script
 string          VInpName="VLine";     // Line name
 string          VInpName2="VLine2";     // Line name
 int             VInpDate=25;          // Event date, %
 int             VInpDate2=25;          // Event date, %
 color           VInpColor=clrRed;     // Line color
 color           VInpColor2=clrGreen;     // Line color
 ENUM_LINE_STYLE VInpStyle=STYLE_DASH; // Line style
 int             VInpWidth=1;          // Line width
 bool            VInpBack=false;       // Background line
 bool            VInpSelection=true;   // Highlight to move
 bool            VInpHidden=true;      // Hidden in the object list
 long            VInpZOrder=0;         // Priority for mouse click

//rectangulos

//---  parameters of the script
 string          RInpName="Rectangle"; // Rectangle name
 int             RInpDate1=40;         // 1 st point's date, %
 int             RInpPrice1=40;        // 1 st point's price, %
 int             RInpDate2=60;         // 2 nd point's date, %
 int             RInpPrice2=60;        // 2 nd point's price, %
 color           RInpColor=clrRed;     // Rectangle color
 ENUM_LINE_STYLE RInpStyle=STYLE_DASH; // Style of rectangle lines
 int             RInpWidth=1;          // Width of rectangle lines
 bool            RInpFill=true;        // Filling the rectangle with color
 bool            RInpBack=false;       // Background rectangle
 bool            RInpSelection=true;   // Highlight to move
 bool            RInpHidden=false;      // Hidden in the object list
 long            RInpZOrder=0;         // Priority for mouse click

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

//+------------------------------------------------------------------+
//| Create rectangle by the given coordinates                        |
//+------------------------------------------------------------------+
bool RectangleCreate(const long            chart_ID=0,        // chart's ID
                     const string          name="Rectangle",  // rectangle name
                     const int             sub_window=0,      // subwindow index 
                     datetime              time1=0,           // first point time
                     double                price1=0,          // first point price
                     datetime              time2=0,           // second point time
                     double                price2=0,          // second point price
                     const color           clr=clrRed,        // rectangle color
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // style of rectangle lines
                     const int             width=1,           // width of rectangle lines
                     const bool            fill=false,        // filling rectangle with color
                     const bool            back=false,        // in the background
                     const bool            selection=true,    // highlight to move
                     const bool            hidden=true,       // hidden in the object list
                     const long            z_order=0)         // priority for mouse click
  {
//--- set anchor points' coordinates if they are not set
   ChangeRectangleEmptyPoints(time1,price1,time2,price2);
//--- reset the error value
   ResetLastError();
//--- create a rectangle by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_RECTANGLE,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create a rectangle! Error code = ",GetLastError());
      return(false);
     }
//--- set rectangle color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set the style of rectangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set width of the rectangle lines
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- enable (true) or disable (false) the mode of filling the rectangle
   ObjectSetInteger(chart_ID,name,OBJPROP_FILL,fill);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of highlighting the rectangle for moving
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,false);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move the rectangle anchor point                                  |
//+------------------------------------------------------------------+
bool RectanglePointChange(const long   chart_ID=0,       // chart's ID
                          const string name="Rectangle", // rectangle name
                          const int    point_index=0,    // anchor point index
                          datetime     time=0,           // anchor point time coordinate
                          double       price=0)          // anchor point price coordinate
  {
//--- if point position is not set, move it to the current bar having Bid price
   if(!time)
      time=TimeCurrent();
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value
   ResetLastError();
//--- move the anchor point
   if(!ObjectMove(chart_ID,name,point_index,time,price))
     {
      Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete the rectangle                                             |
//+------------------------------------------------------------------+
bool RectangleDelete(const long   chart_ID=0,       // chart's ID
                     const string name="Rectangle") // rectangle name
  {
//--- reset the error value
   ResetLastError();
//--- delete rectangle
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete rectangle! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Check the values of rectangle's anchor points and set default    |
//| values for empty ones                                            |
//+------------------------------------------------------------------+
void ChangeRectangleEmptyPoints(datetime &time1,double &price1,
                                datetime &time2,double &price2)
  {
//--- if the first point's time is not set, it will be on the current bar
   if(!time1)
      time1=TimeCurrent();
//--- if the first point's price is not set, it will have Bid value
   if(!price1)
      price1=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the second point's time is not set, it is located 9 bars left from the second one
   if(!time2)
     {
      //--- array for receiving the open time of the last 10 bars
      datetime temp[10];
      CopyTime(Symbol(),Period(),time1,10,temp);
      //--- set the second point 9 bars left from the first one
      time2=temp[0];
     }
//--- if the second point's price is not set, move it 300 points lower than the first one
   if(!price2)
      price2=price1-300*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
  }
   int Font_Size           = 10;         // Font Size
 string Font_Face        = "Impact"; 

//para dibujar fibonacci

//+------------------------------------------------------------------+
//| Create Fibonacci Retracement by the given coordinates            |
//+------------------------------------------------------------------+
bool FiboLevelsCreate(const long            chart_ID=0,        // chart's ID
                      const string          name="FiboLevels", // object name
                      const int             sub_window=0,      // subwindow index 
                      datetime              time1=0,           // first point time
                      double                price1=0,          // first point price
                      datetime              time2=0,           // second point time
                      double                price2=0,          // second point price
                      const color           clr=clrRed,        // object color
                      const ENUM_LINE_STYLE style=STYLE_SOLID, // object line style
                      const int             width=1,           // object line width
                      const bool            back=false,        // in the background
                      const bool            selection=true,    // highlight to move
                      const bool            ray_right=false,   // object's continuation to the right
                      const bool            hidden=true,       // hidden in the object list
                      const long            z_order=0)         // priority for mouse click
  {
//--- set anchor points' coordinates if they are not set
   ChangeFiboLevelsEmptyPoints(time1,price1,time2,price2);
//--- reset the error value
   ResetLastError();
//--- Create Fibonacci Retracement by the given coordinates
   if(!ObjectCreate(chart_ID,name,OBJ_FIBO,sub_window,time1,price1,time2,price2))
     {
      Print(__FUNCTION__,
            ": failed to create \"Fibonacci Retracement\"! Error code = ",GetLastError());
      return(false);
     }
//--- set color
   ObjectSetInteger(chart_ID,name,OBJPROP_COLOR,clr);
//--- set line style
   ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
//--- set line width
   ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
//--- display in the foreground (false) or background (true)
   ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
//--- enable (true) or disable (false) the mode of highlighting the channel for moving
//--- when creating a graphical object using ObjectCreate function, the object cannot be
//--- highlighted and moved by default. Inside this method, selection parameter
//--- is true by default making it possible to highlight and move the object
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTABLE,selection);
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selection);
//--- enable (true) or disable (false) the mode of continuation of the object's display to the right
   ObjectSetInteger(chart_ID,name,OBJPROP_RAY_RIGHT,ray_right);
//--- hide (true) or display (false) graphical object name in the object list
   ObjectSetInteger(chart_ID,name,OBJPROP_HIDDEN,hidden);
//--- set the priority for receiving the event of a mouse click in the chart
   ObjectSetInteger(chart_ID,name,OBJPROP_ZORDER,z_order);
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Set number of levels and their parameters                        |
//+------------------------------------------------------------------+
bool FiboLevelsSet(int             levels,            // number of level lines
                   double          &values[],         // values of level lines
                   color           &colors[],         // color of level lines
                   ENUM_LINE_STYLE &styles[],         // style of level lines
                   int             &widths[],         // width of level lines
                   const long      chart_ID=0,        // chart's ID
                   const string    name="FiboLevels") // object name
  {
//--- check array sizes
   if(levels!=ArraySize(colors) || levels!=ArraySize(styles) ||
      levels!=ArraySize(widths) || levels!=ArraySize(widths))
     {
      Print(__FUNCTION__,": array length does not correspond to the number of levels, error!");
      return(false);
     }
//--- set the number of levels
   ObjectSetInteger(chart_ID,name,OBJPROP_LEVELS,levels);
//--- set the properties of levels in the loop
   for(int i=0;i<levels;i++)
     {
      //--- level value
      ObjectSetDouble(chart_ID,name,OBJPROP_LEVELVALUE,i,values[i]);
      //--- level color
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELCOLOR,i,colors[i]);
      //--- level style
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELSTYLE,i,styles[i]);
      //--- level width
      ObjectSetInteger(chart_ID,name,OBJPROP_LEVELWIDTH,i,widths[i]);
      //--- level description
      ObjectSetString(chart_ID,name,OBJPROP_LEVELTEXT,i,DoubleToString(100*values[i],1));
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Move Fibonacci Retracement anchor point                          |
//+------------------------------------------------------------------+
bool FiboLevelsPointChange(const long   chart_ID=0,        // chart's ID
                           const string name="FiboLevels", // object name
                           const int    point_index=0,     // anchor point index
                           datetime     time=0,            // anchor point time coordinate
                           double       price=0)           // anchor point price coordinate
  {
//--- if point position is not set, move it to the current bar having Bid price
   if(!time)
      time=TimeCurrent();
   if(!price)
      price=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- reset the error value
   ResetLastError();
//--- move the anchor point
   if(!ObjectMove(chart_ID,name,point_index,time,price))
     {
      Print(__FUNCTION__,
            ": failed to move the anchor point! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Delete Fibonacci Retracement                                     |
//+------------------------------------------------------------------+
bool FiboLevelsDelete(const long   chart_ID=0,        // chart's ID
                      const string name="FiboLevels") // object name
  {
//--- reset the error value
   ResetLastError();
//--- delete the object
   if(!ObjectDelete(chart_ID,name))
     {
      Print(__FUNCTION__,
            ": failed to delete \"Fibonacci Retracement\"! Error code = ",GetLastError());
      return(false);
     }
//--- successful execution
   return(true);
  }
//+------------------------------------------------------------------+
//| Check the values of Fibonacci Retracement anchor points and set  |
//| default values for empty ones                                    |
//+------------------------------------------------------------------+
void ChangeFiboLevelsEmptyPoints(datetime &time1,double &price1,
                                 datetime &time2,double &price2)
  {
//--- if the second point's time is not set, it will be on the current bar
   if(!time2)
      time2=TimeCurrent();
//--- if the second point's price is not set, it will have Bid value
   if(!price2)
      price2=SymbolInfoDouble(Symbol(),SYMBOL_BID);
//--- if the first point's time is not set, it is located 9 bars left from the second one
   if(!time1)
     {
      //--- array for receiving the open time of the last 10 bars
      datetime temp[10];
      CopyTime(Symbol(),Period(),time2,10,temp);
      //--- set the first point 9 bars left from the second one
      time1=temp[0];
     }
//--- if the first point's price is not set, move it 200 points below the second one
   if(!price1)
      price1=price2-200*SymbolInfoDouble(Symbol(),SYMBOL_POINT);
  }

// definicion de variables 
int shiftvl,shiftv2,minshift,maxshift,fibo38shift,ciclenumberclicked,zoneclicked, timetoadd;
double value22,value23,fibo38,fibo61,fibo809,boxheight,HIGH,LOW,fibocalc,initxvalue, inityvalue;
datetime fibo38date,endrectangledate,value222,value223,initstart,initend;
//arreglo para guardar los indices y valores para fibonacci
 int creationTime,lastRectangleNum, minshifhts[14],maxshifhts[14], ciclealert[14]; //el indice de ciclealert tiene el numero de ciclo segun botonera, luego su valor indica la zona a verificar donde 0= no hay zona, 1= 61 , 2 = top, 3 = bot;
 datetime values222[14], values223[14];        
double extremos61,extremosalta,extremosbaja, finalcicloalto, finalciclobajo, valuelinealert, zonealert[14],preval;
 string strMyObjectName,strMyObjectName1, strMyObjectText,lastRectangleName;
 bool controlreingreso[14];
 bool hideButtonsGlobal = false, colorSwitch;

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
int OnInit()
  { 
int i;

//blanqueo variables al inicio del EA
     for (i=1;i<14;i++)
  { controlreingreso[i] = false;
    ciclealert[i] = 0;
  }
    zoneclicked = 0;
    strMyObjectName = "Milito Vega Draw";
    preval = 0;
    
    lastRectangleNum = 0;
    lastRectangleName = "";
    creationTime = 0;
    colorSwitch = false;


   // Create text object with given name

   ObjectCreate(strMyObjectName, OBJ_LABEL, 0, 0, 0, 0);

   // Set pixel co-ordinates from top left corner (use OBJPROP_CORNER to set a different corner)

   ObjectSet(strMyObjectName, OBJPROP_XDISTANCE, 25);
   ObjectSet(strMyObjectName, OBJPROP_YDISTANCE, 140);
   ObjectSetText(strMyObjectName, "", 8, "Arial Black", Red);
     
int x=20;

CreateButton("button1"," + ",70,20,30,30,White,InpColor,White,10);
CreateButton("button2"," + ",110,20,30,30,White,InpColor2,White,10);
CreateButton("button3"," + ",150,20,30,30,White,InpColor3,White,10);
CreateButton("button4"," + ",190,20,30,30,White,InpColor4,White,10);
CreateButton("button5"," + ",230,20,30,30,Black,InpColor5,White,10);
CreateButton("button19"," + ",270,20,30,30,Black,InpColor11,White,10);
CreateButton("button20"," + ",310,20,30,30,Black,InpColor12,White,10);
CreateButton("button6"," + ",350,20,30,30,White,InpColor6,White,10);
CreateButton("button7"," + ",390,20,30,30,White,InpColor7,White,10);
CreateButton("button8"," + ",430,20,30,30,White,InpColor8,White,10);
CreateButton("button27"," + ",470,20,30,30,White,InpColor8,White,10);
CreateButton("button9"," + ",510,20,30,30,White,InpColor9,White,10);
CreateButton("button28"," + ",550,20,30,30,White,InpColor9,White,10);
CreateButton("button11","FULL",20,60,50,30,White,Gray,White,10);
CreateButton("button12","61",75,60,50,30,White,Gray,White,10);
CreateButton("button13","TOP",130,60,50,30,White,Gray,White,10);
CreateButton("button14","BOT",185,60,50,30,White,Gray,White,10);
CreateButton("button15","DEL",240,60,50,30,White,Gray,White,10);
CreateButton("button16","ZONE AL",295,60,70,30,White,Gray,White,10);
CreateButton("button35","ZONE CUR",370,60,70,30,White,Gray,White,10);
CreateButton("button33","AL CLEAR",445,60,70,30,White,Gray,White,10);
CreateButton("button18","FIBO",640,60,50,30,White,Gray,White,10);
CreateButton("button32","CLEAR ALL",555,60,80,30,White,Gray,White,10);
CreateButton("button17","OK",520,60,30,30,White,Gray,White,10);
//CreateButton("button21"," 61 ",20,100,50,30,White,Black,White,10);
//CreateButton("button22"," Top ",75,100,50,30,White,Black,White,10);
//CreateButton("button23"," Bot ",130,100,50,30,White,Black,White,10);
//CreateButton("button24"," ALERT ",185,100,60,30,White,Gray,White,10);
//CreateButton("button31"," CURRENT ",250,100,75,30,White,Gray,White,10);
//CreateButton("button25"," CLEAR ",330,100,60,30,White,Gray,White,10);
CreateButton("button26","Hide",20,20,40,30,White,Gray,White,10);
CreateButton("button30","SHOW LOGS",160,100,90,30,White,Gray,White,10);
CreateButton("button29"," CLOSE EA ",255,100,85,30,White,Gray,White,10);
CreateButton("button34"," CANCEL ",345,100,85,30,White,Gray,White,10);
CreateButton("button36"," - ",435,100,25,30,Black,Pink,White,10);
CreateButton("button37"," - ",465,100,25,30,Black,Linen,White,10);
CreateButton("button38"," - ",495,100,25,30,White,Black,White,10);
CreateButton("button39"," - ",525,100,25,30,White,Gray,White,10);
CreateButton("button41"," - ",555,100,25,30,White,InpColor8,White,10);
CreateButton("button42"," - ",585,100,25,30,White,InpColor9,White,10);
CreateButton("button40"," Color Sw ",615,100,55,30,White,Gray,White,10);

//verifico que los botones sigan ocultos en caso de haberlo activado
if (hideButtonsGlobal) {
hideButtons();
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
   ObjectDelete(strMyObjectName);
   Comment("");
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
  { int i; double valor_extremo61, valor_extremoalta, valor_extremobaja;
  string notification;
  //control de alertas por ciclo 
  //primero recorro los ciclos los distintos de 0 tienen alertas 1= 61, 2= top, 3= bottom
  
  for (i=1;i<14;i++)
  { 
    if(ciclealert[i] != 0)  // 1= 61, 2 = Top, 3 = Bot , 0 = None;
    {
     if (ciclealert[i] == 1) //61
      {
      //obtengo el valor del extremo correspondiente
      valor_extremo61 = Get_extremo(i,1);
       if (showlogs)
         Print (" (61) / i / controlreingreso / dir ciclo / extremo /  limite 61 " + i + " / "+  controlreingreso[i] + " / " + Get_cicledir(i) + " / " + valor_extremo61 + " / " +  Get_limitezona(i,2,1) + " / " + Get_limitezona(i,1,1) );
       if (  ((!controlreingreso[i]) && ((Get_cicledir(i) == 1) && ((iClose(NULL,0,0) < valor_extremo61 )))    ) || ((!controlreingreso[i]) && ((Get_cicledir(i) == -1) && ((iClose(NULL,0,0) > valor_extremo61)))    )) //si es ciclo alcista y esta por debajo (o bajista y por encima) de extremo ya puedo controlar el reingreso a zona
       {
       controlreingreso[i] = true;
        //if (showlogs)
         
         Print ("El precio cruzó la linea de extremo de zona 61: " + _Symbol);
       }
       
       if ((controlreingreso[i]) && (   ((Get_cicledir(i) == 1) && ( iClose(NULL,0,0) > Get_limitezona(i,3,1)) ) || (((Get_cicledir(i) == -1) && ( iClose(NULL,0,0) < Get_limitezona(i,2,1))))   ))//ahora controlo que entre nuevamente a la zona y que no se anule tocando la zona siguiente 
       {
         if ( (   ((Get_cicledir(i) == 1) && (iClose(NULL,0,0) > Get_limitezona(i,1,-1)) )) ||  (((Get_cicledir(i) == -1) && (iClose(NULL,0,0) < Get_limitezona(i,1,-1)) ))   ) //si es ciclo alcista (o bajista )y se mete en zona entonces si larga el alerta
         { notification = "Extremo confirmado en: " + _Symbol;
         sendnotifications (notification);
            ciclealert[i] = 0;
            controlreingreso[i] = false;
         }      
       }
       else if (controlreingreso[i])
       {
         notification = "Alarma de extremo anulada por anulacion de zona 61: " + _Symbol;
         sendnotifications (notification);
           ciclealert[i] = 0;
            controlreingreso[i] = false;
       }
      }
      
      //--- parte alta
      
           if (ciclealert[i] == 2) //TOP
      {
      //obtengo el valor del extremo correspondiente
      valor_extremoalta = Get_extremo(i,2);
       if (showlogs)
         Print ("(top) i / controlreingreso / dir ciclo / extremo / fin ciclo / limite alta " + i + " / " +  controlreingreso[i] + " / " + Get_cicledir(i) + " / " + valor_extremoalta + " / " + Get_finciclo(i,1) + " / "+ Get_limitezona(i,2,-1)  );
       if (  ((!controlreingreso[i]) && ((Get_cicledir(i) == 1) && ((iClose(NULL,0,0) > valor_extremoalta )))    ) || ((!controlreingreso[i]) && ((Get_cicledir(i) == -1) && ((iClose(NULL,0,0) > valor_extremoalta)))    )) //si es ciclo alcista  o bajista y cruza por encima el extremo de parte alta ya puedo controlar el reingreso a zona
       {
       controlreingreso[i] = true;
        //if (showlogs)
         Print ("El precio cruzó la linea de extremo de parte alta: " + _Symbol);
       }
       
       if ((controlreingreso[i]) && ( iClose(NULL,0,0) < Get_finciclo(i,1)) )//ahora controlo que entre nuevamente a la zona y que no se anule tocando la zona siguiente 
       {
         if ( (  (iClose(NULL,0,0) < Get_limitezona(i,2,-1)) )) //si es ciclo alcista (o bajista )y se mete en zona entonces si larga el alerta
         {
 
         notification = "Extremo confirmado (parte alta) en: " + _Symbol;
          sendnotifications (notification);
         
                 ciclealert[i] = 0;
            controlreingreso[i] = false;
         }      
       }
       else if (controlreingreso[i])
       {
         notification = "Alarma de extremo anulada por anulacion de zona (parte alta): "+ _Symbol;
          sendnotifications (notification);
            ciclealert[i] = 0;
            controlreingreso[i] = false;
       }
      }
      //---- fin parte alta
      
            //--- parte baja
      
           if (ciclealert[i] == 3) //BOT
      {
      //obtengo el valor del extremo correspondiente
      valor_extremobaja = Get_extremo(i,3);
       if (showlogs)
         Print (" (bot) i / controlreingreso / dir ciclo / extremo / fin ciclo / limite parte baja " + i + " / " +  controlreingreso[i] + " / " + Get_cicledir(i) + " / " + valor_extremobaja + " / " +  Get_finciclo(i,-1) + " / " + Get_limitezona(i,3,-1)  );
       if (  ((!controlreingreso[i]) && ((Get_cicledir(i) == 1) && ((iClose(NULL,0,0) < valor_extremobaja )))    ) || ((!controlreingreso[i]) && ((Get_cicledir(i) == -1) && ((iClose(NULL,0,0) < valor_extremobaja)))    )) //si es ciclo alcista  o bajista y cruza por encima el extremo de parte alta ya puedo controlar el reingreso a zona
       {
       controlreingreso[i] = true;
        //if (showlogs)
         Print ("El precio cruzó la linea de extremo de parte baja: " + _Symbol);
       }
       
       if ((controlreingreso[i]) && ( iClose(NULL,0,0) > Get_finciclo(i,-1)) )//ahora controlo que entre nuevamente a la zona y que no se anule tocando la zona siguiente 
       {
         if ( (    (iClose(NULL,0,0) > Get_limitezona(i,3,-1)) )) //si es ciclo alcista (o bajista )y se mete en zona entonces si larga el alerta
         {
         notification = "Extremo confirmado (parte baja) en: " + _Symbol;
        sendnotifications (notification);
          
           ciclealert[i] = 0;
            controlreingreso[i] = false;
         }      
       }
       else if (controlreingreso[i])
       {
         notification = "Alarma de extremo anulada por anulacion de zona (parte baja): "+ _Symbol;
        sendnotifications (notification);
      
           ciclealert[i] = 0;
            controlreingreso[i] = false;
       }
      }
      
      //---- fin parte baja
      
    }
   
  }
  
  //--- control de alertas por zonas degox
    for (i=1;i<14;i++)
  { 
    if(zonealert[i] != 0)  // 0 = None  0 <> price = alerta;
    {
      if ((( preval < zonealert[i]) && ( iClose(NULL,0,0) > zonealert[i])) || (( preval > zonealert[i]) && ( iClose(NULL,0,0) < zonealert[i])) ) 
      {  //el precio cruzo el alerta envio notificaciones
          notification = "El precio cruzó el alerta en el valor: " + zonealert[i] + " para el ciclo: " + nameofcicle(i)+ " en: " + _Symbol;
         sendnotifications (notification);
         //blanqueo
          zonealert[i] = 0;
      
      }
      
    }
  }
  preval = iClose(NULL,0,0);
  
    }//end ontick
//+------------------------------------------------------------------+
//start = operacion 0=sell 1=buy , halflot = selfexplanatory , auto = 1 (por boton) = 0 por tick

 // GESTION DE BOTONES

void CreateButton(string btnName,string btnText,int x,int y,int w,int h,color clrText,color clrBg,color clrBorder,int fontSize)
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

  }
  void HideButton(string btnName)
  {
  ObjectSetInteger(0,btnName,OBJPROP_TIMEFRAMES,OBJ_NO_PERIODS);
  }
    void ShowButton(string btnName)
  {
  ObjectSetInteger(0,btnName,OBJPROP_TIMEFRAMES,OBJ_ALL_PERIODS);
  }
void DeleteButtons()
  {
   for(int i=ObjectsTotal()-1; i>-1; i--)
     {
      if(StringFind(ObjectName(i),"button")>=0) ObjectDelete(ObjectName(i));
     }
  }
  
  void DeleteCicle(int number)
  { string initname, name61, name38, topname, bottomname, lowcoordinitname,highcoordinitname, extremo61name, extremoaltaname, extramobajaname,finciclobaja,fincicloalta;
  //seteo color del ciclo
  //Print ( " se borrara el ciclo numero: " + number);
    switch (number)
                  { 
                  case 1: { initname = InpNameInit; name38 = InpName38; name61 = InpName; topname = InpNameT; bottomname = InpNameB; lowcoordinitname =InpNamecoordlow; highcoordinitname=InpNamecoordhigh;extremo61name=InpNameextremo611; extremoaltaname=InpNamealta1; extramobajaname=InpNamebaja1 ;finciclobaja=InpNamefinbaja1; fincicloalta=InpNamefinalta1 ; break;}
                  case 2: { initname = InpNameInit2; name38 = InpName382; name61 = InpName2; topname = InpNameT2;  bottomname = InpNameB2;lowcoordinitname =InpNamecoordlow2; highcoordinitname=InpNamecoordhigh2; extremo61name=InpNameextremo612; extremoaltaname=InpNamealta2; extramobajaname=InpNamebaja2 ;finciclobaja=InpNamefinbaja2; fincicloalta=InpNamefinalta2 ;break;}  
                  case 3: { initname = InpNameInit3; name38 = InpName383; name61 = InpName3; topname = InpNameT3;  bottomname = InpNameB3;lowcoordinitname =InpNamecoordlow3; highcoordinitname=InpNamecoordhigh3;extremo61name=InpNameextremo613; extremoaltaname=InpNamealta3; extramobajaname=InpNamebaja3 ;finciclobaja=InpNamefinbaja3; fincicloalta=InpNamefinalta3 ;break;} 
                  case 4: { initname = InpNameInit4; name38 = InpName384; name61 = InpName4; topname = InpNameT4;  bottomname = InpNameB4;lowcoordinitname =InpNamecoordlow4; highcoordinitname=InpNamecoordhigh4;extremo61name=InpNameextremo614; extremoaltaname=InpNamealta4; extramobajaname=InpNamebaja4 ;finciclobaja=InpNamefinbaja4; fincicloalta=InpNamefinalta4 ;break;} 
                  case 5: { initname = InpNameInit5; name38 = InpName385; name61 = InpName5; topname = InpNameT5;  bottomname = InpNameB5;lowcoordinitname =InpNamecoordlow5; highcoordinitname=InpNamecoordhigh5;extremo61name=InpNameextremo615; extremoaltaname=InpNamealta5; extramobajaname=InpNamebaja5 ;finciclobaja=InpNamefinbaja5; fincicloalta=InpNamefinalta5 ;break;} 
                  case 6: { initname = InpNameInit6; name38 = InpName386; name61 = InpName6;lowcoordinitname =InpNamecoordlow6; highcoordinitname=InpNamecoordhigh6;break;} 
                  case 7: { initname = InpNameInit7; name38 = InpName387; name61 = InpName7; lowcoordinitname =InpNamecoordlow7; highcoordinitname=InpNamecoordhigh7;break;} 
                  case 8: { initname = InpNameInit8; name38 = InpName388; name61 = InpName8; topname = InpNameT8;  bottomname = InpNameB8;lowcoordinitname =InpNamecoordlow8; highcoordinitname=InpNamecoordhigh8;extremo61name=InpNameextremo618; extremoaltaname=InpNamealta8; extramobajaname=InpNamebaja8 ;finciclobaja=InpNamefinbaja8; fincicloalta=InpNamefinalta8 ;break;} 
                  case 9: { initname = InpNameInit9; name38 = InpName389; name61 = InpName9; topname = InpNameT9;  bottomname = InpNameB9;lowcoordinitname =InpNamecoordlow9; highcoordinitname=InpNamecoordhigh9;extremo61name=InpNameextremo619; extremoaltaname=InpNamealta9; extramobajaname=InpNamebaja9 ;finciclobaja=InpNamefinbaja9; fincicloalta=InpNamefinalta9 ;break;} 
                  case 10: { initname = InpNameInit10; name38 = InpName3810; name61 = InpName10; topname = InpNameT10;  bottomname = InpNameB10; lowcoordinitname =InpNamecoordlow10; highcoordinitname=InpNamecoordhigh10;extremo61name=InpNameextremo6110; extremoaltaname=InpNamealta10; extramobajaname=InpNamebaja10;finciclobaja=InpNamefinbaja10; fincicloalta=InpNamefinalta10 ;break;} 
                  case 11: { initname = InpNameInit11; name38 = InpName3811; name61 = InpName11; topname = InpNameT11;  bottomname = InpNameB11; lowcoordinitname =InpNamecoordlow11; highcoordinitname=InpNamecoordhigh11;extremo61name=InpNameextremo6111; extremoaltaname=InpNamealta11; extramobajaname=InpNamebaja11;finciclobaja=InpNamefinbaja11; fincicloalta=InpNamefinalta11 ;break;} 
                  case 12: { initname = InpNameInit12; name38 = InpName3812; name61 = InpName12; topname = InpNameT12;  bottomname = InpNameB12; lowcoordinitname =InpNamecoordlow12; highcoordinitname=InpNamecoordhigh12;extremo61name=InpNameextremo6112; extremoaltaname=InpNamealta12; extramobajaname=InpNamebaja12;finciclobaja=InpNamefinbaja12; fincicloalta=InpNamefinalta12;break;} 
                  case 13: { initname = InpNameInit13; name38 = InpName3813; name61 = InpName13; topname = InpNameT13;  bottomname = InpNameB13; lowcoordinitname =InpNamecoordlow13; highcoordinitname=InpNamecoordhigh13;extremo61name=InpNameextremo6113; extremoaltaname=InpNamealta13; extramobajaname=InpNamebaja13;finciclobaja=InpNamefinbaja13; fincicloalta=InpNamefinalta13;break;} 
                
                  }
                  if(ObjectFind(0,initname) == 0) 
                 RectangleDelete(0,initname);
                   if(ObjectFind(0,name38) == 0) 
                 RectangleDelete(0,name38);
                   if(ObjectFind(0,name61) == 0) 
                 RectangleDelete(0,name61);
                   if(ObjectFind(0,topname) == 0) 
                 RectangleDelete(0,topname);
                   if(ObjectFind(0,bottomname) == 0) 
                 RectangleDelete(0,bottomname);
                   //borro lineas de inicio de ciclo
                   if(ObjectFind(0,VInpName) == 0)
      VLineDelete(0,VInpName);
      if(ObjectFind(0,VInpName2) == 0)
       VLineDelete(0,VInpName2);
       //borro minirectangulos de coordenadas  lowcoordinitname
       if(ObjectFind(0,lowcoordinitname) == 0)
        RectangleDelete(0,lowcoordinitname);
        if(ObjectFind(0,highcoordinitname) == 0)
         RectangleDelete(0,highcoordinitname);
       //borro minirectangulos de marcas de extremos 
               if(ObjectFind(0,extremo61name) == 0)
        RectangleDelete(0,extremo61name);
                if(ObjectFind(0,extremoaltaname) == 0)
         RectangleDelete(0,extremoaltaname);
                 if(ObjectFind(0,extramobajaname) == 0)
          RectangleDelete(0,extramobajaname);  
        //borro minirectangulos de fin de ciclo   
                if(ObjectFind(0,finciclobaja) == 0) 
           RectangleDelete(0,finciclobaja); 
                   if(ObjectFind(0,fincicloalta) == 0)
           RectangleDelete(0,fincicloalta);  
           //linea de alertas no deberia estar a esta altura pero por las dudas   
                 if(ObjectFind(0,InpNameAlert) == 0)
            HLineDelete(0,InpNameAlert); 
            
            //borro alertas    
            ciclealert[number] = 0; 
              zonealert[number]= 0;  
                 }
  
  
  void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam)
  {
             if(sparam=="button1") // Crear ciclo
        {
         ciclenumberclicked = 1;
         Action_Button1();
         ObjectSetInteger(0,"button1",OBJPROP_STATE,false);
        }
                  if(sparam=="button2") // Crear ciclo
        {
         ciclenumberclicked = 2;
         Action_Button1();
         ObjectSetInteger(0,"button2",OBJPROP_STATE,false);
        }
                  if(sparam=="button3") // Crear ciclo
        {
         ciclenumberclicked = 3;
         Action_Button1();
         ObjectSetInteger(0,"button3",OBJPROP_STATE,false);
        }
                  if(sparam=="button4") // Crear ciclo
        {
         ciclenumberclicked = 4;
         Action_Button1();
         ObjectSetInteger(0,"button4",OBJPROP_STATE,false);
        }
                  if(sparam=="button5") // Crear ciclo
        {
         ciclenumberclicked = 5;
         Action_Button1();
         ObjectSetInteger(0,"button5",OBJPROP_STATE,false);
        }
                     if(sparam=="button19") // Crear sexto ciclo
        {
         ciclenumberclicked = 10;
         Action_Button1();
         ObjectSetInteger(0,"button19",OBJPROP_STATE,false);
        }
                     if(sparam=="button20") // Crear septimo ciclo
        {
         ciclenumberclicked = 11;
         Action_Button1();
         ObjectSetInteger(0,"button20",OBJPROP_STATE,false);
        }
        
                        if(sparam=="button6") // Alerta 1
        {
         ciclenumberclicked = 6;
         Action_Button1();
         ObjectSetInteger(0,"button6",OBJPROP_STATE,false);
        }
        
                             if(sparam=="button7") // Alerta 2
        {
         ciclenumberclicked = 7;
         Action_Button1();
         ObjectSetInteger(0,"button7",OBJPROP_STATE,false);
        }
                               if(sparam=="button8") //Pto de control
        {
         ciclenumberclicked = 8;
         Action_Button1();
         ObjectSetInteger(0,"button8",OBJPROP_STATE,false);
        }
                                  if(sparam=="button9") //Seguimiento
        {
         ciclenumberclicked = 9;
         Action_Button1();
         ObjectSetInteger(0,"button9",OBJPROP_STATE,false);
        }
        
                                     if(sparam=="button27") //Pto de control 2
        {
         ciclenumberclicked = 12;
         Action_Button1();
         ObjectSetInteger(0,"button27",OBJPROP_STATE,false);
        }
                                  if(sparam=="button28") //Seguimiento 2
        {
         ciclenumberclicked = 13;
         Action_Button1();
         ObjectSetInteger(0,"button28",OBJPROP_STATE,false);
        }
        
             if(sparam=="button11") // Crear ciclo FULL
        {
     if (ciclenumberclicked != 0)
        {
         Action_Button5(ciclenumberclicked,1,0,0,0);
               }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
         ObjectSetInteger(0,"button11",OBJPROP_STATE,false);
        }
        
              if(sparam=="button12") // Crear ciclo only 61
        {
     if (ciclenumberclicked != 0)
        {
         Action_Button5(ciclenumberclicked,0,1,0,0);
               }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
         ObjectSetInteger(0,"button12",OBJPROP_STATE,false);
        }
          if(sparam=="button13") // Crear cicle top
        {
     if (ciclenumberclicked != 0)
        {
         Action_Button5(ciclenumberclicked,0,0,1,0);
               }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
         ObjectSetInteger(0,"button13",OBJPROP_STATE,false);
        }
  
          if(sparam=="button14") // Crear cicle bottom
        {
     if (ciclenumberclicked != 0)
        {
         Action_Button5(ciclenumberclicked,0,0,0,1);
               }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
         ObjectSetInteger(0,"button14",OBJPROP_STATE,false);
        }
           
        
                  if(sparam=="button15") // Delete
        {
         if (ciclenumberclicked != 0)
        {
         DeleteCicle(ciclenumberclicked);
             }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
         ObjectSetInteger(0,"button15",OBJPROP_STATE,false);
        }
        
                    if(sparam=="button16") // Linea de alerta por ciclo
        { //borro lineas de inicio de ciclo
      VLineDelete(0,VInpName);
       VLineDelete(0,VInpName2);
       if (ciclenumberclicked != 0)
        {Action_Button2();
          ObjectSetText(strMyObjectName, "", 8, "Arial Black", Red);
        }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
        
         ObjectSetInteger(0,"button16",OBJPROP_STATE,false);
        }
        
                           if(sparam=="button17") // Confirmacion linea de alerta por ciclo
        {
       // ObjectSetInteger(0,InpName10,OBJPROP_SELECTED,false);
       if (ciclenumberclicked != 0)
        {
             if (valuelinealert != 0)
        {
        //guardo el alerta
        zonealert[ciclenumberclicked]=valuelinealert;
     
           
            ObjectSetText(strMyObjectName, "Alerta: " + nameofcicle(ciclenumberclicked)  + " seteada correctamente, precio: " + valuelinealert, 8, "Arial Black", Black);
             //blanqueo variable de ciclo
            ciclenumberclicked = 0;
               //blanqueo variable
        valuelinealert=0; 
        //borro linea de alerta
            HLineDelete(0,InpNameAlert);
            }
            else
            {
               ObjectSetText(strMyObjectName, "Error: No hay precio seleccionado para el alerta", 8, "Arial Black", Red);
            }
            
            }
            else
            {
               ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
            }
            
            
         ObjectSetInteger(0,"button17",OBJPROP_STATE,false);
        }
        
                             if(sparam=="button18") // Dibujar fibo para ciclo seleccionado
        {
        
          if (ciclenumberclicked != 0)
        {
         Draw_fibo(ciclenumberclicked,  values222[ciclenumberclicked], minshift, values223[ciclenumberclicked], maxshift);
          }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
        
         ObjectSetInteger(0,"button18",OBJPROP_STATE,false);
        }
        // boton para seleccion de zona, (se clickea luego de elegir un ciclo
        if(sparam=="button21") // Crear ciclo
        {
                       if (ciclenumberclicked != 0)
        {
         zoneclicked = 1; // 1= 61, 2 = Top, 3 = Bot , 0 = None;
          }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
         ObjectSetInteger(0,"button21",OBJPROP_STATE,false);
   
      
            
        }
                if(sparam=="button22") // Crear ciclo
        {
                       if (ciclenumberclicked != 0)
        {
         zoneclicked = 2; // 1= 61, 2 = Top, 3 = Bot , 0 = None;
          }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
         ObjectSetInteger(0,"button22",OBJPROP_STATE,false);
        }
                if(sparam=="button23") // Crear ciclo
        {
                       if (ciclenumberclicked != 0)
        {
         zoneclicked = 3; // 1= 61, 2 = Top, 3 = Bot , 0 = None;
          }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
         ObjectSetInteger(0,"button23",OBJPROP_STATE,false);
        }
        
                if(sparam=="button24") // Setea alerta para zona de un ciclo determinado
        {
            if (ciclenumberclicked != 0)
        {
        
               if (zoneclicked != 0)
        {
      
        
         //borro lineas verticales que se muestran al clickear ciclo
        VLineDelete(0,VInpName);
       VLineDelete(0,VInpName2);
       strMyObjectText = "Se seteo alarma para ciclo: " + nameofcicle(ciclenumberclicked) + " Zona: " + nameofzona(zoneclicked);
       if (iscicleonchart(ciclenumberclicked))
           {  ciclealert[ciclenumberclicked]= zoneclicked; 
           ObjectSetText(strMyObjectName, strMyObjectText , 8, "Arial Black", Black); ciclenumberclicked = 0;}
            else
            ObjectSetText(strMyObjectName, "Error: No se puede setear alerta para el ciclo seleccionado", 8, "Arial Black", Red);
        zoneclicked = 0; //blanqueo por las dudas
        
             }
                else
        ObjectSetText(strMyObjectName, "Error: No hay zona seleccionada", 8, "Arial Black", Red);
             
             }
        else
        ObjectSetText(strMyObjectName, "Error: No hay ciclo seleccionado", 8, "Arial Black", Red);
        
         ObjectSetInteger(0,"button24",OBJPROP_STATE,false);
         
        }
        
                     if(sparam=="button25") // borra alertas seteadas en el bot
        { int i;
             //borro lineas de inicio de ciclo
      VLineDelete(0,VInpName);
       VLineDelete(0,VInpName2);
               int testb13 =   MessageBox("Realmente desea borrar todas las alertas?","Confirmación", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
         if (testb13 == 6)
         {
             for (i=1;i<14;i++)
               {
               ciclealert[i] = 0;
               }
            zoneclicked = 0;
        Print ( "Se blanquearon alertas correctamente");
         ObjectSetText(strMyObjectName, "Se blanquearon alertas correctamente" , 8, "Arial Black", Black);
        }
         ObjectSetInteger(0,"button25",OBJPROP_STATE,false);
        }
        
                             if(sparam=="button33") // borra alertas seteadas por ciclo
        { int q;
             //borro lineas de inicio de ciclo
      VLineDelete(0,VInpName);
       VLineDelete(0,VInpName2);
               int testb14 =   MessageBox("Realmente desea borrar todas las alertas por ciclo?","Confirmación", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
         if (testb14 == 6)
         {
             for (q=1;q<14;q++)
               {
               zonealert[q] = 0;
               }
            zoneclicked = 0;
        Print ( "Se blanquearon alertas por ciclo correctamente");
         ObjectSetText(strMyObjectName, "Se blanquearon alertas por ciclo correctamente" , 8, "Arial Black", Black);
        }
         ObjectSetInteger(0,"button33",OBJPROP_STATE,false);
        }
        
          if(sparam=="button26") // Show / Hide buttons
        {
        if (ObjectGetString(0,"button26",OBJPROP_TEXT) == "Show")
        {
        ObjectSetString(0,"button26",OBJPROP_TEXT,"Hide");
         ShowButton("button1");ShowButton("button2");ShowButton("button3");ShowButton("button4");ShowButton("button5");
         ShowButton("button6");ShowButton("button7");ShowButton("button8");ShowButton("button9");ShowButton("button10");
         ShowButton("button11");ShowButton("button12");ShowButton("button13");ShowButton("button14");ShowButton("button15");
         ShowButton("button16");ShowButton("button17");ShowButton("button18");ShowButton("button19");ShowButton("button20");
         ShowButton("button21");ShowButton("button22");ShowButton("button23");ShowButton("button24");ShowButton("button25");
         ShowButton("button27");ShowButton("button28");ShowButton("button29");ShowButton("button30");ShowButton("button31");
         ShowButton("button32");ShowButton("button33");ShowButton("button34");ShowButton("button35");ShowButton("button36");
         ShowButton("button37");ShowButton("button38");ShowButton("button39");ShowButton("button40");ShowButton("button41");
         ShowButton("button42"); ShowButton("buttonDesbalances"); ShowButton("buttonDesbalances1"); ShowButton("buttonDesbalances2"); ShowButton("buttonDesbalances3");
         hideButtonsGlobal = false;
        }
        else if(ObjectGetString(0,"button26",OBJPROP_TEXT) == "Hide")
         {
         
         ObjectSetString(0,"button26",OBJPROP_TEXT,"Show");
         hideButtons();
         }
         
         ObjectSetInteger(0,"button26",OBJPROP_STATE,false);
        }
        
                             if(sparam=="button29") // Cierre EA
        {
         int testb1 =   MessageBox("Realmente desea cerrar el EA?","Confirmación", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
         if (testb1 == 6)
         {
          ExpertRemove();
         ObjectSetInteger(0,"button29",OBJPROP_STATE,false);
         }
        }
        
                if(sparam=="button30") // Show / Hide buttons
        {
        if (ObjectGetString(0,"button30",OBJPROP_TEXT) == "SHOW LOGS")
        {
        ObjectSetString(0,"button30",OBJPROP_TEXT,"HIDE LOGS");
          showlogs = true;
        }
        else if(ObjectGetString(0,"button30",OBJPROP_TEXT) == "HIDE LOGS")
         {
         
         ObjectSetString(0,"button30",OBJPROP_TEXT,"SHOW LOGS");
           showlogs = false; 
         }
         
         ObjectSetInteger(0,"button30",OBJPROP_STATE,false);
        }
        
             if(sparam=="button31") // muestra alertas vigentes del ea
        { int h,count;
        count =0;
          //borro lineas de inicio de ciclo
      VLineDelete(0,VInpName);
       VLineDelete(0,VInpName2);
      
             for (h=1;h<14;h++)
               {  
               if  (ciclealert[h] != 0)
               {   Print ( "Alerta para ciclo: " + nameofcicle(h) + " zona: " + nameofzona(ciclealert[h]));
               count++;
               }
               }
     
        if (count == 0)
        {Print (" No hay alertas vigentes para: " + _Symbol);
        strMyObjectText = " No hay alertas vigentes para: " + _Symbol; 
        ObjectSetText(strMyObjectName, strMyObjectText , 8, "Arial Black", Black);
        }
        else
           ObjectSetText(strMyObjectName, "Hay: " + count + " alertas seteadas", 8, "Arial Black", Green);
           
         ObjectSetInteger(0,"button31",OBJPROP_STATE,false);
        }
        
         if(sparam=="button32") //borra todos los ciclos del chart
        { int h;
             //borro lineas de inicio de ciclo
      VLineDelete(0,VInpName);
       VLineDelete(0,VInpName2);
       
      int testb12 =   MessageBox("Realmente desea borrar todos los ciclos?","Confirmación", MB_YESNO|MB_ICONQUESTION|MB_TOPMOST);
         if (testb12 == 6)
         {
             for (h=1;h<14;h++)
               {
               if (iscicleonchart(h))
               { DeleteCicle(h);
               }
               }
               //blanqueo label
        ObjectSetText(strMyObjectName, "", 8, "Arial Black", Red);
    
         }
         ObjectSetInteger(0,"button32",OBJPROP_STATE,false);
        }
        
                 if(sparam=="button34") //cancela cualquier accion y blanquea variables intermedias
        { 
            //blanqueo variable de ciclo
            ciclenumberclicked = 0;
            //borro lineas de inicio de ciclo
            VLineDelete(0,VInpName);
            VLineDelete(0,VInpName2);
            //blanqueo variable de alertas por ciclo
            valuelinealert=0;
            //blanqueo variable seleccion de zona 
            zoneclicked = 0;
            //borro linea de alerta
            HLineDelete(0,InpNameAlert);
            //blanqueo label
            ObjectSetText(strMyObjectName, "", 8, "Arial Black", Red);
            ObjectSetInteger(0,"button34",OBJPROP_STATE,false);
        }
        
               if(sparam=="button35") // muestra alertas vigentes por ciclo
        { int f,count2;
        count2 =0;
          //borro lineas de inicio de ciclo
      VLineDelete(0,VInpName);
       VLineDelete(0,VInpName2);
             for (f=1;f<14;f++)
               {
               if (zonealert[f] != 0)
               {   Print ( "Alerta para ciclo: " + nameofcicle(f) + " precio: " + zonealert[f]);
               count2++;
               }
               }
     
        if (count2 == 0)
        {Print (" No hay alertas por ciclo vigentes para: " + _Symbol);
        strMyObjectText = " No hay alertas por ciclo vigentes para: " + _Symbol; 
        ObjectSetText(strMyObjectName, strMyObjectText , 8, "Arial Black", Black);
        }
        else
           ObjectSetText(strMyObjectName, "Hay: " + count2 + " alertas por ciclo seteadas", 8, "Arial Black", Green);
           
         ObjectSetInteger(0,"button35",OBJPROP_STATE,false);
        }
        
        if(sparam=="button36") // muestra alertas vigentes por ciclo
        {
         if (colorSwitch)   
         changeLastRectangleColour(clrPink);
         colorSwitch = false;
         ObjectSetInteger(0,"button36",OBJPROP_STATE,false);
        }
        if(sparam=="button37") // muestra alertas vigentes por ciclo
        {
         if (colorSwitch)   
         changeLastRectangleColour(clrLinen);
         colorSwitch = false;
         ObjectSetInteger(0,"button37",OBJPROP_STATE,false);
        }
        if(sparam=="button38") // muestra alertas vigentes por ciclo
        {
         if (colorSwitch)   
         changeLastRectangleColour(clrBlack);
         colorSwitch = false;
         ObjectSetInteger(0,"button38",OBJPROP_STATE,false);
        }
        if(sparam=="button39") // muestra alertas vigentes por ciclo
        {
         if (colorSwitch)   
         changeLastRectangleColour(clrGray);
         colorSwitch = false;
         ObjectSetInteger(0,"button39",OBJPROP_STATE,false);
        }
        if(sparam=="button41") // muestra alertas vigentes por ciclo
        {
         if (colorSwitch)   
         changeLastRectangleColour(clrTurquoise);
         colorSwitch = false;
         ObjectSetInteger(0,"button39",OBJPROP_STATE,false);
        }
        if(sparam=="button42") // muestra alertas vigentes por ciclo
        {
         if (colorSwitch)   
         changeLastRectangleColour(clrSeaGreen);
         colorSwitch = false;
         ObjectSetInteger(0,"button39",OBJPROP_STATE,false);
        }
        if(sparam=="button40") // habilita cambio de color del ultimo rectangulo
        {   
         colorSwitch = true;
         ObjectSetInteger(0,"button40",OBJPROP_STATE,false);
        }
         if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "VLine")  //valido que sea la linea de parcial
         { 
          value222 = ObjectGet(sparam, OBJPROP_TIME1);
           initstart = ObjectGet(sparam+2, OBJPROP_TIME1);//parametros para dibujar rectangulo de inicio de ciclo
            initend = ObjectGet(sparam+2, OBJPROP_TIME1);
         //ObjectGetTimeByValue(0,sparam,OBJPROP_TIME,0,value222);
         string t_lineav =  TimeToString(ObjectGet(sparam, OBJPROP_TIME1),TIME_DATE|TIME_MINUTES);
          if  (showlogs)
         Print("Linea de min  seteada en: " + t_lineav); 
                        minshift=iBarShift(NULL,0,value222);
                        if  (showlogs)
                          Print("El indice para la barra del ",TimeToStr(value222)," es ",minshift);
        /*if (showlogs)
        Print("El indice para la barra del ",TimeToStr(value222)," es ",minmaxshift);
             minmaxshift = minmaxshift + 1;
                if (showlogs)
              Print("El indice para la barra (calc) del ",TimeToStr(value222)," es ",minmaxshift);
        
        // startlevel = NormalizeDouble(value2,5); 
        */
         }
        }
        
        
               if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "VLine2")  //valido que sea la linea de parcial
         { 
          value223 = ObjectGet(sparam, OBJPROP_TIME1);
         //ObjectGetTimeByValue(0,sparam,OBJPROP_TIME,0,value222);
         string t_lineav2 =  TimeToString(ObjectGet(sparam, OBJPROP_TIME1),TIME_DATE|TIME_MINUTES);
          if  (showlogs)
         Print("Linea de max seteada en: " + t_lineav2); 
                        maxshift=iBarShift(NULL,0,value223);
                        if  (showlogs)
                           Print("El indice para la barra del ",TimeToStr(value223)," es ",maxshift);

         }
         
             //--- capturo informacion de la linea de alertas por ciclo
               if(id==CHARTEVENT_OBJECT_DRAG)
        {
          if (sparam == "LineAlert")  //valido que sea la linea de parcial
         { 
         
            
         ObjectGetDouble(0,sparam,OBJPROP_PRICE,0,valuelinealert);
         //Print("Cierre parcial en ganancia seteado en: " +  NormalizeDouble(value,5)); 
          if  (showlogs)
         Print("Linea de alerta seteada en: " + +  NormalizeDouble(valuelinealert,Digits)); 
         
         
        //  valuelinealert = ObjectGet(sparam, OBJPROP_PRICE1);
         //ObjectGetTimeByValue(0,sparam,OBJPROP_TIME,0,value222);
       //  string t_lineav2 =  TimeToString(ObjectGet(sparam, OBJPROP_TIME1),TIME_DATE|TIME_MINUTES);
         // if  (showlogs)
      //   Print("Linea de alerta seteada en: " + valuelinealert); 
  
         }
        }}
  
  }

void Action_Button1(){
  
   //---  SETEO LINEA MAX MIN
          //--- check correctness of the input parameters
   if(VInpDate<0 || VInpDate>100)
     {
      Print("Error! Incorrect values of input parameters!");
      //return;
     }
//--- number of visible bars in the chart window
   int bars=(int)ChartGetInteger(0,CHART_VISIBLE_BARS);
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
       Print("No se pudo colocar la linea de MIN , revisar ");
     }
      else 
        { 
         ObjectGetDouble(0,VInpName,OBJPROP_PRICE,0,value22);
          if  (showlogs)
         Print("Linea de min/max seteada en: " + value22); 
                 shiftvl=iBarShift(NULL,0,value22);
                 if (showlogs)
        Print("index of the bar for the time ",TimeToStr(value22)," is ",shiftvl);
         
         }
         
         
   int d1=(VInpDate*(bars-1)/100)+30;
  // Print ( " date -time -  d: " + date[d] + " - " + Time[d] + " - " + d );
        if(!VLineCreate(0,VInpName2,0,date[d1],VInpColor2,VInpStyle,VInpWidth,VInpBack,
      VInpSelection,VInpHidden,VInpZOrder))
     {
       Print("No se pudo colocar la linea de MAX , revisar ");
     }
      else 
        { 
         ObjectGetDouble(0,VInpName2,OBJPROP_PRICE,0,value23);
          if  (showlogs)
         Print("Linea de min/max seteada en: " + value23); 
                 shiftv2=iBarShift(NULL,0,value23);
                 if (showlogs)
        Print("index of the bar for the time ",TimeToStr(value23)," is ",shiftv2);
         
         }
          ///--- FIN LINEA MAX MIN
          
          
          
  // PlaySound("ok.wav");
   
}

//coloca la linea para indicar alerta para cada ciclo
void Action_Button2(){
   if(!HLineCreate(0,InpNameAlert,0,Bid-100*Point,InpColor11,InpStyle,2,InpBack,
      InpSelection,InpHidden,InpZOrder,true))
     {
       Print("No se pudo colocar la linea de alerta , revisar ");
     }

  }

void Action_Button5(int ciclenumber,int isfull, int is61, int istop, int isbottom){
color ciclecolour;string initname, name61, name38, topname, bottomname, lowcoordinitname, highcoordinitname,  extremo61name, extremoaltaname, extramobajaname, finciclobaja, fincicloalta;
//indice de max y min
LOW = Low[minshift];  // nivel 0
HIGH = High[maxshift];  //nivel 100

zoneclicked = 0; //blanqueo zona de alerta para evitar errores
if (showlogs)     
Print ( " cicle clicked: " + ciclenumberclicked); 
//blanqueo label de informacion
ObjectSetText(strMyObjectName, "", 8, "Arial Black", Red);
//seteo color del ciclo y nombre de variables
    switch (ciclenumber)
                  { 
                  case 1: { ciclecolour = InpColor; initname = InpNameInit; name38 = InpName38; name61 = InpName; topname = InpNameT; bottomname = InpNameB; lowcoordinitname =InpNamecoordlow; highcoordinitname=InpNamecoordhigh; extremo61name=InpNameextremo611; extremoaltaname=InpNamealta1; extramobajaname=InpNamebaja1; finciclobaja=InpNamefinbaja1; fincicloalta=InpNamefinalta1 ;break;}
                  case 2: { ciclecolour = InpColor2; initname = InpNameInit2; name38 = InpName382; name61 = InpName2; topname = InpNameT2;  bottomname = InpNameB2; lowcoordinitname =InpNamecoordlow2; highcoordinitname=InpNamecoordhigh2; extremo61name=InpNameextremo612; extremoaltaname=InpNamealta2; extramobajaname=InpNamebaja2 ;finciclobaja=InpNamefinbaja2; fincicloalta=InpNamefinalta2 ;break;}  
                  case 3: { ciclecolour = InpColor3; initname = InpNameInit3; name38 = InpName383; name61 = InpName3; topname = InpNameT3;  bottomname = InpNameB3; lowcoordinitname =InpNamecoordlow3; highcoordinitname=InpNamecoordhigh3;extremo61name=InpNameextremo613; extremoaltaname=InpNamealta3; extramobajaname=InpNamebaja3 ;finciclobaja=InpNamefinbaja3; fincicloalta=InpNamefinalta3 ;break;} 
                  case 4: { ciclecolour = InpColor4; initname = InpNameInit4; name38 = InpName384; name61 = InpName4; topname = InpNameT4;  bottomname = InpNameB4; lowcoordinitname =InpNamecoordlow4; highcoordinitname=InpNamecoordhigh4;extremo61name=InpNameextremo614; extremoaltaname=InpNamealta4; extramobajaname=InpNamebaja4 ;finciclobaja=InpNamefinbaja4; fincicloalta=InpNamefinalta4 ;break;} 
                  case 5: { ciclecolour = InpColor5; initname = InpNameInit5; name38 = InpName385; name61 = InpName5; topname = InpNameT5;  bottomname = InpNameB5; lowcoordinitname =InpNamecoordlow5; highcoordinitname=InpNamecoordhigh5;extremo61name=InpNameextremo615; extremoaltaname=InpNamealta5; extramobajaname=InpNamebaja5 ;finciclobaja=InpNamefinbaja5; fincicloalta=InpNamefinalta5 ;break;} 
                  case 6: { ciclecolour = InpColor6; initname = InpNameInit6; name38 = InpName386; name61 = InpName6; lowcoordinitname =InpNamecoordlow6; highcoordinitname=InpNamecoordhigh6;break;} 
                  case 7: { ciclecolour = InpColor7; initname = InpNameInit7; name38 = InpName387; name61 = InpName7; lowcoordinitname =InpNamecoordlow7; highcoordinitname=InpNamecoordhigh7;break;} 
                  case 8: { ciclecolour = InpColor8; initname = InpNameInit8; name38 = InpName388; name61 = InpName8; topname = InpNameT8;  bottomname = InpNameB8; lowcoordinitname =InpNamecoordlow8; highcoordinitname=InpNamecoordhigh8; extremo61name=InpNameextremo618; extremoaltaname=InpNamealta8; extramobajaname=InpNamebaja8;finciclobaja=InpNamefinbaja8; fincicloalta=InpNamefinalta8;break;} 
                  case 9: { ciclecolour = InpColor9; initname = InpNameInit9; name38 = InpName389; name61 = InpName9; topname = InpNameT9;  bottomname = InpNameB9; lowcoordinitname =InpNamecoordlow9; highcoordinitname=InpNamecoordhigh9; extremo61name=InpNameextremo619; extremoaltaname=InpNamealta9; extramobajaname=InpNamebaja9;finciclobaja=InpNamefinbaja9; fincicloalta=InpNamefinalta9;break;} 
                  case 10: { ciclecolour = InpColor11; initname = InpNameInit10; name38 = InpName3810; name61 = InpName10; topname = InpNameT10;  bottomname = InpNameB10; lowcoordinitname =InpNamecoordlow10; highcoordinitname=InpNamecoordhigh10;extremo61name=InpNameextremo6110; extremoaltaname=InpNamealta10; extramobajaname=InpNamebaja10;finciclobaja=InpNamefinbaja10; fincicloalta=InpNamefinalta10;break;} 
                  case 11: { ciclecolour = InpColor12; initname = InpNameInit11; name38 = InpName3811; name61 = InpName11; topname = InpNameT11;  bottomname = InpNameB11; lowcoordinitname =InpNamecoordlow11; highcoordinitname=InpNamecoordhigh11;extremo61name=InpNameextremo6111; extremoaltaname=InpNamealta11; extramobajaname=InpNamebaja11;finciclobaja=InpNamefinbaja11; fincicloalta=InpNamefinalta11;break;} 
                  case 12: { ciclecolour = InpColor8; initname = InpNameInit12; name38 = InpName3812; name61 = InpName12; topname = InpNameT12;  bottomname = InpNameB12; lowcoordinitname =InpNamecoordlow12; highcoordinitname=InpNamecoordhigh12; extremo61name=InpNameextremo6112; extremoaltaname=InpNamealta12; extramobajaname=InpNamebaja12;finciclobaja=InpNamefinbaja12; fincicloalta=InpNamefinalta12;break;} 
                  case 13: { ciclecolour = InpColor9; initname = InpNameInit13; name38 = InpName3813; name61 = InpName13; topname = InpNameT13;  bottomname = InpNameB13; lowcoordinitname =InpNamecoordlow13; highcoordinitname=InpNamecoordhigh13;extremo61name=InpNameextremo6113;  extremoaltaname=InpNamealta13; extramobajaname=InpNamebaja13;finciclobaja=InpNamefinbaja13; fincicloalta=InpNamefinalta13;break;} 
                  
                  }

//Print ( " low , high " + LOW + " - " + HIGH);
               //-- Comienzo de calculos fibo
              fibocalc  =  HIGH-LOW;
              if(fibocalc < 0) fibocalc=fibocalc*(-1);
              fibocalc  =  NormalizeDouble(fibocalc,Digits);
              fibo38shift = 0;
                  if(maxshift < minshift) //UP
                  {
                           fibo38 = HIGH-fibocalc*0.382;
                           fibo61 = HIGH-fibocalc*0.618;
                           fibo809 =HIGH-fibocalc*0.809; 
                           boxheight = fibo61 - fibo809;
                           //dego
                           extremos61 = fibo809 - (boxheight/4);  //calculo el nivel de extremo para usarlo luego
                           extremosalta = HIGH+boxheight + (boxheight/4);  //calculo el nivel de extremo para usarlo luego
                           extremosbaja = LOW-boxheight - (boxheight/4);  //calculo el nivel de extremo para usarlo luego
                       
                           //direccionciclo[ciclenumberclicked] = 1;
                           //limite61[ciclenumberclicked] = fibo809; 
                           
                           finalcicloalto = HIGH + (fibocalc *0.382);
                           finalciclobajo = LOW  - (fibocalc *0.382);
                           
                           if (showlogs)
                               Print ( " fin parte alta baja " + finalcicloalto + " - " + finalciclobajo ); 
                           //busco el shift de la barra que cruza el 38 por primera vez 
                           for (int i=maxshift;i>0;i--)
                             {
                              if (Low[i]< fibo38)
                               {fibo38shift = i;
                                break;
                               }
                               }
                               fibo38date = iTime(NULL,0,fibo38shift);
                               endrectangledate = iTime(NULL,0,0);
                               initxvalue = value222;
                               inityvalue = LOW;
                   }
                   else  //DOWN
                    {
                                  fibo38 = LOW+fibocalc*0.382;
                                  fibo61 = LOW+fibocalc*0.618;
                                   fibo809 =LOW+fibocalc*0.809; 
                                   boxheight = (fibo61 - fibo809)*(-1);
                                   extremos61 = fibo809 + (boxheight/4);;
                                   extremosalta = HIGH+boxheight + (boxheight/4);  //calculo el nivel de extremo para usarlo luego
                                   extremosbaja = LOW-boxheight - (boxheight/4);  //calculo el nivel de extremo para usarlo luego
                                   //direccionciclo[ciclenumberclicked] = -1;
                                   //limite61[ciclenumberclicked] = fibo809; 
                                   
                                       finalcicloalto = HIGH + (fibocalc *0.382);
                                       finalciclobajo = LOW  - (fibocalc *0.382);
                                       if (showlogs)
                               Print ( " fin parte alta baja " + finalcicloalto + " - " + finalciclobajo ); 
                           //busco el shift de la barra que cruza el 38 por primera vez 
                           for ( int i=minshift;i>0;i--)
                             {
                              if (High[i]> fibo38)
                               {fibo38shift = i;
                                break;
                               }
                               }
                               fibo38date = iTime(NULL,0,fibo38shift);
                               endrectangledate = iTime(NULL,0,0);
                               initxvalue = value223;
                               inityvalue = HIGH;
                   //-- fin calculos fibo
                    }

//--- Comienzo dibujo de ciclo

 //Print("index of the bar for the time ",TimeToStr(fibo38date)," is ",fibo61);
 // Print("index of the bar for the time ",TimeToStr(endrectangledate)," is ",fibo809);
  
  
  //---- unidad de tiempo segun timeframe
     timetoadd = 60*Period();  //calculo la cantidad de segundos segun el timeframe que le corresponden a una vela


//guardo valores para poder tirar fibo luego, para esto dibujo rectangulos que almacenan el punto
  minshifhts[ciclenumberclicked]=  minshift; maxshifhts[ciclenumberclicked]= maxshift;
  values222[ciclenumberclicked]= value222; values223[ciclenumberclicked]= value223;   
   if(!RectangleCreate(0,lowcoordinitname,0,value222,LOW,value222+(timetoadd*1),LOW,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
     
        if(!RectangleCreate(0,highcoordinitname,0,value223,HIGH,value223+(timetoadd*1),HIGH,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
     if ((ciclenumberclicked != 6) && (ciclenumberclicked != 7))
     {
  //guardo valores de extremo para poder usarlos luego, luego podria marcarlos con una TL de momento solo guardo un punto para poder usarlo incluso en un reinicio
//punto de extremo 61
   if(!RectangleCreate(0,extremo61name,0,value222,extremos61,value222+(timetoadd*1),extremos61,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
    // Print ( "test: " + ciclenumber);
     //punto de extremo parte alta
   if(!RectangleCreate(0,extremoaltaname,0,value222,extremosalta,value222+(timetoadd*1),extremosalta,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
     //punto de extremo parte baja
   if(!RectangleCreate(0,extramobajaname,0,value222,extremosbaja,value222+(timetoadd*1),extremosbaja,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
     
          //punto que marca final de parte alta
   if(!RectangleCreate(0,fincicloalta,0,value222,finalcicloalto,value222+(timetoadd*1),finalcicloalto,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
     
               //punto que marca final de parte baja
   if(!RectangleCreate(0,finciclobaja,0,value222,finalciclobajo,value222+(timetoadd*1),finalciclobajo,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
        }
  //parte alta
  
 // Print ( " data: " + topname + " - " + fibo38date + " - " +  HIGH + " - " + boxheight + " - " + ciclecolour );
   if ((isfull) || (istop))
   if(!RectangleCreate(0,topname,0,fibo38date,HIGH,endrectangledate+(timetoadd*70),HIGH+boxheight,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
     
     //61
      if ((isfull) || (is61))
     if(!RectangleCreate(0,name61,0,fibo38date,fibo61,endrectangledate+(timetoadd*70),fibo809,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
     
     //solo para seguimiento 
     if (showlogs)
     {
     Print (" nivel de extremo 61: " + Get_extremo(ciclenumberclicked,1) + " para el ciclo: " + ciclenumberclicked);
     Print (" nivel de extremo parte alta: " + Get_extremo(ciclenumberclicked,2) + " para el ciclo: " + ciclenumberclicked);
     Print (" nivel de extremo parte baja: " + Get_extremo(ciclenumberclicked,3) + " para el ciclo: " + ciclenumberclicked);
     }
     //parte baja
      if ((isfull) || (isbottom))   
     if(!RectangleCreate(0,bottomname,0,fibo38date,LOW,endrectangledate+(timetoadd*70),LOW-boxheight,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
     //38
      if ((isfull) || (is61))
        if(!HLineCreate(0,name38,0,fibo38,ciclecolour,InpStyle,InpWidth,InpBack,false,InpHidden,InpZOrder)) //set selection to false oo 38 lines
     {
       Print("No se pudo colocar la linea de inicio , revisar ");
     }
     //inicio
       
     if(!RectangleCreate(0,initname,0,initxvalue-(timetoadd*4),inityvalue-(iATR(NULL,0,50,0))*0.4,initxvalue+(timetoadd*4),inityvalue+(iATR(NULL,0,50,0))*0.4,ciclecolour,
     RInpStyle,RInpWidth,RInpFill,RInpBack,RInpSelection,RInpHidden,RInpZOrder))
     {
      return;
     }
     /*     if  (!is61)  ///dego iba por aca
           if (isbottom)    
      if(!HLineCreate(0,InpName10,0,(LOW-boxheight)-(boxheight/4),InpColor11,InpStyle,InpWidth,InpBack,
      InpSelection,InpHidden,InpZOrder,true))
     {
       Print("No se pudo colocar la linea de fin de ciclo , revisar ");
     }
     else   if (istop)  
      if(!HLineCreate(0,InpName10,0,Bid-100*Point,InpColor11,InpStyle,8,InpBack,
      InpSelection,InpHidden,InpZOrder,true))
     {
          Print("No se pudo colocar la linea de fin de ciclo , revisar ");
     }*/
     //borro lineas de inicio de ciclo
      VLineDelete(0,VInpName);
       VLineDelete(0,VInpName2);
                //blanqueo variable de ciclo
            ciclenumberclicked = 0;
   //PlaySound("ok.wav");
 // solo para test borrar luego
 //if (showlogs)
// {
//Print (    " baja - alta / 1ra - 2da: " + Get_limitezona(1,3,1)+ " - " + Get_limitezona(1,3,-1)+ " / " + Get_limitezona(1,2,1)+ " - " + Get_limitezona(1,2,-1));
 /*Print ("cicle dir: " + Get_cicledir(ciclenumber));  
*/ //Print ("1er coord 61: " + Get_limitezona(ciclenumber,3,1));  //Get_limitezona(i,1,1)
 /* Print ("2da coord 61  : " + Get_limitezona(ciclenumber,1,-1));  */

  // }
 // Print ( "test: " + ObjectGet(InpNamefinalta8, OBJPROP_PRICE1));
     //  Print (" controlreingreso / dir ciclo / extremo / alertsent / limite 61" +  "nada" + " / " + Get_cicledir(ciclenumber) + " / " + "nada" + " / " + "nada" + " / " + Get_extremo(ciclenumber,2)  );
    
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
                 const long            z_order=0,         // priority for mouse click
                 const bool            selectable=false)   // highlight to move
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
   ObjectSetInteger(chart_ID,name,OBJPROP_SELECTED,selectable);
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
  
  
  bool Draw_fibo (int ciclenumber, datetime fechain, int indicein, datetime fechafin, int indicefin)
  {  color ciclecolour;string initname,lowcoordinitname,highcoordinitname;
     double lowf, highf;
     int fibominshift, fibomaxhift;
     lowf = Low[ minshifhts[ciclenumberclicked]];  // nivel 0
     highf = High[maxshifhts[ciclenumberclicked]];  //nivel 100
     //borro lineas verticales que se muestran al clickear ciclo
        VLineDelete(0,VInpName);
       VLineDelete(0,VInpName2);
     
     /*
       Price1 = ObjectGet(NAME, OBJPROP_PRICE1);   
         Price2 = ObjectGet(NAME, OBJPROP_PRICE2);   
         Time1 =   ObjectGet(NAME, OBJPROP_TIME1);     
         Time1 =   ObjectGet(NAME, OBJPROP_TIME2); 
     */
  
   int levels=11,i;
   double values[11] = { 0, 0.382, 0.618, 1.0, 1.382, -0.382, 1.618, 0.809,-0.23875,1.23785,0.85675};

      switch (ciclenumber)
                  { 
                  case 1: { ciclecolour = InpColor; initname = InpNamefibo; lowcoordinitname =InpNamecoordlow; highcoordinitname=InpNamecoordhigh; break;}
                  case 2: { ciclecolour = InpColor2; initname = InpNamefibo2; lowcoordinitname =InpNamecoordlow2; highcoordinitname=InpNamecoordhigh2; break;}  
                  case 3: { ciclecolour = InpColor3; initname = InpNamefibo3; lowcoordinitname =InpNamecoordlow3; highcoordinitname=InpNamecoordhigh3;break;} 
                  case 4: { ciclecolour = InpColor4; initname = InpNamefibo4; lowcoordinitname =InpNamecoordlow4; highcoordinitname=InpNamecoordhigh4;break;} 
                  case 5: { ciclecolour = InpColor5; initname = InpNamefibo5; lowcoordinitname =InpNamecoordlow5; highcoordinitname=InpNamecoordhigh5;break;} 
                  case 6: { ciclecolour = InpColor6; initname = InpNamefibo6; lowcoordinitname =InpNamecoordlow6; highcoordinitname=InpNamecoordhigh6;break;} 
                  case 7: { ciclecolour = InpColor7; initname = InpNamefibo7; lowcoordinitname =InpNamecoordlow7; highcoordinitname=InpNamecoordhigh7; break;} 
                  case 8: { ciclecolour = InpColor8; initname = InpNamefibo8; lowcoordinitname =InpNamecoordlow8; highcoordinitname=InpNamecoordhigh8; break;} 
                  case 9: { ciclecolour = InpColor9; initname = InpNamefibo9; lowcoordinitname =InpNamecoordlow9; highcoordinitname=InpNamecoordhigh9;break;} 
                  case 10: { ciclecolour = InpColor11; initname = InpNamefibo10; lowcoordinitname =InpNamecoordlow10; highcoordinitname=InpNamecoordhigh10;break;} 
                  case 11: { ciclecolour = InpColor12; initname = InpNamefibo11; lowcoordinitname =InpNamecoordlow11; highcoordinitname=InpNamecoordhigh11;break;} 
                  case 12: { ciclecolour = InpColor8; initname = InpNamefibo12; lowcoordinitname =InpNamecoordlow12; highcoordinitname=InpNamecoordhigh12;break;} 
                  case 13: { ciclecolour = InpColor9; initname = InpNamefibo13; lowcoordinitname =InpNamecoordlow13; highcoordinitname=InpNamecoordhigh13;break;} 
                  }
                  //-- obtengo las propiedades del rectangulo creado
                 double  Price1 = ObjectGet(lowcoordinitname, OBJPROP_PRICE1);   
                  datetime Time1 =   ObjectGet(lowcoordinitname, OBJPROP_TIME1);
                 double  Price2 = ObjectGet(highcoordinitname, OBJPROP_PRICE1);   
                  datetime Time2 =   ObjectGet(highcoordinitname, OBJPROP_TIME1);  
                   fibominshift=iBarShift(NULL,0,Time1);
                    fibomaxhift=iBarShift(NULL,0,Time2);    
                  //Print ("shesha: " + Price1 + " - " + fechafin);
                  
      color colors [11]  = { clrBlack,clrBlack,clrBlack,clrBlack,clrBlack,clrBlack,clrBlack,clrBlack,clrBlack,clrBlack,clrBlack}; 
      /*
      input color           InpColor=clrTomato;     // Line color
input color           InpColor2=clrDodgerBlue;     // Line color
input color           InpColor3=clrSienna;     // Line color
input color           InpColor4=clrOrchid;     // Line color
input color           InpColor5=clrLightGoldenrod;     // Line color
input color           InpColor6=clrLawnGreen;     // Line color
input color           InpColor7=clrSpringGreen;     // Line color
input color           InpColor8=clrMediumTurquoise;     // Line color
input color           InpColor9=clrMediumSeaGreen;     // Line color
input color           InpColor10=clrBlack;     // Line color
input color           InpColor11=clrGold;     // Line color
      */
          switch (ciclenumber)
                  { 
                  case 1: {   for( i=0;i<levels;i++) { colors [i]  = clrTomato;}break; }
                  case 2: {   for( i=0;i<levels;i++) { colors [i]  = clrDodgerBlue;}break; }
                  case 3: {   for( i=0;i<levels;i++) { colors [i]  = clrSienna;}break; }
                  case 4: {   for( i=0;i<levels;i++) { colors [i]  = clrOrchid;}break; }
                  case 5: {   for( i=0;i<levels;i++) { colors [i]  = clrLightGoldenrod;}break; }
                  case 6: {   for( i=0;i<levels;i++) { colors [i]  = clrLawnGreen;}break; }
                  case 7: {   for( i=0;i<levels;i++) { colors [i]  = clrSpringGreen;}break; }
                  case 8: {   for( i=0;i<levels;i++) { colors [i]  = clrMediumTurquoise;}break; }
                  case 9: {   for( i=0;i<levels;i++) { colors [i]  = clrMediumSeaGreen;}break; }
                  case 10: {   for( i=0;i<levels;i++) { colors [i]  = clrGold;}break; }
                  case 11: {   for( i=0;i<levels;i++) { colors [i]  = clrMoccasin;}break; }
                  case 12: {   for( i=0;i<levels;i++) { colors [i]  = clrMediumTurquoise;}break; }
                  case 13: {   for( i=0;i<levels;i++) { colors [i]  = clrMediumSeaGreen;}break; }    
                 
                  }
      
                    
      ENUM_LINE_STYLE styles[11] =  { STYLE_SOLID,STYLE_SOLID,STYLE_SOLID,STYLE_SOLID,STYLE_SOLID,STYLE_SOLID,STYLE_SOLID,STYLE_SOLID,STYLE_SOLID,STYLE_SOLID,STYLE_SOLID};   
      int widths[11] = {1,1,1,1,1,1,1,1,1,1,1};
              if(fibomaxhift < fibominshift) //UP
                  {      
                     if(!FiboLevelsCreate(0,initname,0,Time1,Price1,Time2,Price2,ciclecolour,
      InpStyle,InpWidth,InpBack,InpSelection,false,InpHidden,InpZOrder))
     {
      return false;
     }
     else {
     //seteo niveles
              if(!FiboLevelsSet(levels,values,colors, styles, widths,0,initname)) 
     return true;
     else return false;
     }
     }
     else
     {
                          if(!FiboLevelsCreate(0,initname,0,Time2,Price2,Time1,Price1,ciclecolour,
      InpStyle,InpWidth,InpBack,InpSelection,false,InpHidden,InpZOrder))
     {
      return false;
     }
     else {
     //seteo niveles
              if(!FiboLevelsSet(levels,values,colors, styles, widths,0,initname)) 
     return true;
     else return false;
     }
     }
              
  }
//obtento el nivel de extremo dado un ciclo y zona
 double Get_extremo (int ciclenumber, int indiceextremo)
  {  string extremo61name,extremoaltaname,extramobajaname; double Price1=0;

      switch (ciclenumber)
                  { 
                  case 1: { extremo61name=InpNameextremo611; extremoaltaname=InpNamealta1; extramobajaname=InpNamebaja1; break;}
                  case 2: { extremo61name=InpNameextremo612; extremoaltaname=InpNamealta2; extramobajaname=InpNamebaja2; break;}
                  case 3: { extremo61name=InpNameextremo613; extremoaltaname=InpNamealta3; extramobajaname=InpNamebaja3; break;}
                  case 4: { extremo61name=InpNameextremo614; extremoaltaname=InpNamealta4; extramobajaname=InpNamebaja4; break;}
                  case 5: { extremo61name=InpNameextremo615; extremoaltaname=InpNamealta5; extramobajaname=InpNamebaja5; break;}
                  case 8: { extremo61name=InpNameextremo618; extremoaltaname=InpNamealta8; extramobajaname=InpNamebaja8; break;}
                  case 9: { extremo61name=InpNameextremo619; extremoaltaname=InpNamealta9; extramobajaname=InpNamebaja9; break;}
                  case 10: { extremo61name=InpNameextremo6110; extremoaltaname=InpNamealta10; extramobajaname=InpNamebaja10; break;}
                  case 11: { extremo61name=InpNameextremo6111; extremoaltaname=InpNamealta11; extramobajaname=InpNamebaja11; break;}
                  case 12: { extremo61name=InpNameextremo6112; extremoaltaname=InpNamealta12; extramobajaname=InpNamebaja12; break;}
                  case 13: { extremo61name=InpNameextremo6113; extremoaltaname=InpNamealta13; extramobajaname=InpNamebaja13; break;}   
                  }
                                                     
          switch (indiceextremo)
                  { 
                  case 1: {  Price1 = ObjectGet(extremo61name, OBJPROP_PRICE1); break; }
                  case 2: {  Price1 = ObjectGet(extremoaltaname, OBJPROP_PRICE1); break; }
                  case 3: {  Price1 = ObjectGet(extramobajaname, OBJPROP_PRICE1); break; }    
                 
                  }
      
return (Price1);
 
              
  }

//dado un ciclo indica si es alcista o bajista
 int Get_cicledir (int ciclenumber)
  {  string lowcoordinitname,highcoordinitname; datetime Price1,Price2; int minxshift_func,maxshift_func;

      switch (ciclenumber)
                  { 
                  case 1: { lowcoordinitname =InpNamecoordlow; highcoordinitname=InpNamecoordhigh; break;}
                  case 2: { lowcoordinitname =InpNamecoordlow2; highcoordinitname=InpNamecoordhigh2; break;}  
                  case 3: { lowcoordinitname =InpNamecoordlow3; highcoordinitname=InpNamecoordhigh3;break;} 
                  case 4: { lowcoordinitname =InpNamecoordlow4; highcoordinitname=InpNamecoordhigh4;break;} 
                  case 5: { lowcoordinitname =InpNamecoordlow5; highcoordinitname=InpNamecoordhigh5;break;} 
                  case 6: { lowcoordinitname =InpNamecoordlow6; highcoordinitname=InpNamecoordhigh6;break;} 
                  case 7: { lowcoordinitname =InpNamecoordlow7; highcoordinitname=InpNamecoordhigh7; break;} 
                  case 8: { lowcoordinitname =InpNamecoordlow8; highcoordinitname=InpNamecoordhigh8; break;} 
                  case 9: { lowcoordinitname =InpNamecoordlow9; highcoordinitname=InpNamecoordhigh9;break;} 
                  case 10: {lowcoordinitname =InpNamecoordlow10; highcoordinitname=InpNamecoordhigh10;break;} 
                  case 11: {lowcoordinitname =InpNamecoordlow11; highcoordinitname=InpNamecoordhigh11;break;} 
                  case 12: {lowcoordinitname =InpNamecoordlow12; highcoordinitname=InpNamecoordhigh12;break;} 
                  case 13: {lowcoordinitname =InpNamecoordlow13; highcoordinitname=InpNamecoordhigh13;break;} 
                  
                  }
           Price1 = ObjectGet(lowcoordinitname, OBJPROP_TIME1); //low coordinate
           Price2 = ObjectGet(highcoordinitname, OBJPROP_TIME1);
              minxshift_func=iBarShift(NULL,0,Price1);
              maxshift_func=iBarShift(NULL,0,Price2);
   
           
      if (maxshift_func<minxshift_func)
      return (1);//ciclo alcista
      else
     return (-1); //ciclo bajista
 
              
  }

//obtengo limite inferior (o superior segun corresponda) dado un ciclo y tipo de zona, esto es para calcular finales de extremos
 double Get_limitezona (int ciclenumber, int indiceextremo, int limite) // ciclo , zona , limite alto/bajo   zona 1 = 62, 2= alta , 3= baja
  {  string name61,fincicloalta,finciclobaja; double Price1=0;

      switch (ciclenumber)
                  { 
                  case 1: { name61 = InpName; finciclobaja=InpNameB; fincicloalta=InpNameT ; break;}
                  case 2: { name61 = InpName2; finciclobaja=InpNameB2; fincicloalta=InpNameT2 ; break;}
                  case 3: { name61 = InpName3; finciclobaja=InpNameB3; fincicloalta=InpNameT3 ; break;}
                  case 4: { name61 = InpName4; finciclobaja=InpNameB4; fincicloalta=InpNameT4 ; break;}
                  case 5: { name61 = InpName5; finciclobaja=InpNameB5; fincicloalta=InpNameT5 ; break;}
                  case 8: { name61 = InpName8; finciclobaja=InpNameB8; fincicloalta=InpNameT8 ; break;}
                  case 9: { name61 = InpName9; finciclobaja=InpNameB9; fincicloalta=InpNameT9 ; break;}
                  case 10: { name61 = InpName10; finciclobaja=InpNameB10; fincicloalta=InpNameT10 ; break;}
                  case 11: { name61 = InpName11; finciclobaja=InpNameB11; fincicloalta=InpNameT11 ; break;}
                  case 12: { name61 = InpName12; finciclobaja=InpNameB12; fincicloalta=InpNameT12 ; break;}
                  case 13: { name61 = InpName13; finciclobaja=InpNameB13; fincicloalta=InpNameT13 ; break;}
                  }
               
                    switch (indiceextremo)
                   {  
                   case 1: { if (limite == -1) {Price1 = ObjectGet(name61, OBJPROP_PRICE2);} else {Price1 = ObjectGet(name61, OBJPROP_PRICE1);}  break; } //price1 = 61 price2 = 809 sin importar la dir del ciclo
                   case 2: { if (limite == -1) {Price1 = ObjectGet(fincicloalta, OBJPROP_PRICE2);} else {Price1 = ObjectGet(fincicloalta, OBJPROP_PRICE1);}  break; } //price 1 = high price2 = high+-heightbox
                   case 3: { if (limite == -1) {Price1 = ObjectGet(finciclobaja, OBJPROP_PRICE2);} else {Price1 = ObjectGet(finciclobaja, OBJPROP_PRICE1);} break; }  //price 1 = low price2 = low+heightbox  
                   }
        
      
return (Price1);
 
              
  }
  //obtengo el nivel de fin de ciclo por parte alta o baja
   double Get_finciclo (int ciclenumber, int indiceextremo) // ciclo , alto/bajo  1 / -1
  {  string name61,fincicloalta,finciclobaja; double Price1;
      switch (ciclenumber)
                  { 
                  case 1: { name61 = InpName; finciclobaja=InpNamefinbaja1; fincicloalta=InpNamefinalta1 ; break;}
                  case 2: { name61 = InpName2; finciclobaja=InpNamefinbaja2; fincicloalta=InpNamefinalta2 ; break;}
                  case 3: { name61 = InpName3; finciclobaja=InpNamefinbaja3; fincicloalta=InpNamefinalta3 ; break;}
                  case 4: { name61 = InpName4; finciclobaja=InpNamefinbaja4; fincicloalta=InpNamefinalta4 ; break;}
                  case 5: { name61 = InpName5; finciclobaja=InpNamefinbaja5; fincicloalta=InpNamefinalta5 ; break;}
                  case 8: { name61 = InpName8; finciclobaja=InpNamefinbaja8; fincicloalta=InpNamefinalta8 ; break;}
                  case 9: { name61 = InpName9; finciclobaja=InpNamefinbaja9; fincicloalta=InpNamefinalta9 ; break;}
                  case 10: { name61 = InpName10; finciclobaja=InpNamefinbaja10; fincicloalta=InpNamefinalta10 ; break;}
                  case 11: { name61 = InpName11; finciclobaja=InpNamefinbaja11; fincicloalta=InpNamefinalta11 ; break;}
                  case 12: { name61 = InpName12; finciclobaja=InpNamefinbaja12; fincicloalta=InpNamefinalta12 ; break;}
                  case 13: { name61 = InpName13; finciclobaja=InpNamefinbaja13; fincicloalta=InpNamefinalta13 ; break;}
                  }
               
               if (indiceextremo == 1)
               Price1 = ObjectGet(fincicloalta, OBJPROP_PRICE1);
               else
               Price1 = ObjectGet(finciclobaja, OBJPROP_PRICE1);
   //   Print ( " cicle num / incice / price1 " + ciclenumber + " / " + indiceextremo + " / " + Price1);

return (Price1);
 
              
  }
  //dado un numero de ciclo verifica si existe en el chart
  bool iscicleonchart(int ciclenumber)
  {
    string initname;
        switch (ciclenumber)
                  { 
                  case 1: { initname = InpNameInit; break;}
                   case 2: { initname = InpNameInit2; break;}
                    case 3: { initname = InpNameInit3; break;}
                     case 4: { initname = InpNameInit4; break;}
                      case 5: { initname = InpNameInit5; break;}
                       case 6: { initname = InpNameInit6; break;}
                        case 7: { initname = InpNameInit7; break;}
                         case 8: { initname = InpNameInit8; break;}
                          case 9: { initname = InpNameInit9; break;}
                           case 10: { initname = InpNameInit10; break;}
                            case 11: { initname = InpNameInit11; break;}
                             case 12: { initname = InpNameInit12; break;}
                              case 13: { initname = InpNameInit13; break;}
                  }
                 
  if(ObjectFind(0,initname) == 0) 
  return(true);
  else
  return (false);
  }
  
  string nameofcicle (int ciclenumber)
  { string initname;
          switch (ciclenumber)
                  { 
                  case 1: { initname = "1er ciclo"; break;}
                   case 2: { initname = "2do ciclo"; break;}
                    case 3: { initname = "3er ciclo"; break;}
                     case 4: { initname = "4to ciclo"; break;}
                      case 5: { initname = "5to ciclo"; break;}
                       case 6: { initname = " Alerta 1 ciclo"; break;}
                        case 7: { initname = "Alerta 2 ciclo"; break;}
                         case 8: { initname = "Pto Ctrl 1 ciclo"; break;}
                          case 9: { initname = "Seguimiento ciclo"; break;}
                           case 10: { initname = "6to ciclo"; break;}
                            case 11: { initname = "7mo ciclo"; break;}
                             case 12: { initname = "Pto Ctrl 2 ciclo"; break;}
                              case 13: { initname = "Seguimiento 2 ciclo"; break;}
                  }
                  return (initname);
  }
  
  string nameofzona (int zonenumber)
  { string zona;
          switch (zonenumber)
                  { 
                  case 1:  zona = "61"; break;
                   case 2:  zona = "Parte alta"; break;
                    case 3:  zona = "Parte baja"; break;
                     default: zona = "Zona Invalida"; break;
                    }
                    return zona;
  }
  //alertas por telegram notificaciones push y print
  void sendnotifications (string message)
  {
         if ( sendpushnotification)
         SendNotification(message);
         Print (message);
         if (sendtelegrammessages)
         bot.SendMessage(483136962,message);
  }
  
  void hideButtons () {
         ObjectSetString(0,"button26",OBJPROP_TEXT,"Show");
         HideButton("button1");HideButton("button2");HideButton("button3");HideButton("button4");HideButton("button5");
         HideButton("button6");HideButton("button7");HideButton("button8");HideButton("button9");HideButton("button10");
         HideButton("button11");HideButton("button12");HideButton("button13");HideButton("button14");HideButton("button15");
         HideButton("button16");HideButton("button17");HideButton("button18");HideButton("button19");HideButton("button20");
         HideButton("button21");HideButton("button22");HideButton("button23");HideButton("button24");HideButton("button25");
         HideButton("button27");HideButton("button28");HideButton("button29");HideButton("button30");HideButton("button31");
         HideButton("button32");HideButton("button33");HideButton("button34");HideButton("button35");HideButton("button36");
         HideButton("button37");HideButton("button38");HideButton("button39");HideButton("button40");HideButton("button41");
         HideButton("button42");HideButton("buttonDesbalances");HideButton("buttonDesbalances1");HideButton("buttonDesbalances2");HideButton("buttonDesbalances3");
        
         ObjectSetInteger(0,"button26",OBJPROP_STATE,false);
       hideButtonsGlobal = true; 
  }
  
int ExtractNumbersFromObjectName2(string objectName)
{
    string numbersOnly = "";
//OBJPROP_CREATETIME
    for (int i = 0; i < StringLen(objectName); i++)
    {   char c = StringGetChar(objectName, i);
        //Print ("Code: " + c);
        if ((c >= 48) && (c <= 57))
        {
            numbersOnly = numbersOnly + StringSubstr(objectName,i,1) ;
        }
    }

    return StrToInteger(numbersOnly);
}

int ExtractNumbersFromObjectName(string objectName)
{
  if (creationTime <= ObjectGet(objectName, OBJPROP_CREATETIME)) {
  creationTime = ObjectGet(objectName, OBJPROP_CREATETIME);
  lastRectangleName = objectName;
  }

    return creationTime;
}

void changeLastRectangleColour ( color clr) {
        lastRectangleNum = 0; lastRectangleName = "";
            for(int i=ObjectsTotal()-1; i>-1; i--)
            {
               if(StringFind(ObjectName(i),"Rectangle")>=0) {
                     ExtractNumbersFromObjectName(ObjectName(i));
                     
               } 
            }
            Print ("num and name" + lastRectangleNum + " - " + lastRectangleName + " - " + creationTime+ " - " + ObjectsTotal());
            ObjectSetInteger(0,lastRectangleName,OBJPROP_COLOR,clr);
}