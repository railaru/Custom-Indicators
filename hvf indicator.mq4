//+------------------------------------------------------------------+
//|                                           HVF profit manager.mq4 |
//|                                   Copyright 2018, Rutenis Raila. |
//|                                     https://www.rutenisraila.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2018, Rutenis Raila."
#property link      "https://www.rutenisraila.com"
#property version   "1.00"
#property strict
#property indicator_chart_window
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+

  enum Draw_Type_enumeration
  {
    DrawType_1                     = 1,  // New
    DrawType_2                     = 2,  // Pre drawn points
  };

  input Draw_Type_enumeration  Draw_Type = 1;


color              Color                     = Gray; // used to be extern
extern string             UserDefiniedObjectName    = "";


//extern string     FIBONACCI_FAN_SETTINGS = "FIBONACCI_FAN_SETTINGS";
extern bool               DrawFibonacciFans         = false;

  enum Fibonacci_Fan_enumeration1
  {
    Point1_1                     = 1,  // Point1
    Point1_2                     = 2,  // Point2 recommended 2
    Point1_3                     = 3,  // Point3
    Point1_4                     = 4,  // Point4 recommended 1
    Point1_5                     = 5,  // Point5
    Point1_6                     = 6,  // Point6


  };

  input Fibonacci_Fan_enumeration1  FibonacciPoint1 = Point1_4;

  enum Fibonacci_Fan_enumeration2
  {
    Point2_1                     = 1,  // Point1
    Point2_2                     = 2,  // Point2
    Point2_3                     = 3,  // Point3 recommended 2
    Point2_4                     = 4,  // Point4
    Point2_5                     = 5,  // Point5 recommended 1
    Point2_6                     = 6,  // Point6


  };

  input Fibonacci_Fan_enumeration2  FibonacciPoint2 = Point2_5;


//extern string     OTHER_SETTINGS = "OTHER_SETTINGS";
extern bool   ExtendTargets                       = false;
extern bool   Extend_EP_SL                        = false;
extern bool   ShowTimeStops                       = true;
extern bool   DeletePointsAfterRemove             = false;
bool   AdjustLevels                        = false; // used to be extern
int    AdjustRange                         = 5; // used to be extern

string EMAIL_NOTIFICATION_SETTINGS; // used to be extern

bool   NotifyWhenPriceReachesEntryPoint    = false; // used to be extern
bool   NotifyWhenPriceReachesStopLoss      = false; // used to be extern
bool   NotifyWhenPriceReachesTarget3       = false; // used to be extern
bool   NotifyWhenPriceReachesTarget2       = false; // used to be extern
bool   NotifyWhenPriceReachesTarget1       = false; // used to be extern






double Label1_Price;
double Label2_Price;
double Label3_Price;
double Label4_Price;
double Label5_Price;
double Label6_Price;

datetime Label1_Time;
datetime Label2_Time;
datetime Label3_Time;
datetime Label4_Time;
datetime Label5_Time;
datetime Label6_Time;

double Target1;
double Target2;
double Target3;

double HVF_Axis;

double SL_InPips;
double TP_InPips;
double RRR;

bool   LabelsWereSet = false;

void OnInit()
  {

    DrawHvf();
    if(DrawFibonacciFans == true) {FiboFanCreate();}   

  }

void start()
  {


    if(LabelsWereSet == true)
      {
         DrawHvf();
        
        if(DrawFibonacciFans == true) 
         {
            FiboFanCreate();
         }   

        if(
          NotifyWhenPriceReachesEntryPoint  == true ||
          NotifyWhenPriceReachesStopLoss    == true ||
          NotifyWhenPriceReachesTarget3     == true ||
          NotifyWhenPriceReachesTarget2     == true ||
          NotifyWhenPriceReachesTarget1     == true 
          )
        
            {
              EmailNotification();
            }
                
      }
  }

void EmailNotification()
  {
    bool SendMail_bool = false;

    // notify when price reaches EntryPoint

      if((NotifyWhenPriceReachesEntryPoint == true && Ask == Label5_Price && Label1_Price > Label2_Price) 
      || (NotifyWhenPriceReachesEntryPoint == true && Bid == Label5_Price && Label1_Price < Label2_Price))

        SendMail_bool = SendMail(


                    "Hello ", AccountName() + "! You've been notified because price reached entry point ("+ Label5_Price + ") on "+ Symbol() 
                    + ". StopLoss: " + Label6_Price + ", Take Profit: " + Target3 + " \n"   

                    + "\n"
                                                                        
                    + "_____ ACCOUNT INFO SECTION ______ "                                + "\n"
                   
                    + "Account Equity "           + AccountEquity()                       + "\n"
             
                    + "\n"          
             
                    + "Account Balance "          + AccountBalance()                      + "\n"
             
                    + "\n"           
             
                    + "Account Profit "           + AccountProfit()                       + "\n"
                   
                    + "\n"           
             
                    + "Open Orders "              + OrdersTotal()                         + "\n"
                   
                    + "\n"
                                                                        
                    + "_________________________________ "                                + "\n"                                
                    
                    + "\n"    
                    
                    + "Wardenclyffe "                                                     + "\n"
                        
                      );


        if(SendMail_bool == true)
          {
            Print("AIL 0 Notification was sent via email on: ", Symbol());
          }
        
        if(SendMail_bool == false)
          {
            Alert("AIL 2 ERROR sending via email on ", Symbol() ,"! Last returned error: ", GetLastError());
          }
    
    SendMail_bool = false;      

    // notify when price reaches StopLoss

      if((NotifyWhenPriceReachesStopLoss == true && Bid == Label6_Price && Label1_Price > Label2_Price) 
      || (NotifyWhenPriceReachesStopLoss == true && Ask == Label6_Price && Label1_Price < Label2_Price))

        SendMail_bool = SendMail(

                    "Hello ", AccountName() + "! You've been notified because price reached StopLoss ("+ Label6_Price + ") on "+ Symbol() + "\n"  
                     

                    + "\n"
                                                                        
                    + "_____ ACCOUNT INFO SECTION ______ "                                + "\n"
                   
                    + "Account Equity "           + AccountEquity()                       + "\n"
             
                    + "\n"          
             
                    + "Account Balance "          + AccountBalance()                      + "\n"
             
                    + "\n"           
             
                    + "Account Profit "           + AccountProfit()                       + "\n"
                   
                    + "\n"           
             
                    + "Open Orders "              + OrdersTotal()                         + "\n"
                   
                    + "\n"
                                                                        
                    + "_________________________________ "                                + "\n"                                
                    
                    + "\n"    
                    
                    + "Wardenclyffe "                                                     + "\n"
                        
                      );


        if(SendMail_bool == true)
          {
            Print("AIL 0 Notification was sent via email on: ", Symbol());
          }
        
        if(SendMail_bool == false)
          {
            Alert("AIL 2 ERROR sending via email on ", Symbol() ,"! Last returned error: ", GetLastError());
          }

    SendMail_bool = false;      

    // notify when price reaches Target3

      if((NotifyWhenPriceReachesTarget3 == true && Bid == Target3 && Label1_Price > Label2_Price) 
      || (NotifyWhenPriceReachesTarget3 == true && Ask == Target3 && Label1_Price < Label2_Price))

        SendMail_bool = SendMail(

                    "Hello ", AccountName() + "! You've been notified because price reached Target3 (final take profit level) at " + Target3 + " on "+ Symbol() + "\n"  
                     

                    + "\n"
                                                                        
                    + "_____ ACCOUNT INFO SECTION ______ "                                + "\n"
                   
                    + "Account Equity "           + AccountEquity()                       + "\n"
             
                    + "\n"          
             
                    + "Account Balance "          + AccountBalance()                      + "\n"
             
                    + "\n"           
             
                    + "Account Profit "           + AccountProfit()                       + "\n"
                   
                    + "\n"           
             
                    + "Open Orders "              + OrdersTotal()                         + "\n"
                   
                    + "\n"
                                                                        
                    + "_________________________________ "                                + "\n"                                
                    
                    + "\n"    
                    
                    + "Wardenclyffe "                                                     + "\n"
                        
                      );


        if(SendMail_bool == true)
          {
            Print("AIL 0 Notification was sent via email on: ", Symbol());
          }
        
        if(SendMail_bool == false)
          {
            Alert("AIL 2 ERROR sending via email on ", Symbol() ,"! Last returned error: ", GetLastError());
          }
 
    SendMail_bool = false;      

    // notify when price reaches Target2

      if((NotifyWhenPriceReachesTarget2 == true && Bid == Target2 && Label1_Price > Label2_Price) 
      || (NotifyWhenPriceReachesTarget2 == true && Ask == Target2 && Label1_Price < Label2_Price))

        SendMail_bool = SendMail(

                    "Hello ", AccountName() + "! You've been notified because price reached Target2 at " + Target2 + " on "+ Symbol() + "\n"  
                     

                    + "\n"
                                                                        
                    + "_____ ACCOUNT INFO SECTION ______ "                                + "\n"
                   
                    + "Account Equity "           + AccountEquity()                       + "\n"
             
                    + "\n"          
             
                    + "Account Balance "          + AccountBalance()                      + "\n"
             
                    + "\n"           
             
                    + "Account Profit "           + AccountProfit()                       + "\n"
                   
                    + "\n"           
             
                    + "Open Orders "              + OrdersTotal()                         + "\n"
                   
                    + "\n"
                                                                        
                    + "_________________________________ "                                + "\n"                                
                    
                    + "\n"    
                    
                    + "Wardenclyffe "                                                     + "\n"
                        
                      );


        if(SendMail_bool == true)
          {
            Print("AIL 0 Notification was sent via email on: ", Symbol());
          }
        
        if(SendMail_bool == false)
          {
            Alert("AIL 2 ERROR sending via email on ", Symbol() ,"! Last returned error: ", GetLastError());
          }
 
    SendMail_bool = false;      

    // notify when price reaches Target1

      if((NotifyWhenPriceReachesTarget1 == true && Bid == Target1 && Label1_Price > Label2_Price) 
      || (NotifyWhenPriceReachesTarget1 == true && Ask == Target1 && Label1_Price < Label2_Price))

        SendMail_bool = SendMail(

                    "Hello ", AccountName() + "! You've been notified because price reached Target1 at " + Target1 + " on "+ Symbol() + "\n"  
                     

                    + "\n"
                                                                        
                    + "_____ ACCOUNT INFO SECTION ______ "                                + "\n"
                   
                    + "Account Equity "           + AccountEquity()                       + "\n"
             
                    + "\n"          
             
                    + "Account Balance "          + AccountBalance()                      + "\n"
             
                    + "\n"           
             
                    + "Account Profit "           + AccountProfit()                       + "\n"
                   
                    + "\n"           
             
                    + "Open Orders "              + OrdersTotal()                         + "\n"
                   
                    + "\n"
                                                                        
                    + "_________________________________ "                                + "\n"                                
                    
                    + "\n"    
                    
                    + "Wardenclyffe "                                                     + "\n"
                        
                      );


        if(SendMail_bool == true)
          {
            Print("AIL 0 Notification was sent via email on: ", Symbol());
          }
        
        if(SendMail_bool == false)
          {
            Alert("AIL 2 ERROR sending via email on ", Symbol() ,"! Last returned error: ", GetLastError());
          }
               
    SendMail_bool = false;    

  }


