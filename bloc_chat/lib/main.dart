import 'package:bloc_chat/repository/auth_repo.dart';
import 'package:bloc_chat/repository/chatsHistoryRepo.dart';
import 'package:bloc_chat/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web_socket_channel/html.dart';
import 'bloc/authentication/authentication_bloc.dart';
import 'bloc/chat/chat_bloc.dart';
import 'bloc/chatList/chat_list_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'repository/Userrepository.dart';
import 'repository/chatRepo.dart';
import 'screens/ChatListScreen.dart';
import 'screens/chat_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(UserDataAdapter());
  await Hive.initFlutter();
  // await Hive.openBox<ChatMessage>('conversationBox');

  // Register the Hive close callback
  WidgetsBinding.instance?.addObserver(HiveCloseObserver());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final WebSocketChannel channel = IOWebSocketChannel.connect("ws://echo.websocket.org");
    WebSocketChannel connectWebSocket(String url) {
      if (kIsWeb) {
        return HtmlWebSocketChannel.connect(url);
      } else {
        return IOWebSocketChannel.connect(url);
      }
    }
    final WebSocketChannel channel = connectWebSocket("wss://echo.websocket.org");

    final ChatBloc chatBloc = ChatBloc(channel: channel, userId: '');
    final ChatRepository chatRepository = ChatRepository();
    final UserRepository userRepository = UserRepository();

    return FutureBuilder(
      future: userRepository.init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final ChatListBloc chatListBloc = ChatListBloc(chatRepository: chatRepository);
          final UserBloc userBloc = UserBloc(userRepository: userRepository);
          final AuthenticationBloc authenticationBloc = AuthenticationBloc();

          return MultiBlocProvider(
            providers: [
              BlocProvider<AuthenticationBloc>(create: (context) => authenticationBloc, ),
              BlocProvider<ChatBloc>(create: (context) => chatBloc),
              BlocProvider<ChatListBloc>(create: (context) => chatListBloc),
              BlocProvider<UserBloc>(create: (context) => userBloc), // Provide UserBloc
            ],
            child: MaterialApp(
              initialRoute: '/',
              routes: {
                '/': (context) => LoginScreen(), // Change the initial route to '/
                '/chatList': (context) => ChatUserList(),
                '/chat': (context) => ChatScreen(userId: ''),
              },
            ),
          );
        } else {
          return const CircularProgressIndicator.adaptive(); // Show a loading spinner while waiting
        }
      },
    );
  }
}
class HiveCloseObserver extends WidgetsBindingObserver {
  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print("App in inactive state");
        break;
      case AppLifecycleState.paused:
        print("App in paused state");
        await Hive.close();
        break;
      case AppLifecycleState.resumed:
        print("App in resumed state");
        await Hive.initFlutter();
        break;
      case AppLifecycleState.detached:
        print("App in detached state");
        await Hive.close();
        break;
      case AppLifecycleState.hidden:
      // TODO: Handle this case.
    }
  }

}


