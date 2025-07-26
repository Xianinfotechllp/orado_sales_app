// main.dart
import 'package:demo/presentation/leave/controller/leave_controller.dart';
import 'package:demo/presentation/letters/controller/letter_controller.dart';
import 'package:demo/presentation/notification_fcm/controller/notification_get_controlller.dart';
import 'package:demo/presentation/notification_fcm/service/fcm_service.dart';
import 'package:demo/presentation/screens/auth/provider/login_reg_provider.dart';
import 'package:demo/presentation/screens/auth/provider/upload_selfi_controller.dart';
import 'package:demo/presentation/screens/auth/provider/user_provider.dart';
import 'package:demo/presentation/screens/earnings/provider/earning_provider.dart';
import 'package:demo/presentation/screens/home/homeview/provider/home_provider.dart';
import 'package:demo/presentation/screens/orders/provider/order_details_provider.dart';
import 'package:demo/presentation/screens/orders/provider/order_provider.dart';
import 'package:demo/presentation/screens/orders/provider/order_response_controller.dart';
import 'package:demo/presentation/screens/home/provider/available_provider.dart';
import 'package:demo/presentation/screens/home/provider/drawer_controller.dart';
import 'package:demo/presentation/socket_io/socket_controller.dart';
import 'package:demo/presentation/splash_Screen/splash_screen.dart';
import 'package:demo/services/api_services.dart';
import 'package:demo/services/navigation_service.dart';
import 'package:demo/services/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/routes/app_routes.dart' as route;

// Declare the SocketController instance globally or as a singleton
late SocketController globalSocketController;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var token = sharedPreferences.getString("token");

  if (token != null) {
    APIServices.headers.addAll({'Authorization': 'Bearer $token'});
    print(APIServices.headers);
  }

  // Initialize the global SocketController
  globalSocketController = SocketController();

  try {
    await globalSocketController.connectSocket();
    debugPrint('Socket connected successfully from main');
  } catch (e) {
    debugPrint('Socket connection error from main: $e');
  }

  // ✅ Initialize FCMHandler and call initialize() to send token
  final fcmHandler = FCMHandler();
  await fcmHandler
      .initialize(); // <-- This sets up FCM and sends token to server

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
        ChangeNotifierProvider<EarningsProvider>(
          create: (_) => EarningsProvider(),
        ),
        ChangeNotifierProvider<AgentHomeProvider>(
          create: (_) => AgentHomeProvider(),
        ),
        ChangeNotifierProvider<AgentProvider>(create: (_) => AgentProvider()),
        ChangeNotifierProvider<DrawerProvider>(create: (_) => DrawerProvider()),
        ChangeNotifierProvider<AgentAvailableController>(
          create: (_) => AgentAvailableController(),
        ),
        ChangeNotifierProvider<SocketController>.value(
          value: globalSocketController,
        ),
        ChangeNotifierProvider<OrderController>(
          create: (_) => OrderController(),
        ),
        ChangeNotifierProvider<OrderDetailController>(
          create: (_) => OrderDetailController(),
        ),
        ChangeNotifierProvider<NotificationController>(
          create: (_) => NotificationController(),
        ),
        ChangeNotifierProvider<AgentOrderResponseController>(
          create: (_) => AgentOrderResponseController(),
        ),
        ChangeNotifierProvider<AgentHomeProvider>(
          create: (_) => AgentHomeProvider(),
        ),
        ChangeNotifierProvider<SelfieUploadController>(
          create: (_) => SelfieUploadController(),
        ),
        ChangeNotifierProvider<LetterController>(
          create: (_) => LetterController(),
        ),
        ChangeNotifierProvider<LeaveController>(
          create: (_) => LeaveController(),
        ),
      ],
      child: const MyApp(),
    ),
  );

  // ✅ Run FCM NotificationService initialization after UI renders
  WidgetsBinding.instance.addPostFrameCallback((_) {
    NotificationService.initialize(
      NavigationService.navigatorKey.currentContext!,
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ORADO Delivery',
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      // routerConfig: route.router,
      home: const SplashScreen(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}
