class Api {
  static String get baseUrl {
    return "https://realtyinvestnetwork.com/office/app";
  }

  static const changePassword = "/changepassword.php";
  static const downlines = "/downlines.php";
  static const earningHistory = "/earninghistory.php";
  static const editProfile = "/editprofile.php";
  static const forgotPassword = "/forgotpassword.php";
  static const indirectSales = "/indirectsales.php";
  static const login = "/login.php";
  static const register = "/signup.php";
  static const refLink = "/referrallink.php";
  static const salesBonus = "/salesbonus.php";
  static const walletBalance = "/walletbalance.php";
  static const withdrawalHistory = "/withdrawalhistory.php";
  static const withdrawFunds = "/withdrawfunds.php";
  static const activate = "/activation.php";
  static const downlinesDetails = "/downlinesdetails.php";
  static const getProfilePics = "/getprofilepics.php";
  static const addFund = "/fundnow.php";
  static const fundingHistory = "/fundinghistory.php";
  static const changeProfilePics = "/changeprofilepics.php";
  static const contactSupport = "/contactsupport.php";
  static const supportRequests = "/supportmessages.php";
  static const fundOnline = "/fundonline.php";

  static const contributions = "/contribution.php";
  static const rejectedSales = "/rejectedsales.php";
  static const pendingEarning = "/pendingearning.php";
  static const approvedEarning = "/approvedearning.php";
  static const upgrade = "/upgrade.php";
  static const submitSale = "/sumbitasale.php";
  static const viewProperties = "/viewproperties.php";
  static const bankDetails = "/bankdetails.php";
  static const mtype = "/mtype.php";
  static const getEmail = "/getemail.php";
  static const loadData = "/loadprofile.php";
  static const newContributions = "/newcontribution.php";
  static const completedContributions = "/completedcontributions.php";
  static const contribute = "/contribute.php";
  static const activeContributions = "/activecontribution.php";

  // Other pages

  static String get inappSupport {
    final webUrl = baseUrl.replaceAll('/api', '');
    return "$webUrl/support/chat";
  }
}