//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   
//--- return value of prev_calculated for next call
   return(rates_total);
  }


//+------------------------------------------------------------------+
void deinit()
  {

    ObjectDelete(0,"button");
    Comment("");
    ObjectDelete("Info" + UserDefiniedObjectName);
    ObjectDelete("1_3" + UserDefiniedObjectName);
    ObjectDelete("2_4" + UserDefiniedObjectName);
    ObjectDelete("3_5" + UserDefiniedObjectName);
    ObjectDelete("4_6" + UserDefiniedObjectName);

    if(DeletePointsAfterRemove == true)
      {  
       ObjectDelete("1" + UserDefiniedObjectName);
       ObjectDelete("2" + UserDefiniedObjectName);
       ObjectDelete("3" + UserDefiniedObjectName);
       ObjectDelete("4" + UserDefiniedObjectName);
       ObjectDelete("5" + UserDefiniedObjectName);
       ObjectDelete("6" + UserDefiniedObjectName);
      }


    ObjectDelete("HVF_Axis" + UserDefiniedObjectName);
    ObjectDelete("Target1" + UserDefiniedObjectName);
    ObjectDelete("Target2" + UserDefiniedObjectName);
    ObjectDelete("Target3" + UserDefiniedObjectName);
    ObjectDelete("EntryPoint" + UserDefiniedObjectName);
    ObjectDelete("StopLoss" + UserDefiniedObjectName);


    ObjectDelete("FibonacciFan" + UserDefiniedObjectName);

    ObjectDelete("Target1TimeStop" + UserDefiniedObjectName);
    ObjectDelete("Target2TimeStop" + UserDefiniedObjectName);
    ObjectDelete("Target3TimeStop" + UserDefiniedObjectName);

    ObjectDelete(0, "trendline" + UserDefiniedObjectName);


  }



