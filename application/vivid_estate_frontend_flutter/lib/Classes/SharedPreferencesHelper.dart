import 'package:shared_preferences/shared_preferences.dart';

// Helps to Perform Function in Shared Preferences
class SharedPreferencesHelper {
  // Class Variables
  late SharedPreferences
      userLocalPrefs; // Store And Get Data from Shared Preferences

  // Important Auth Information of the User
  late String privateKey;
  late String emailAddress;
  late String userType;
  var isLogin;

  SharedPreferencesHelper() {
    loadSharedPreferences();
    loadAuthData();
  }

  // Load The Shared Preferences in Our Class
  void loadSharedPreferences() async {
    userLocalPrefs = await SharedPreferences.getInstance();
  }

  // Store User Data in Shared Preferences
  void storeUserData(String emailAddress, String privateKey, String userType,
      String profilePictureLocation, String password) async {
    // Store the Data
    userLocalPrefs.setBool("isLogin", true);
    userLocalPrefs.setString("userEmail", emailAddress);
    userLocalPrefs.setString("privateKey", privateKey);
    userLocalPrefs.setString("userType", userType);
    userLocalPrefs.setString("profilePic", profilePictureLocation);
    userLocalPrefs.setString("password", password);
  }

  // Load Authentication Data from Shared Preferences
  void loadAuthData() async {
    // Get the User Information if Already Login
    emailAddress = userLocalPrefs.getString("userEmail")!;
    privateKey = userLocalPrefs.getString("privateKey")!;
    userType = userLocalPrefs.getString("userType")!;
    isLogin = userLocalPrefs.getBool("isLogin")!;
  }

  // Clear Shared Preferences of the Device
  void clearSharedPreferences() {
    // Clear all the local data
    userLocalPrefs.clear();
  }
}
