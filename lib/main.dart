import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobizapp/Pages/Attendance.dart';
import 'package:mobizapp/Pages/CustomerVisit.dart';
import 'package:mobizapp/Pages/DayClose.dart';
import 'package:mobizapp/Pages/ExpensesPage.dart';
import 'package:mobizapp/Pages/VIsitsPage.dart';
import 'package:mobizapp/Pages/customerdetailscreen.dart';
import 'package:mobizapp/Pages/customerregistration.dart';
import 'package:mobizapp/Pages/customerscreen.dart';
import 'package:mobizapp/Pages/homepage.dart';
import 'package:mobizapp/Pages/loginpage.dart';
import 'package:mobizapp/Pages/offLoadRequest.dart';
import 'package:mobizapp/Pages/paymentcollection.dart';
import 'package:mobizapp/Pages/productspage.dart';
import 'package:mobizapp/Pages/receiptscreen.dart';
import 'package:mobizapp/Pages/salesscreen.dart';
import 'package:mobizapp/Pages/selectProducts.dart';
import 'package:mobizapp/Pages/splashscreen.dart';
import 'package:mobizapp/Pages/newvanstockrequests.dart';
import 'package:mobizapp/Pages/vanselectproduct.dart';
import 'package:mobizapp/Pages/vanstockdata.dart';
import 'package:mobizapp/Pages/vanstockrequest.dart';
import 'package:mobizapp/printtst.dart';
import 'package:mobizapp/sales_screen.dart';
import 'package:mobizapp/vanstocktst.dart';
import 'package:mobizapp/vanstockselactpro_tst.dart';
import 'package:mobizapp/selectproduct.dart';
import 'Pages/CustomeSOA.dart';
import 'Pages/Day_closeReport.dart';
import 'Pages/DriverDetailsPage.dart';
import 'Pages/DriverPage.dart';
import 'Pages/Driver_customer_detail_screen.dart';
import 'Pages/Driver_paymentCollection.dart';
import 'Pages/Expense_add.dart';
import 'Pages/Delivery_details_driver.dart';
import 'Pages/Schedule_page.dart';
import 'Pages/Total_sales.dart';
import 'Pages/VanTransferReceive.dart';
import 'Pages/VanTransferSend.dart';
import 'Pages/VanTransfer_option.dart';
import 'Pages/VanTransfetConfirm.dart';
import 'Pages/customerorderdetail.dart';
import 'Pages/customerreturndetails.dart';
import 'Pages/driver_customer_screen.dart';
import 'Pages/error_handling_screen.dart';
import 'Pages/homeorder.dart';
import 'Pages/homepage_Driver.dart';
import 'Pages/homereturn.dart';
import 'Pages/saleinvoices.dart';
import 'Pages/salesselectproductorder.dart';
import 'Pages/salesselectproductreturn.dart';
import 'Pages/salesselectproducts.dart';
import 'Pages/schedule_Driver.dart';
import 'Pages/selectProductScreenOFF.dart';
import 'Pages/van_transfer.dart';
import 'Pages/vanstockoff.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          // home: Check(),
          initialRoute: SplashScreen.routeName,
          routes: {
            // '/': (context) => Home(),
            LoginScreen.routeName: (context) => const LoginScreen(),
            Driver_PaymentCollectionScreen.routeName: (context) =>
                Driver_PaymentCollectionScreen(),
            TotalSales.routeName: (context) => const TotalSales(),
            VantransferOption.routeName: (context) => const VantransferOption(),
            driver_customer_screen.routeName: (context) =>
                const driver_customer_screen(),
            HomeScreen.routeName: (context) => const HomeScreen(),
            DeliveryDetailsDriver.routeName: (context) =>
                const DeliveryDetailsDriver(),
            Driver_customer_detail_screen.routeName: (context) =>
                const Driver_customer_detail_screen(),
            HomepageDriver.routeName: (context) => const HomepageDriver(),
            ProductsScreen.routeName: (context) => ProductsScreen(),
            ErrorHandlingScreen.routeName: (context) =>
                const ErrorHandlingScreen(),
            VanStockRequestsScreen.routeName: (context) =>
                const VanStockRequestsScreen(),
            VanStocks.routeName: (context) => VanStocks(),
            SplashScreen.routeName: (context) => const SplashScreen(),
            SelectProductsScreen.routeName: (context) => SelectProductsScreen(),
            CustomersDataScreen.routeName: (context) =>
                const CustomersDataScreen(),
            SalesScreen.routeName: (context) => SalesScreen(),
            VanStockScreen.routeName: (context) => const VanStockScreen(),
            SchedulePage.routeName: (context) => const SchedulePage(),
            CustomerDetailsScreen.routeName: (context) =>
                const CustomerDetailsScreen(),
            SalesSelectProductsScreen.routeName: (context) =>
                SalesSelectProductsScreen(),
            SaleInvoiceScrreen.routeName: (context) =>
                const SaleInvoiceScrreen(),
            DaycloseReport.routeName: (context) => const DaycloseReport(),
            SalesSelectProductsorderScreen.routeName: (context) =>
                SalesSelectProductsorderScreen(),
            Salesselectproductreturn.routeName: (context) =>
                Salesselectproductreturn(),
            PaymentCollectionScreen.routeName: (context) =>
                PaymentCollectionScreen(),
            CustomerRegistration.routeName: (context) =>
                const CustomerRegistration(),
            ReceiptScreen.receiptScreen: (context) => const ReceiptScreen(),
            HomeorderScreen.routeName: (context) => HomeorderScreen(),
            VanTransfer.routeName: (context) => VanTransfer(),
            HomereturnScreen.routeName: (context) => HomereturnScreen(),
            Customerorderdetail.routeName: (context) => Customerorderdetail(),
            Customerreturndetail.routeName: (context) => Customerreturndetail(),
            Visitspage.routeName: (context) => Visitspage(),
            Expensespage.routeName: (context) => Expensespage(),
            Dayclose.routeName: (context) => Dayclose(),
            Attendance.routeName: (context) => Attendance(),
            SOA.routeName: (context) => SOA(),
            CustomerVisit.routeName: (context) => CustomerVisit(),
            ExpenseAdd.routeName: (context) => ExpenseAdd(),
            OffLoadRequestScreen.routeName: (context) => OffLoadRequestScreen(),
            VanStocksoff.routeName: (context) => VanStocksoff(),
            SelectProductsScreenoff.routeName: (context) =>
                SelectProductsScreenoff(),
            Vanselectproducts.routeName: (context) => Vanselectproducts(),
            VanTransferSend.routeName: (context) => VanTransferSend(),
            VanTransferConfirm.routeName: (context) => VanTransferConfirm(),
            VanStockReceive.routeName: (context) => VanStockReceive(),
            ScheduleDriver.routeName: (context) => ScheduleDriver(),
            DriverPage.routeName: (context) => DriverPage(),
            DriverDetails.routeName: (context) => DriverDetails(),
          }),
    );
  }
}