void DrawHvf()
  {

    Label1_Price = ObjectGet("1" + UserDefiniedObjectName, OBJPROP_PRICE1);
    Label2_Price = ObjectGet("2" + UserDefiniedObjectName, OBJPROP_PRICE1);
    Label3_Price = ObjectGet("3" + UserDefiniedObjectName, OBJPROP_PRICE1);
    Label4_Price = ObjectGet("4" + UserDefiniedObjectName, OBJPROP_PRICE1);
    Label5_Price = ObjectGet("5" + UserDefiniedObjectName, OBJPROP_PRICE1);
    Label6_Price = ObjectGet("6" + UserDefiniedObjectName, OBJPROP_PRICE1);    

    Label1_Time = ObjectGet("1" + UserDefiniedObjectName, OBJPROP_TIME1);
    Label2_Time = ObjectGet("2" + UserDefiniedObjectName, OBJPROP_TIME1);
    Label3_Time = ObjectGet("3" + UserDefiniedObjectName, OBJPROP_TIME1);
    Label4_Time = ObjectGet("4" + UserDefiniedObjectName, OBJPROP_TIME1);
    Label5_Time = ObjectGet("5" + UserDefiniedObjectName, OBJPROP_TIME1);
    Label6_Time = ObjectGet("6" + UserDefiniedObjectName, OBJPROP_TIME1);    

    // regular hvf

      if(Label1_Price > Label2_Price)
        {


//+----------------------------------------------------------------+
//| AdjustLevels section                             |
//+------------------------------------------------------------------+

          if(AdjustLevels == true)
            {
              for(int i = 0; i < iBars(Symbol(), 0); i ++)
                {
                  
                  if(iTime(Symbol(), 0, i) == Label1_Time) 
                    {
                      double PotentialLabel1_Price_Down; double PotentialLabel1_Price_Up;
                      Label1_Price = iHigh(Symbol(), 0, i);
             
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel1_Price_Down = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel1_Price_Up = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i - AdjustRange);

                            // PotentialLabel1_Price_Down is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel1_Price_Down) > Label1_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel1_Price_Down) > iHigh(Symbol(), 0, PotentialLabel1_Price_Up))
                                {
                                  Label1_Price = iHigh(Symbol(), 0, PotentialLabel1_Price_Down);
                                  Label1_Time  = iTime(Symbol(), 0, PotentialLabel1_Price_Down);
                                }

                            // PotentialLabel1_Price_Up is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel1_Price_Up) > Label1_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel1_Price_Up) > iHigh(Symbol(), 0, PotentialLabel1_Price_Down))
                                {
                                  Label1_Price = iHigh(Symbol(), 0, PotentialLabel1_Price_Up);
                                  Label1_Time  = iTime(Symbol(), 0, PotentialLabel1_Price_Up);
                                }                          

                            // Label1_Price is the correct one
          
                              if(iHigh(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel1_Price_Down))
                              if(iHigh(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel1_Price_Up))
                                {
                                  Label1_Price = iHigh(Symbol(), 0, i);
                                  Label1_Time  = iTime(Symbol(), 0, i);
                                }
                    }
                  
                  if(iTime(Symbol(), 0, i) == Label2_Time) 
                    {

                      double PotentialLabel2_Price_Down; double PotentialLabel2_Price_Up;

                      Label2_Price = iLow(Symbol(), 0, i);
           
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel2_Price_Down = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel2_Price_Up = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i - AdjustRange);

                            // PotentialLabel2_Price_Down is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel2_Price_Down) < Label2_Price)
                              if(iLow(Symbol(), 0, PotentialLabel2_Price_Down) < iLow(Symbol(), 0, PotentialLabel2_Price_Up))
                                {
                                  Label2_Price = iLow(Symbol(), 0, PotentialLabel2_Price_Down);
                                  Label2_Time  = iTime(Symbol(), 0, PotentialLabel2_Price_Down);
                                }

                            // PotentialLabel2_Price_Up is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel2_Price_Up) < Label2_Price)
                              if(iLow(Symbol(), 0, PotentialLabel2_Price_Up) < iLow(Symbol(), 0, PotentialLabel2_Price_Down))
                                {
                                  Label2_Price = iLow(Symbol(), 0, PotentialLabel2_Price_Up);
                                  Label2_Time  = iTime(Symbol(), 0, PotentialLabel2_Price_Up);
                                }                          

                            // Label2_Price is the correct one
          
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel2_Price_Down))
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel2_Price_Up))
                                {
                                  Label2_Price = iLow(Symbol(), 0, i);
                                  Label2_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                  if(iTime(Symbol(), 0, i) == Label3_Time) 
                    {

                      double PotentialLabel3_Price_Down; double PotentialLabel3_Price_Up;
                      Label3_Price = iHigh(Symbol(), 0, i);
             
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel3_Price_Down = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel3_Price_Up = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i - AdjustRange);

                            // PotentialLabel3_Price_Down is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel3_Price_Down) > Label3_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel3_Price_Down) > iHigh(Symbol(), 0, PotentialLabel3_Price_Up))
                                {
                                  Label3_Price = iHigh(Symbol(), 0, PotentialLabel3_Price_Down);
                                  Label3_Time  = iTime(Symbol(), 0, PotentialLabel3_Price_Down);
                                }

                            // PotentialLabel3_Price_Up is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel3_Price_Up) > Label3_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel3_Price_Up) > iHigh(Symbol(), 0, PotentialLabel3_Price_Down))
                                {
                                  Label3_Price = iHigh(Symbol(), 0, PotentialLabel3_Price_Up);
                                  Label3_Time  = iTime(Symbol(), 0, PotentialLabel3_Price_Up);
                                }                          

                            // Label3_Price is the correct one
          
                              if(iHigh(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel3_Price_Down))
                              if(iHigh(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel3_Price_Up))
                                {
                                  Label3_Price = iHigh(Symbol(), 0, i);
                                  Label3_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                  if(iTime(Symbol(), 0, i) == Label4_Time) 
                    {

                      double PotentialLabel4_Price_Down; double PotentialLabel4_Price_Up;

                      Label4_Price = iLow(Symbol(), 0, i);
           
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel4_Price_Down = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel4_Price_Up = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i - AdjustRange);

                            // PotentialLabel4_Price_Down is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel4_Price_Down) < Label4_Price)
                              if(iLow(Symbol(), 0, PotentialLabel4_Price_Down) < iLow(Symbol(), 0, PotentialLabel4_Price_Up))
                                {
                                  Label4_Price = iLow(Symbol(), 0, PotentialLabel4_Price_Down);
                                  Label4_Time  = iTime(Symbol(), 0, PotentialLabel4_Price_Down);
                                }

                            // PotentialLabel4_Price_Up is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel4_Price_Up) < Label4_Price)
                              if(iLow(Symbol(), 0, PotentialLabel4_Price_Up) < iLow(Symbol(), 0, PotentialLabel4_Price_Down))
                                {
                                  Label4_Price = iLow(Symbol(), 0, PotentialLabel4_Price_Up);
                                  Label4_Time  = iTime(Symbol(), 0, PotentialLabel4_Price_Up);
                                }                          

                            // Label4_Price is the correct one
          
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel4_Price_Down))
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel4_Price_Up))
                                {
                                  Label4_Price = iLow(Symbol(), 0, i);
                                  Label4_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                  if(iTime(Symbol(), 0, i) == Label5_Time) 
                    {

                      double PotentialLabel5_Price_Down; double PotentialLabel5_Price_Up;
                      Label5_Price = iHigh(Symbol(), 0, i);
             
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel5_Price_Down = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel5_Price_Up = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i - AdjustRange);

                            // PotentialLabel5_Price_Down is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel5_Price_Down) > Label5_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel5_Price_Down) > iHigh(Symbol(), 0, PotentialLabel5_Price_Up))
                                {
                                  Label5_Price = iHigh(Symbol(), 0, PotentialLabel5_Price_Down);
                                  Label5_Time  = iTime(Symbol(), 0, PotentialLabel5_Price_Down);
                                }

                            // PotentialLabel5_Price_Up is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel5_Price_Up) > Label5_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel5_Price_Up) > iHigh(Symbol(), 0, PotentialLabel5_Price_Down))
                                {
                                  Label5_Price = iHigh(Symbol(), 0, PotentialLabel5_Price_Up);
                                  Label5_Time  = iTime(Symbol(), 0, PotentialLabel5_Price_Up);
                                }                          

                            // Label5_Price is the correct one
          
                              if(iHigh(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel5_Price_Down))
                              if(iHigh(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel5_Price_Up))
                                {
                                  Label5_Price = iHigh(Symbol(), 0, i);
                                  Label5_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                  if(iTime(Symbol(), 0, i) == Label6_Time) 
                    {

                      double PotentialLabel6_Price_Down; double PotentialLabel6_Price_Up;

                      Label6_Price = iLow(Symbol(), 0, i);
           
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel6_Price_Down = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel6_Price_Up = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i - AdjustRange);

                            // PotentialLabel6_Price_Down is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel6_Price_Down) < Label6_Price)
                              if(iLow(Symbol(), 0, PotentialLabel6_Price_Down) < iLow(Symbol(), 0, PotentialLabel6_Price_Up))
                                {
                                  Label6_Price = iLow(Symbol(), 0, PotentialLabel6_Price_Down);
                                  Label6_Time  = iTime(Symbol(), 0, PotentialLabel6_Price_Down);
                                }

                            // PotentialLabel6_Price_Up is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel6_Price_Up) < Label6_Price)
                              if(iLow(Symbol(), 0, PotentialLabel6_Price_Up) < iLow(Symbol(), 0, PotentialLabel6_Price_Down))
                                {
                                  Label6_Price = iLow(Symbol(), 0, PotentialLabel6_Price_Up);
                                  Label6_Time  = iTime(Symbol(), 0, PotentialLabel6_Price_Up);
                                }                          

                            // Label6_Price is the correct one
          
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel6_Price_Down))
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel6_Price_Up))
                                {
                                  Label6_Price = iLow(Symbol(), 0, i);
                                  Label6_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                }   

                  color LabelColor = ObjectGet("1" + UserDefiniedObjectName, OBJPROP_COLOR);
                 
                  ObjectDelete("1" + UserDefiniedObjectName);
                  ObjectDelete("2" + UserDefiniedObjectName);
                  ObjectDelete("3" + UserDefiniedObjectName);
                  ObjectDelete("4" + UserDefiniedObjectName);
                  ObjectDelete("5" + UserDefiniedObjectName);
                  ObjectDelete("6" + UserDefiniedObjectName);
                       
                  ObjectCreate("1" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label1_Time, Label1_Price, 0, 0, 0, 0);
                  ObjectCreate("2" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label2_Time, Label2_Price, 0, 0, 0, 0);
                  ObjectCreate("3" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label3_Time, Label3_Price, 0, 0, 0, 0);
                  ObjectCreate("4" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label4_Time, Label4_Price, 0, 0, 0, 0);
                  ObjectCreate("5" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label5_Time, Label5_Price, 0, 0, 0, 0);
                  ObjectCreate("6" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label6_Time, Label6_Price, 0, 0, 0, 0);

                  ObjectSet("1" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("2" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("3" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("4" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("5" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("6" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  


            }

//+----------------------------------------------------------------+
//| END of AdjustLevels section                             |
//+------------------------------------------------------------------+




          if(HVF_Axis == 0)
            {
              
              //HVF_Axis = (Label1_Price + Label2_Price + Label3_Price + Label4_Price + Label5_Price + Label6_Price)/6;
                HVF_Axis = (HVF_Axis = Label5_Price + Label6_Price) / 2;
                ObjectDelete("HVF_Axis" + UserDefiniedObjectName);

                ObjectCreate("HVF_Axis" + UserDefiniedObjectName,OBJ_TREND, 0, Label1_Time, HVF_Axis, Label6_Time + (Label6_Time - Label5_Time), HVF_Axis, 0, 0);
                ObjectSet("HVF_Axis" + UserDefiniedObjectName, OBJPROP_COLOR, clrDarkGoldenrod);
                ObjectSet("HVF_Axis" + UserDefiniedObjectName, OBJPROP_RAY, 0);
                ObjectSet("HVF_Axis" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
            }

          if(HVF_Axis > 0)
            {
              HVF_Axis = ObjectGet("HVF_Axis"  + UserDefiniedObjectName, OBJPROP_PRICE1);
            }
          

          Target3 = (Label1_Price - Label2_Price) + HVF_Axis;

          ObjectDelete("Target3" + UserDefiniedObjectName);
          ObjectCreate("Target3" + UserDefiniedObjectName,OBJ_TREND, 0, Label6_Time, Target3, (Label6_Time - Label1_Time) + Label6_Time, Target3, 0, 0);
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_COLOR, clrRoyalBlue);
          if(ExtendTargets == false) {ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(ExtendTargets == true) {ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_RAY, 1);}
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_WIDTH, 2);

          Target2 = (Label3_Price - Label4_Price) + HVF_Axis;

          ObjectDelete("Target2" + UserDefiniedObjectName);
          ObjectCreate("Target2" + UserDefiniedObjectName,OBJ_TREND, 0, Label6_Time, Target2, (Label6_Time - Label1_Time) + Label6_Time, Target2, 0, 0);
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_COLOR, clrCornflowerBlue);
          if(ExtendTargets == false) {ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(ExtendTargets == true) {ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_RAY, 1);}
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_WIDTH, 1.5);

          Target1 = (Label5_Price - Label6_Price) + HVF_Axis;

          ObjectDelete("Target1" + UserDefiniedObjectName);
          ObjectCreate("Target1" + UserDefiniedObjectName,OBJ_TREND, 0, Label6_Time, Target1, (Label6_Time - Label1_Time) + Label6_Time, Target1, 0, 0);
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_COLOR, clrPowderBlue);
          if(ExtendTargets == false) {ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(ExtendTargets == true) {ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_RAY, 1);}
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);


          ObjectDelete("1_3" + UserDefiniedObjectName);
          ObjectCreate("1_3" + UserDefiniedObjectName, OBJ_TREND, 0, Label1_Time, Label1_Price, Label3_Time, Label3_Price, 0, 0);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_COLOR, clrGainsboro);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_SELECTED, false);


          ObjectDelete("2_4" + UserDefiniedObjectName);
          ObjectCreate("2_4" + UserDefiniedObjectName, OBJ_TREND, 0, Label2_Time, Label2_Price, Label4_Time, Label4_Price, 0, 0);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_COLOR, clrGainsboro);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_SELECTED, false);


          ObjectDelete("3_5" + UserDefiniedObjectName);
          ObjectCreate("3_5" + UserDefiniedObjectName, OBJ_TREND, 0, Label3_Time, Label3_Price, Label5_Time, Label5_Price, 0, 0);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_COLOR, clrGainsboro);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_SELECTED, false);


          ObjectDelete("4_6" + UserDefiniedObjectName);
          ObjectCreate("4_6" + UserDefiniedObjectName, OBJ_TREND, 0, Label4_Time, Label4_Price, Label6_Time, Label6_Price, 0, 0);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_COLOR, clrGainsboro);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_SELECTED, false);

 
          ObjectDelete("EntryPoint" + UserDefiniedObjectName);
          ObjectCreate("EntryPoint" + UserDefiniedObjectName, OBJ_TREND, 0, Label5_Time, Label5_Price, ((Label6_Time - Label1_Time)/2) + Label6_Time, Label5_Price, 0, 0);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_COLOR, clrDarkGreen);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          if(Extend_EP_SL == false) {ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(Extend_EP_SL == true)  {ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_RAY, 1);}

          ObjectDelete("StopLoss" + UserDefiniedObjectName);
          ObjectCreate("StopLoss" + UserDefiniedObjectName, OBJ_TREND, 0, Label6_Time, Label6_Price, ((Label6_Time - Label1_Time)/2) + Label6_Time, Label6_Price, 0, 0);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_COLOR, Red);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          if(Extend_EP_SL == false) {ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(Extend_EP_SL == true)  {ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_RAY, 1);}


          if(ShowTimeStops == true)
            {

                  datetime Target1TimeStop;
                  datetime Target2TimeStop;
                  datetime Target3TimeStop;
                    
                  Target1TimeStop = (Label6_Time - Label5_Time) + Label6_Time;
                  Target2TimeStop = (Label6_Time - Label3_Time) + Label6_Time;
                  Target3TimeStop = (Label6_Time - Label1_Time) + Label6_Time;



              // target 1

                  ObjectDelete("Target1TimeStop" + UserDefiniedObjectName);
                  ObjectCreate("Target1TimeStop" + UserDefiniedObjectName, OBJ_TREND, 0, Target1TimeStop, Label5_Price, Target1TimeStop, Target1, 0, 0);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_COLOR, clrPowderBlue);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_RAY, 0);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTED, false);

              // target 2 

                  ObjectDelete("Target2TimeStop" + UserDefiniedObjectName);
                  ObjectCreate("Target2TimeStop" + UserDefiniedObjectName, OBJ_TREND, 0, Target2TimeStop, Target1, Target2TimeStop, Target2, 0, 0);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_COLOR, clrCornflowerBlue);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_WIDTH, 1.5);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_RAY, 0);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTED, false);

              // target 3 

                  ObjectDelete("Target3TimeStop" + UserDefiniedObjectName);
                  ObjectCreate("Target3TimeStop" + UserDefiniedObjectName, OBJ_TREND, 0, Target3TimeStop, Target2, Target3TimeStop, Target3, 0, 0);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_COLOR, clrRoyalBlue);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_WIDTH, 2);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_RAY, 0);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTED, false);

            }


          SL_InPips = Label5_Price - Label6_Price;
          TP_InPips = Target3 - Label5_Price;
          RRR       = TP_InPips / SL_InPips;



            if(ObjectFind("Info" + UserDefiniedObjectName) != -1) ObjectDelete("Info" + UserDefiniedObjectName);
            ObjectCreate("Info" + UserDefiniedObjectName, OBJ_TEXT, 0, 0, 0, 0, 0);

            ObjectSetText("Info" + UserDefiniedObjectName,  

           "Type: Regular"                                           + "\n"    
            //"Stop Loss in Pips: "   + DoubleToStr(SL_InPips * 10, 2)       + "\n"
            //"Take Profit in Pips: " + DoubleToStr(TP_InPips * 10, 2)       + "\n"
            "| RRR: "   + DoubleToStr(RRR, 2)                 + "\n" 
            "| TP: "   + ObjectGet("Target3" + UserDefiniedObjectName, OBJPROP_PRICE1)      + "\n" 
            "| SL: "   + ObjectGet("StopLoss" + UserDefiniedObjectName, OBJPROP_PRICE1)      + "\n" 




            );

            ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_COLOR, Green);
            ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_TIME1, Label6_Time);
            ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_PRICE1, Label2_Price - 100 * Point);
            ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_FONTSIZE, 7);
            ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);


        }

    // inverted hvf
      
      if(Label1_Price < Label2_Price)
        {


//+----------------------------------------------------------------+
//| AdjustLevels section                             |
//+------------------------------------------------------------------+

          if(AdjustLevels == true)
            {
              for(int i = 0; i < iBars(Symbol(), 0); i ++)
                {
                  if(iTime(Symbol(), 0, i) == Label1_Time) 
                    {
                      double PotentialLabel1_Price_Down; double PotentialLabel1_Price_Up;
                      Label1_Price = iLow(Symbol(), 0, i);
             
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel1_Price_Down = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel1_Price_Up = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i - AdjustRange);

                            // PotentialLabel1_Price_Down is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel1_Price_Down) < Label1_Price)
                              if(iLow(Symbol(), 0, PotentialLabel1_Price_Down) < iLow(Symbol(), 0, PotentialLabel1_Price_Up))
                                {
                                  Label1_Price = iLow(Symbol(), 0, PotentialLabel1_Price_Down);
                                  Label1_Time  = iTime(Symbol(), 0, PotentialLabel1_Price_Down);
                                }

                            // PotentialLabel1_Price_Up is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel1_Price_Up) < Label1_Price)
                              if(iLow(Symbol(), 0, PotentialLabel1_Price_Up) < iLow(Symbol(), 0, PotentialLabel1_Price_Down))
                                {
                                  Label1_Price = iLow(Symbol(), 0, PotentialLabel1_Price_Up);
                                  Label1_Time  = iTime(Symbol(), 0, PotentialLabel1_Price_Up);
                                }                          

                            // Label1_Price is the correct one
          
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel1_Price_Down))
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel1_Price_Up))
                                {
                                  Label1_Price = iLow(Symbol(), 0, i);
                                  Label1_Time  = iTime(Symbol(), 0, i);
                                }
                    }
                  
                  if(iTime(Symbol(), 0, i) == Label2_Time) 
                    {

                      double PotentialLabel2_Price_Down; double PotentialLabel2_Price_Up;

                      Label2_Price = iHigh(Symbol(), 0, i);
           
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel2_Price_Down = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel2_Price_Up = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i - AdjustRange);

                            // PotentialLabel2_Price_Down is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel2_Price_Down) > Label2_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel2_Price_Down) > iHigh(Symbol(), 0, PotentialLabel2_Price_Up))
                                {
                                  Label2_Price = iHigh(Symbol(), 0, PotentialLabel2_Price_Down);
                                  Label2_Time  = iTime(Symbol(), 0, PotentialLabel2_Price_Down);
                                }

                            // PotentialLabel2_Price_Up is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel2_Price_Up) > Label2_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel2_Price_Up) > iHigh(Symbol(), 0, PotentialLabel2_Price_Down))
                                {
                                  Label2_Price = iHigh(Symbol(), 0, PotentialLabel2_Price_Up);
                                  Label2_Time  = iTime(Symbol(), 0, PotentialLabel2_Price_Up);
                                }                          

                            // Label2_Price is the correct one
          
                              if(iLow(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel2_Price_Down))
                              if(iLow(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel2_Price_Up))
                                {
                                  Label2_Price = iHigh(Symbol(), 0, i);
                                  Label2_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                  if(iTime(Symbol(), 0, i) == Label3_Time) 
                    {

                      double PotentialLabel3_Price_Down; double PotentialLabel3_Price_Up;
                      Label3_Price = iLow(Symbol(), 0, i);
             
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel3_Price_Down = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel3_Price_Up = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i - AdjustRange);

                            // PotentialLabel3_Price_Down is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel3_Price_Down) < Label3_Price)
                              if(iLow(Symbol(), 0, PotentialLabel3_Price_Down) < iLow(Symbol(), 0, PotentialLabel3_Price_Up))
                                {
                                  Label3_Price = iLow(Symbol(), 0, PotentialLabel3_Price_Down);
                                  Label3_Time  = iTime(Symbol(), 0, PotentialLabel3_Price_Down);
                                }

                            // PotentialLabel3_Price_Up is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel3_Price_Up) < Label3_Price)
                              if(iLow(Symbol(), 0, PotentialLabel3_Price_Up) < iLow(Symbol(), 0, PotentialLabel3_Price_Down))
                                {
                                  Label3_Price = iLow(Symbol(), 0, PotentialLabel3_Price_Up);
                                  Label3_Time  = iTime(Symbol(), 0, PotentialLabel3_Price_Up);
                                }                          

                            // Label3_Price is the correct one
          
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel3_Price_Down))
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel3_Price_Up))
                                {
                                  Label3_Price = iLow(Symbol(), 0, i);
                                  Label3_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                  if(iTime(Symbol(), 0, i) == Label4_Time) 
                    {

                      double PotentialLabel4_Price_Down; double PotentialLabel4_Price_Up;

                      Label4_Price = iHigh(Symbol(), 0, i);
           
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel4_Price_Down = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel4_Price_Up = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i - AdjustRange);

                            // PotentialLabel4_Price_Down is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel4_Price_Down) > Label4_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel4_Price_Down) > iHigh(Symbol(), 0, PotentialLabel4_Price_Up))
                                {
                                  Label4_Price = iHigh(Symbol(), 0, PotentialLabel4_Price_Down);
                                  Label4_Time  = iTime(Symbol(), 0, PotentialLabel4_Price_Down);
                                }

                            // PotentialLabel4_Price_Up is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel4_Price_Up) > Label4_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel4_Price_Up) > iHigh(Symbol(), 0, PotentialLabel4_Price_Down))
                                {
                                  Label4_Price = iHigh(Symbol(), 0, PotentialLabel4_Price_Up);
                                  Label4_Time  = iTime(Symbol(), 0, PotentialLabel4_Price_Up);
                                }                          

                            // Label4_Price is the correct one
          
                              if(iHigh(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel4_Price_Down))
                              if(iHigh(Symbol(), 0, i) > iHigh(Symbol(), 0, PotentialLabel4_Price_Up))
                                {
                                  Label4_Price = iHigh(Symbol(), 0, i);
                                  Label4_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                  if(iTime(Symbol(), 0, i) == Label5_Time) 
                    {

                      double PotentialLabel5_Price_Down; double PotentialLabel5_Price_Up;
                      Label5_Price = iLow(Symbol(), 0, i);
             
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel5_Price_Down = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel5_Price_Up = iLowest(Symbol(), 0, MODE_LOW, AdjustRange, i - AdjustRange);

                            // PotentialLabel5_Price_Down is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel5_Price_Down) < Label5_Price)
                              if(iLow(Symbol(), 0, PotentialLabel5_Price_Down) < iLow(Symbol(), 0, PotentialLabel5_Price_Up))
                                {
                                  Label5_Price = iLow(Symbol(), 0, PotentialLabel5_Price_Down);
                                  Label5_Time  = iTime(Symbol(), 0, PotentialLabel5_Price_Down);
                                }

                            // PotentialLabel5_Price_Up is the correct one

                              if(iLow(Symbol(), 0, PotentialLabel5_Price_Up) < Label5_Price)
                              if(iLow(Symbol(), 0, PotentialLabel5_Price_Up) < iLow(Symbol(), 0, PotentialLabel5_Price_Down))
                                {
                                  Label5_Price = iLow(Symbol(), 0, PotentialLabel5_Price_Up);
                                  Label5_Time  = iTime(Symbol(), 0, PotentialLabel5_Price_Up);
                                }                          

                            // Label5_Price is the correct one
          
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel5_Price_Down))
                              if(iLow(Symbol(), 0, i) < iLow(Symbol(), 0, PotentialLabel5_Price_Up))
                                {
                                  Label5_Price = iLow(Symbol(), 0, i);
                                  Label5_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                  if(iTime(Symbol(), 0, i) == Label6_Time) 
                    {

                      double PotentialLabel6_Price_Down; double PotentialLabel6_Price_Up;

                      Label6_Price = iHigh(Symbol(), 0, i);
           
                        // check the specified range 

                            // check specified ammount of bars DOWN  

                              PotentialLabel6_Price_Down = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i);

                            // check specified ammount of bars UP  

                              PotentialLabel6_Price_Up = iHighest(Symbol(), 0, MODE_HIGH, AdjustRange, i - AdjustRange);

                            // PotentialLabel6_Price_Down is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel6_Price_Down) < Label6_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel6_Price_Down) < iHigh(Symbol(), 0, PotentialLabel6_Price_Up))
                                {
                                  Label6_Price = iHigh(Symbol(), 0, PotentialLabel6_Price_Down);
                                  Label6_Time  = iTime(Symbol(), 0, PotentialLabel6_Price_Down);
                                }

                            // PotentialLabel6_Price_Up is the correct one

                              if(iHigh(Symbol(), 0, PotentialLabel6_Price_Up) < Label6_Price)
                              if(iHigh(Symbol(), 0, PotentialLabel6_Price_Up) < iHigh(Symbol(), 0, PotentialLabel6_Price_Down))
                                {
                                  Label6_Price = iHigh(Symbol(), 0, PotentialLabel6_Price_Up);
                                  Label6_Time  = iTime(Symbol(), 0, PotentialLabel6_Price_Up);
                                }                          

                            // Label6_Price is the correct one
          
                              if(iHigh(Symbol(), 0, i) < iHigh(Symbol(), 0, PotentialLabel6_Price_Down))
                              if(iHigh(Symbol(), 0, i) < iHigh(Symbol(), 0, PotentialLabel6_Price_Up))
                                {
                                  Label6_Price = iHigh(Symbol(), 0, i);
                                  Label6_Time  = iTime(Symbol(), 0, i);
                                }

                    }

                }   

                  color LabelColor = ObjectGet("1" + UserDefiniedObjectName, OBJPROP_COLOR);
                 
                  ObjectDelete("1" + UserDefiniedObjectName);
                  ObjectDelete("2" + UserDefiniedObjectName);
                  ObjectDelete("3" + UserDefiniedObjectName);
                  ObjectDelete("4" + UserDefiniedObjectName);
                  ObjectDelete("5" + UserDefiniedObjectName);
                  ObjectDelete("6" + UserDefiniedObjectName);
                       
                  ObjectCreate("1" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label1_Time, Label1_Price, 0, 0, 0, 0);                 
                  ObjectCreate("2" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label2_Time, Label2_Price, 0, 0, 0, 0);
                  ObjectCreate("3" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label3_Time, Label3_Price, 0, 0, 0, 0);
                  ObjectCreate("4" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label4_Time, Label4_Price, 0, 0, 0, 0);
                  ObjectCreate("5" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label5_Time, Label5_Price, 0, 0, 0, 0);
                  ObjectCreate("6" + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, Label6_Time, Label6_Price, 0, 0, 0, 0);

                  ObjectSet("1" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("2" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("3" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("4" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("5" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  ObjectSet("6" + UserDefiniedObjectName, OBJPROP_COLOR, LabelColor);
                  


            }

//+----------------------------------------------------------------+
//| END of AdjustLevels section                             |
//+------------------------------------------------------------------+



          if(HVF_Axis == 0)
            {
              //HVF_Axis = (Label1_Price + Label2_Price + Label3_Price + Label4_Price + Label5_Price + Label6_Price)/6;
                HVF_Axis = (HVF_Axis = Label5_Price + Label6_Price) / 2;

                ObjectDelete("HVF_Axis" + UserDefiniedObjectName);

                ObjectCreate("HVF_Axis" + UserDefiniedObjectName,OBJ_TREND, 0, Label1_Time, HVF_Axis, Label6_Time + (Label6_Time - Label5_Time), HVF_Axis, 0, 0);
                ObjectSet("HVF_Axis" + UserDefiniedObjectName, OBJPROP_COLOR, clrDarkGoldenrod);
                ObjectSet("HVF_Axis" + UserDefiniedObjectName, OBJPROP_RAY, 0);
                ObjectSet("HVF_Axis" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
            }

          if(HVF_Axis > 0)
            {
              HVF_Axis = ObjectGet("HVF_Axis" + UserDefiniedObjectName, OBJPROP_PRICE1);
            }
            
          Target3 = HVF_Axis - (Label2_Price - Label1_Price);
       
          ObjectDelete("Target3" + UserDefiniedObjectName);
          ObjectCreate("Target3" + UserDefiniedObjectName,OBJ_TREND, 0, Label6_Time, Target3, (Label6_Time - Label1_Time) + Label6_Time, Target3, 0, 0);
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_COLOR, clrRoyalBlue);
          if(ExtendTargets == false) {ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(ExtendTargets == true) {ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_RAY, 1);}
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          ObjectSet("Target3" + UserDefiniedObjectName, OBJPROP_WIDTH, 2);


          Target2 = HVF_Axis - (Label4_Price - Label3_Price);

          ObjectDelete("Target2" + UserDefiniedObjectName);
          ObjectCreate("Target2" + UserDefiniedObjectName,OBJ_TREND, 0, Label6_Time, Target2, (Label6_Time - Label1_Time) + Label6_Time, Target2, 0, 0);
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_COLOR, clrCornflowerBlue);
          if(ExtendTargets == false) {ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(ExtendTargets == true)  {ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_RAY, 1);}
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          ObjectSet("Target2" + UserDefiniedObjectName, OBJPROP_WIDTH, 1.5);


          Target1 = HVF_Axis - (Label6_Price - Label5_Price);

          ObjectDelete("Target1" + UserDefiniedObjectName);
          ObjectCreate("Target1" + UserDefiniedObjectName,OBJ_TREND, 0, Label6_Time, Target1, (Label6_Time - Label1_Time) + Label6_Time, Target1, 0, 0);
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_COLOR, clrPowderBlue);
          if(ExtendTargets == false) {ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(ExtendTargets == true) {ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_RAY, 1);}
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          ObjectSet("Target1" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);


          ObjectDelete("1_3" + UserDefiniedObjectName);
          ObjectCreate("1_3" + UserDefiniedObjectName, OBJ_TREND, 0, Label1_Time, Label1_Price, Label3_Time, Label3_Price, 0, 0);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_COLOR, clrGainsboro);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("1_3" + UserDefiniedObjectName, OBJPROP_SELECTED, false);

          ObjectDelete("2_4" + UserDefiniedObjectName);
          ObjectCreate("2_4" + UserDefiniedObjectName, OBJ_TREND, 0, Label2_Time, Label2_Price, Label4_Time, Label4_Price, 0, 0);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_COLOR, clrGainsboro);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("2_4" + UserDefiniedObjectName, OBJPROP_SELECTED, false);

          ObjectDelete("3_5" + UserDefiniedObjectName);
          ObjectCreate("3_5" + UserDefiniedObjectName, OBJ_TREND, 0, Label3_Time, Label3_Price, Label5_Time, Label5_Price, 0, 0);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_COLOR, clrGainsboro);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("3_5" + UserDefiniedObjectName, OBJPROP_SELECTED, false);

          ObjectDelete("4_6" + UserDefiniedObjectName);
          ObjectCreate("4_6" + UserDefiniedObjectName, OBJ_TREND, 0, Label4_Time, Label4_Price, Label6_Time, Label6_Price, 0, 0);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_COLOR, clrGainsboro);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("4_6" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
 
          ObjectDelete("EntryPoint" + UserDefiniedObjectName);
          ObjectCreate("EntryPoint" + UserDefiniedObjectName, OBJ_TREND, 0, Label5_Time, Label5_Price, ((Label6_Time - Label1_Time)/2) + Label6_Time, Label5_Price, 0, 0);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_COLOR, clrDarkGreen);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          if(Extend_EP_SL == false) {ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(Extend_EP_SL == true)  {ObjectSet("EntryPoint" + UserDefiniedObjectName, OBJPROP_RAY, 1);}

          ObjectDelete("StopLoss" + UserDefiniedObjectName);
          ObjectCreate("StopLoss" + UserDefiniedObjectName, OBJ_TREND, 0, Label6_Time, Label6_Price, ((Label6_Time - Label1_Time)/2) + Label6_Time, Label6_Price, 0, 0);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_COLOR, Red);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_RAY, 0);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
          ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
          if(Extend_EP_SL == false) {ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_RAY, 0);}
          if(Extend_EP_SL == true)  {ObjectSet("StopLoss" + UserDefiniedObjectName, OBJPROP_RAY, 1);}



          if(ShowTimeStops == true)
            {

                  datetime Target1TimeStop;
                  datetime Target2TimeStop;
                  datetime Target3TimeStop;
                    
                  Target1TimeStop = (Label6_Time - Label5_Time) + Label6_Time;
                  Target2TimeStop = (Label6_Time - Label3_Time) + Label6_Time;
                  Target3TimeStop = (Label6_Time - Label1_Time) + Label6_Time;



              // target 1

                  ObjectDelete("Target1TimeStop" + UserDefiniedObjectName);
                  ObjectCreate("Target1TimeStop" + UserDefiniedObjectName, OBJ_TREND, 0, Target1TimeStop, Label5_Price, Target1TimeStop, Target1, 0, 0);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_COLOR, clrPowderBlue);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_WIDTH, 1);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_RAY, 0);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
                  ObjectSet("Target1TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTED, false);

              // target 2 

                  ObjectDelete("Target2TimeStop" + UserDefiniedObjectName);
                  ObjectCreate("Target2TimeStop" + UserDefiniedObjectName, OBJ_TREND, 0, Target2TimeStop, Target1, Target2TimeStop, Target2, 0, 0);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_COLOR, clrCornflowerBlue);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_WIDTH, 1.5);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_RAY, 0);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
                  ObjectSet("Target2TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTED, false);

              // target 3 

                  ObjectDelete("Target3TimeStop" + UserDefiniedObjectName);
                  ObjectCreate("Target3TimeStop" + UserDefiniedObjectName, OBJ_TREND, 0, Target3TimeStop, Target2, Target3TimeStop, Target3, 0, 0);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_COLOR, clrRoyalBlue);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_WIDTH, 2);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_RAY, 0);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTABLE, false);
                  ObjectSet("Target3TimeStop" + UserDefiniedObjectName, OBJPROP_SELECTED, false);
                  
            }



          SL_InPips = Label6_Price - Label5_Price;
          TP_InPips = Label5_Price - Target3;
          RRR       = TP_InPips / SL_InPips;


        if(ObjectFind("Info" + UserDefiniedObjectName ) != -1) ObjectDelete("Info" + UserDefiniedObjectName);
        ObjectCreate("Info" + UserDefiniedObjectName, OBJ_TEXT, 0, 0, 0, 0, 0);

        ObjectSetText("Info" + UserDefiniedObjectName,  

        "Type: Inverted"                                                  + "\n"    
        //"Stop Loss in Pips: "   + DoubleToStr(SL_InPips * 10, 2)       + "\n"
        //"Take Profit in Pips: " + DoubleToStr(TP_InPips * 10, 2)       + "\n"
        "| RRR: "   + DoubleToStr(RRR, 2)                                 + "\n" 
        "| TP: "   + ObjectGet("Target3" + UserDefiniedObjectName, OBJPROP_PRICE1)      + "\n" 
        "| SL: "   + ObjectGet("StopLoss" + UserDefiniedObjectName, OBJPROP_PRICE1)      + "\n" 


        );

        ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_COLOR, clrSalmon);
        ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_TIME1, Label6_Time);
        ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_PRICE1, Label2_Price - 100 * Point);
        ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_FONTSIZE, 7);
        ObjectSet("Info" + UserDefiniedObjectName, OBJPROP_HIDDEN, true);


        }     

  


  }


