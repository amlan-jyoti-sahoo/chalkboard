import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AppCacheManager {
  static final profilecacheManager = CacheManager(
    Config('profileCatchKey',
        stalePeriod: Duration(days: 30), maxNrOfCacheObjects: 1),
  );

  static void deleteProfilecache() async {
    profilecacheManager.emptyCache();
  }

  static final documentCacheManager = CacheManager(
    Config('documentCacheKey',
        stalePeriod: Duration(days: 60), maxNrOfCacheObjects: 20),
  );
}
