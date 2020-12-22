import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_web_app/main.dart';

import 'enums.dart';

getPopupMenuItems(BuildContext context) {
  return <PopupMenuEntry<ArticleActions>>[
    const PopupMenuItem<ArticleActions>(
      value: ArticleActions.removeAll,
      child: Text('Odstranit vše'),
    ),
    const PopupMenuItem<ArticleActions>(
      value: ArticleActions.readAll,
      child: Text('Označit vše jako přečtené'),
    ),
    const PopupMenuItem<ArticleActions>(
      value: ArticleActions.downloadNews,
      child: Text('Stáhnout nové články'),
    ),
    PopupMenuItem<ArticleActions>(
      value: ArticleActions.sort,
      child: Text(context
          .read(feedsProvider)
          .sort == Sort.newToOld
          ? 'Řadit od nejnovějších'
          : 'Řadit od nejstarších'),
    ),
  ];
}