import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_web_app/main.dart';

import 'enums.dart';

getPopupMenuItems(BuildContext context, {isPositioned = false}) {
  return <PopupMenuEntry<ArticleActions>>[
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
    const PopupMenuItem<ArticleActions>(
      value: ArticleActions.readAll,
      child: Text('Označit vše jako přečtené'),
    ),
    if (isPositioned)
      const PopupMenuItem<ArticleActions>(
        value: ArticleActions.readAllUp,
        child: Text('Označit nahoru jako přečtené'),
      ),
    if (isPositioned)
      const PopupMenuItem<ArticleActions>(
        value: ArticleActions.readAllDown,
        child: Text('Označit dolů jako přečtené'),
      ),
    if (!isPositioned)
      const PopupMenuItem<ArticleActions>(
        value: ArticleActions.unreadAll,
        child: Text('Označit vše jako nepřečtené'),
      ),
    const PopupMenuItem<ArticleActions>(
      value: ArticleActions.removeAllRead,
      child: Text('Odstranit již přečtené'),
    ),
  ];
}