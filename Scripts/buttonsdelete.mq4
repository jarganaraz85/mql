//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+

void OnStart()
  {

      for(int i=ObjectsTotal()-1; i>-1; i--) {
      if(StringFind(ObjectName(i),"button")>=0) ObjectDelete(ObjectName(i));
      if(StringFind(ObjectName(i),"desbal")>=0) ObjectDelete(ObjectName(i));
      }
      ObjectDelete("Milito Vega Draw");
      Comment("");
  
  }

