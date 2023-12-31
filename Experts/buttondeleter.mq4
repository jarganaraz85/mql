//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart()
  {
//---
   long currChart;
   long prevChart=ChartFirst();
   for(int i=ObjectsTotal()-1; i>-1; i--) {
      if(StringFind(ObjectName(i),"button")>=0) ObjectDelete(ObjectName(i));
   }
   int chartCount = 1;
   // Loop through charts
   while(true)
     {
      // Get next chart
      currChart=ChartNext(prevChart);
      // If currChart < 0 ==> we iterated through all charts, exit loop
      if(currChart<0)
         break;
      for( i=ObjectsTotal()-1; i>-1; i--) {
      if(StringFind(ObjectName(i),"button")>=0) ObjectDelete(ObjectName(i));
      }
      chartCount++;
      prevChart=currChart;
     }
  
  }