//+------------------------------------------------------------------+
//| Create Fibonacci Fan by the given coordinates                    |
//+------------------------------------------------------------------+
void FiboFanCreate(const long            chart_ID = 0,              // chart's ID
                   const int             sub_window = 0,            // subwindow index 
                   datetime              time1  = 0 ,               // first point time
                   double                price1 = 0 ,               // first point price
                   datetime              time2  = 0 ,               // second point time
                   double                price2 = 0 ,               // second point price
                   const color           clr    = clrRed,           // fan line color
                   const ENUM_LINE_STYLE style=STYLE_DASHDOT,       // fan line style
                   const int             width=1,                   // fan line width
                   const bool            back=true,                 // in the background
                   const bool            selection=false,           // highlight to move
                   const bool            hidden=true,               // hidden in the object list
                   const long            z_order=0)                 // priority for mouse click212121210001 
  {
//--- set parameters
  
  if(Label4_Price > 0) 
  if(Label5_Time  > 0) 
  if(Label4_Time  > 0) 
  if(Label5_Time  > 0) 
    {

      string name = "FibonacciFan" + UserDefiniedObjectName;
      
      if(FibonacciPoint1 == 1)  {time1 = Label1_Time; price1 = Label1_Price;}
      if(FibonacciPoint1 == 2)  {time1 = Label2_Time; price1 = Label2_Price;}
      if(FibonacciPoint1 == 3)  {time1 = Label3_Time; price1 = Label3_Price;}
      if(FibonacciPoint1 == 4)  {time1 = Label4_Time; price1 = Label4_Price;}
      if(FibonacciPoint1 == 5)  {time1 = Label5_Time; price1 = Label5_Price;}
      if(FibonacciPoint1 == 6)  {time1 = Label6_Time; price1 = Label6_Price;}

      if(FibonacciPoint2 == 1)  {time2 = Label1_Time; price2 = Label1_Price;}
      if(FibonacciPoint2 == 2)  {time2 = Label2_Time; price2 = Label2_Price;}
      if(FibonacciPoint2 == 3)  {time2 = Label3_Time; price2 = Label3_Price;}
      if(FibonacciPoint2 == 4)  {time2 = Label4_Time; price2 = Label4_Price;}
      if(FibonacciPoint2 == 5)  {time2 = Label5_Time; price2 = Label5_Price;}
      if(FibonacciPoint2 == 6)  {time2 = Label6_Time; price2 = Label6_Price;}


    //--- reset the error value
       ResetLastError();
    //--- create Fibonacci Fan by the given coordinates
       if(!ObjectCreate(chart_ID,name,OBJ_FIBOFAN,sub_window,time1,price1,time2,price2))
         {
          Print(__FUNCTION__,
                ": failed to create \"Fibonacci Fan\"! Error code = ",GetLastError());
          
         }
    //--- set color

       ObjectSet(name, OBJPROP_COLOR, ObjectGet("4" + UserDefiniedObjectName, OBJPROP_COLOR));
       ObjectSet(name, OBJPROP_LEVELCOLOR, ObjectGet("4" + UserDefiniedObjectName, OBJPROP_COLOR));


    //--- set line style
       ObjectSetInteger(chart_ID,name,OBJPROP_STYLE,style);
       
    //--- set line width
       ObjectSetInteger(chart_ID,name,OBJPROP_WIDTH,width);
    //--- display in the foreground (false) or background (true)
       ObjectSetInteger(chart_ID,name,OBJPROP_BACK,back);
    //--- enable (true) or disable (false) the mode of highlighting the fan for moving
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
       
       
       

    }

    else 
      {
        Alert("Error creating Fibonacci Fans. Required value(s) have value(s) of: Label4_Time: ", 
        Label4_Time, " Label4_Price: ", Label4_Price, " Label5_Time: ", Label5_Time, " Label5_Price: ", 
        Label5_Price);
        
      }

   //--- trendline        

     if(FibonacciPoint1 == 4) // recommended 1
      if(FibonacciPoint2 == 5) // recommended 1
         {
           if(Label5_Price > Label6_Price) // bullish
             {                    
                double FibLevel = ((Label5_Price - Label4_Price) * 0.382) + Label4_Price;  
                ObjectDelete(0, "trendline" + UserDefiniedObjectName);
                ObjectCreate("trendline" + UserDefiniedObjectName, OBJ_TREND, 0, Label4_Time, Label4_Price, Label5_Time, FibLevel, 0, 0);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_RAY, 1);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_WIDTH, 2); 
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_COLOR, Color);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_SELECTABLE, 0);
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_SELECTED, 0);
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
                   
             }
           if(Label5_Price < Label6_Price) // bearish
             {                    
                double FibLevel = ((Label5_Price - Label4_Price) * 0.382) + Label4_Price;  
                ObjectDelete(0, "trendline" + UserDefiniedObjectName);
                ObjectCreate("trendline" + UserDefiniedObjectName, OBJ_TREND, 0, Label4_Time, Label4_Price, Label5_Time, FibLevel, 0, 0);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_RAY, 1);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_WIDTH, 2); 
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_COLOR, Color);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_SELECTABLE, 0);
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_SELECTED, 0);
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
                   
             }          
         }

      if(FibonacciPoint1 == 2) // recommended 2
      if(FibonacciPoint2 == 3) // recommended 2
         {
           if(Label5_Price > Label6_Price) // bullish
             {                    
                double FibLevel = ((Label3_Price - Label2_Price) * 0.382) + Label2_Price;  
                ObjectDelete(0, "trendline" + UserDefiniedObjectName);
                ObjectCreate("trendline" + UserDefiniedObjectName, OBJ_TREND, 0, Label2_Time, Label2_Price, Label3_Time, FibLevel, 0, 0);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_RAY, 1);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_WIDTH, 2); 
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_COLOR, Color);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_SELECTABLE, 0);
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_SELECTED, 0);
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
                   
             }
           if(Label5_Price < Label6_Price) // bearish
             {                    
                double FibLevel = ((Label3_Price - Label2_Price) * 0.382) + Label2_Price;  
                ObjectDelete(0, "trendline" + UserDefiniedObjectName);
                ObjectCreate("trendline" + UserDefiniedObjectName, OBJ_TREND, 0, Label2_Time, Label2_Price, Label3_Time, FibLevel, 0, 0);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_RAY, 1);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_WIDTH, 2); 
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_COLOR, Color);  
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_SELECTABLE, 0);
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_SELECTED, 0);
                ObjectSet("trendline" + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
                   
             }          
         }


  

   //--- 
  
  }


