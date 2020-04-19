class RoutePaths {
  static const String Login = 'login';
  static const String Home = '/';
  static const String Notifications = 'notifications';
  static const String UserProfile = 'userprofile';
  static const String Search = 'search';
}

class Errors {
  static const String UpdateUserProfile =
      "Error updating user profile. Please try again";
  static const String UsernameAlreadyExists = "Username already exists";
  static const String InvalidUsernameOrPassword =
      "Invalid username or password";
  static const String FindingUsers = "Error finding users. Please try again";
  static const String NoResultsFoundFor = "No results found for ";
}

class FriendshipStatusCode {
  static const int Requested = 0;
  static const int Accepted = 1;
  static const int Declined = 2;
  static const int Blocked = 3;
}
