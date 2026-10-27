
class UserSession {
  static String email = '';

  static String get name {
    if (email.isEmpty) {
      return 'User';
    }

    String username = email.split('@').first;
    username = username.replaceAll(RegExp(r'[._-]+'), ' ');

    return username
        .split(' ')
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}
