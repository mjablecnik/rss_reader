
import 'package:flutter/material.dart';
import 'package:flutter_web_app/models/feed.dart';

import '../main.dart';


BoxDecoration buildItemDecoration(Feed feed) {
  return BoxDecoration(
      shape: BoxShape.circle,
      image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(
              feed.imageUrl != null ? feed.imageUrl : defaultImageUrl
          )
      )
  );
}
