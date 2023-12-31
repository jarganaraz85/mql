
//+------------------------------------------------------------------+
//|                                          desbalancesHideShow.mq4 |
//|                                                   JUAN ARGAÑARAZ |
//|                                              argjuan85@gmail.com |
//+------------------------------------------------------------------+

#property indicator_chart_window
extern int    candleAmount = 400;
extern int    linesShown = 3;
extern int    candleAmount2 = 800;
extern int    linesShown2 = 6;
extern int    candleAmount3 = 1200;
extern int    linesShown3 = 9;
int stopCondition;
bool showDesbalancesVar;
int namesIndex, candleAmountUsed, linesShownUsed;
double bodySizes[1000],rs;
string rectangleNames[50];

int init() {
   CreateButton("buttonDesbalances","Show",20,100,45,30,White,Gray,White,10);
   CreateButton("buttonDesbalances1","1",70,100,25,30,White,Gray,White,10);
   CreateButton("buttonDesbalances2","2",100,100,25,30,White,Gray,White,10);
   CreateButton("buttonDesbalances3","3",130,100,25,30,White,Gray,White,10);
   namesIndex =0;
   stopCondition = 0;
   candleAmountUsed =candleAmount;
   showDesbalancesVar = false;
   ArrayResize(bodySizes,candleAmountUsed);
   int c = IndicatorCounted ();
   // in this case we dont care about recalculating last bar, this will trigger at the beggining and once per new bar
   if ((c < 0) || (stopCondition == 1)) {
    return (- 1);
   }
   return(INIT_SUCCEEDED);
}
//+------------------------------------------------------------------+
int start() {
   return (1);
}
//+------------------------------------------------------------------+
int deinit() {
   for (int j=0;j<namesIndex;j++) {
            RectangleDelete(0,rectangleNames[j]);
   }
   ObjectDelete(0,"buttonDesbalances");
   ObjectDelete(0,"buttonDesbalances1");
   ObjectDelete(0,"buttonDesbalances2");
   ObjectDelete(0,"buttonDesbalances3");
   return(0);  
}
//+------------------------------------------------------------------+
void OnChartEvent(const int id,const long &lparam,const double &dparam,const string &sparam) {
        if(sparam=="buttonDesbalances") { // Show / Hide buttons
         if (ObjectGetString(0,"buttonDesbalances",OBJPROP_TEXT) == "Show") {
            ObjectSetString(0,"buttonDesbalances",OBJPROP_TEXT,"Hide");
            showDesbalancesVar = True;
            calculateDesbalances();
            showDesbalances();
            stopCondition = 0;
         }
         else if(ObjectGetString(0,"buttonDesbalances",OBJPROP_TEXT) == "Hide") {
          ObjectSetString(0,"buttonDesbalances",OBJPROP_TEXT,"Show");
          showDesbalancesVar = False;  
          for (int j=0;j<namesIndex;j++) {
            RectangleDelete(0,rectangleNames[j]);
          }
          namesIndex = 0;
         }
         
         ObjectSetInteger(0,"buttonDesbalances",OBJPROP_STATE,false);
        }
        if(sparam=="buttonDesbalances1") {
         setParams(candleAmount,linesShown);
         ObjectSetInteger(0,"buttonDesbalances1",OBJPROP_STATE,false);
        }
        if(sparam=="buttonDesbalances2") {
         setParams(candleAmount2,linesShown2);
         ObjectSetInteger(0,"buttonDesbalances2",OBJPROP_STATE,false);
        }  
        if(sparam=="buttonDesbalances3") {
         setParams(candleAmount3,linesShown3);
         ObjectSetInteger(0,"buttonDesbalances3",OBJPROP_STATE,false);
        }     
}

//+------------------------------------------------------------------+

void desbalancesDraw2(int n, double level, datetime t) {
double desbalSize;
string name;
name = "desbal"+n;
desbalSize = iATR(NULL,0,300,0)/4;
if(!RectangleCreate(0,name,0,t,level,Time[0],level+desbalSize)) {
       Print("Indice: " + n);
  } else {
  rectangleNames[namesIndex]=name;
  namesIndex++;
  }
}
//+------------------------------------------------------------------+

void showDesbalances (){ 
  int maxValueIdx; 
  if (showDesbalancesVar) {
   for(int i=linesShownUsed; i>=0; i--) {
    maxValueIdx=ArrayMaximum(bodySizes);
    desbalancesDraw2(maxValueIdx,Open[maxValueIdx],Time[maxValueIdx]);
    bodySizes[maxValueIdx]= 0;
   }
  }
  stopCondition = 1;
}

void calculateDesbalances(){
   for (int i=candleAmountUsed;i>0;i--) {
    bodySizes[i]=0;
    rs = (NormalizeDouble(Open[i],Digits)-NormalizeDouble(Close[i],Digits))/Point;
    bodySizes[i]=MathAbs(rs); 
   }
}

void setParams(int candles, int lines){
   candleAmountUsed = candles;
   linesShownUsed = lines;
   ArrayResize(bodySizes,candleAmountUsed);
}
 
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
                     const color           clr=clrYellow,        // rectangle color
                     const ENUM_LINE_STYLE style=STYLE_SOLID, // style of rectangle lines
                     const int             width=1,           // width of rectangle lines
                     const bool            fill=true,        // filling rectangle with color
                     const bool            back=false,        // in the background
                     const bool            selection=false,    // highlight to move
                     const bool            hidden=false,       // hidden in the object list
                     const long            z_order=0)         // priority for mouse click
  {
//--- set anchor points' coordinates if they are not set
   ChangeRectangleEmptyPoints(time1,price1,time2,price2);
//--- reset the error value
   ResetLastError();
   if ( ObjectFind(0,name) != 0)
   { 
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
   }
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
  
  void CreateButton(string btnName,string btnText,int x,int y,int w,int h,color clrText,color clrBg,color clrBorder,int fontSize) {
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
  

