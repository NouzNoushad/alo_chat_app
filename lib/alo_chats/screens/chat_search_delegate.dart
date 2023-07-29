import 'package:alo_chat_app/alo_chats/screens/chats_list.dart';
import 'package:alo_chat_app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/colors.dart';
import '../../widgets/loading_indicator.dart';
import '../cubit/alo_chats_cubit.dart';

class AloChatSearchDelegate extends SearchDelegate {
  final SearchType searchType;
  AloChatSearchDelegate({required this.searchType});

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: const AppBarTheme(
        color: CustomColors.backgroundColor1,
      ),
      hintColor: CustomColors.backgroundColor2,
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: CustomColors.backgroundColor2,
      ),
      inputDecorationTheme:
          const InputDecorationTheme(focusedBorder: InputBorder.none),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: CustomColors.backgroundColor2,
          decorationThickness: 0.0000001,
        ),
      ),
    );
  }

  @override
  String? get searchFieldLabel => 'Search name or number';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(FontAwesomeIcons.xmark, size: 18),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(FontAwesomeIcons.arrowLeft, size: 18),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var chatsCubit = BlocProvider.of<AloChatsCubit>(context);
    chatsCubit.searchAllChats(query);
    return searchType == SearchType.allChats
        ? searchAllChatMembers(chatsCubit)
        : searchChatMembers(chatsCubit);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var chatsCubit = BlocProvider.of<AloChatsCubit>(context);
    chatsCubit.searchAllChats(query);
    return searchType == SearchType.allChats
        ? searchAllChatMembers(chatsCubit)
        : searchChatMembers(chatsCubit);
  }

  Widget searchAllChatMembers(AloChatsCubit chatsCubit) {
    return Material(
      color: CustomColors.backgroundColor2,
      child:
          BlocBuilder<AloChatsCubit, AloChatsState>(builder: (context, state) {
        return StreamBuilder(
            stream: chatsCubit.searchAllChatStream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const CustomLoadingIndicator();
              }
              if (snapshot.data.length <= 0) {
                return const Center(
                  child: Text('No results found'),
                );
              }
              return ChatsList(
                snapshot: snapshot.data,
                chatType: ChatType.search,
              );
            });
      }),
    );
  }

  Widget searchChatMembers(AloChatsCubit chatsCubit) {
    return Material(
      color: CustomColors.backgroundColor2,
      child: FutureBuilder(
          future: chatsCubit.searchChats(query),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CustomLoadingIndicator();
            }
            if (snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No results found'),
              );
            }
            return ChatsList(
              snapshot: snapshot.data!,
              chatType: ChatType.search,
            );
          }),
    );
  }
}