//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+

int NumberOfLabels; 

void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//--- Show the event parameters on the chart
   //Comment(__FUNCTION__,": id=",id," lparam=",lparam," dparam=",dparam," sparam=",sparam);
//--- If this is an event of a mouse click on the chart
   if(Draw_Type == 1)
   if(id==CHARTEVENT_CLICK)
     {
      //--- Prepare variables
      int      x     =(int)lparam;
      int      y     =(int)dparam;
      datetime dt    =0;
      double   price =0;
      int      window=0;
      //--- Convert the X and Y coordinates in terms of date/time
      if(ChartXYToTimePrice(0,x,y,window,dt,price))
        {
         //PrintFormat("Window=%d X=%d  Y=%d  =>  Time=%s  Price=%G",window,x,y,TimeToString(dt),price);
         //--- Perform reverse conversion: (X,Y) => (Time,Price)
         if(ChartTimePriceToXY(0,window,dt,price,x,y))
          {
             //PrintFormat("Time=%s  Price=%G  =>  X=%d  Y=%d",TimeToString(dt),price,x,y);
             
   
             if(NumberOfLabels == 6) {NumberOfLabels = 0;}

                NumberOfLabels ++;

                ObjectCreate(DoubleToStr(NumberOfLabels, 0) + UserDefiniedObjectName, OBJ_ARROW_LEFT_PRICE, 0, dt, price, 0, 0, 0, 0);
                ObjectSet(DoubleToStr(NumberOfLabels, 0) + UserDefiniedObjectName, OBJPROP_COLOR, Color);

             if(NumberOfLabels == 6) 
              {
                DrawHvf();
                if(DrawFibonacciFans == true) {FiboFanCreate();}   
                LabelsWereSet = true; 
                                
/*
                ObjectSet(1 + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
                ObjectSet(2 + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
                ObjectSet(3 + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
                ObjectSet(4 + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
                ObjectSet(5 + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
                ObjectSet(6 + UserDefiniedObjectName, OBJPROP_HIDDEN, 1);
*/
              }


          }

         else
            //Print("ChartTimePriceToXY return error code: ",GetLastError());
         //--- delete lines
         //ObjectDelete(0,"V Line");
         //ObjectDelete(0,"H Line");
         //--- create horizontal and vertical lines of the crosshair
         //ObjectCreate(0,"H Line",OBJ_HLINE,window,dt,price);
         //ObjectCreate(0,"V Line",OBJ_VLINE,window,dt,price);
         ChartRedraw(0);
        }
      //else
         //Print("ChartXYToTimePrice return error code: ",GetLastError());
      //rint("+--------------------------------------------------------------+");
     }

    //--- the object has been moved or its anchor point coordinates has been changed
       if(id==CHARTEVENT_OBJECT_DRAG)
        {
          //Alert("The anchor point coordinates of the object with name ",sparam," has been changed");
          DrawHvf();
          if(DrawFibonacciFans == true) {FiboFanCreate();}   

        }

  }

