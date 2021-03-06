class EndPoints {
  // Auth
  static const String login = '/auth/sign-in';
  static const String register = '/auth/sign-up';

  // Files
  static const String upload = '/files';

  // Search
  static const String getSimilar = '/search/sims';
  static const String getSearchResult = '/search';
  static const String textToImage = '/search/t2im';
  static const String imageToImage = '/search/im2im';
  static const String recommendations = '/search/recommendations';

  // Backup
  static const String getServerImages = '/files';
  // static const String download = '/files/:filename';
}
