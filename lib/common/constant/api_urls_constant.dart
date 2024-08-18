import 'package:longa_lotto/utils/user_info.dart';

enum BaseUrlEnum{cashierBaseUrl, ramBaseUrl, weaverBaseUrl, bonusBaseUrl, dgeBaseUrl, igeBaseUrl, profileImageBaseUrl, webViewBaseUrl, webViewGameUrl}

Map<BaseUrlEnum, String> baseUrlMap = {
  // UAT
  BaseUrlEnum.cashierBaseUrl : "https://uat-cashier-backend.longagames.com",
  BaseUrlEnum.ramBaseUrl     : "https://uat-ram-backend.longagames.com",
  BaseUrlEnum.weaverBaseUrl  : "https://uat-api.longagames.com",
  BaseUrlEnum.bonusBaseUrl   : "https://uat-bonus-backend.longagames.com",
  //TODO need to change below url
  BaseUrlEnum.dgeBaseUrl     : "https://uat-dms.longagames.com",
  BaseUrlEnum.igeBaseUrl     : "https://uat-games.longagames.com",
  BaseUrlEnum.webViewBaseUrl : "https://uat.longagames.com",
  BaseUrlEnum.webViewGameUrl : "https://uat-games.longagames.com",

  BaseUrlEnum.profileImageBaseUrl : UserInfo.registrationResponse?.playerLoginInfo?.commonContentPath ?? "",
  // PROD
/*
  BaseUrlEnum.cashierBaseUrl : "https://cashier-backend.longagames.com",
  BaseUrlEnum.ramBaseUrl     : "https://ram-backend.longagames.com",
  BaseUrlEnum.weaverBaseUrl  : "https://api.longagames.com",
  BaseUrlEnum.bonusBaseUrl   : "https://bonus-backend.longagames.com",
  //TODO need to change below url
  BaseUrlEnum.dgeBaseUrl     : "https://dms.longagames.com",
  BaseUrlEnum.igeBaseUrl     : "https://games.longagames.com",
  BaseUrlEnum.webViewBaseUrl : "https://www.longagames.com",
  BaseUrlEnum.webViewGameUrl : "https://games.longagames.com",

  BaseUrlEnum.profileImageBaseUrl : UserInfo.registrationResponse?.playerLoginInfo?.commonContentPath ?? "",
*/

};

class ApiUrlsConstant {
  /* GAMES URL */

  static const FETCH_DGE_GAME_URL           = "/DMS/dataMgmt/fetchGameData";
  static const FETCH_IGE_GAME_URL           = "/api/ige/fetchmatchlist";

  /* RAM */
  static const sendRegOtpUrl                = "/preLogin/sendRegOtp";
  static const registrationUrl              = "/preLogin/registerPlayer";
  static const loginUrl                     = "/preLogin/playerLogin";
  static const overallUpdatePlayerProfile   = "/postLogin/overallUpdatePlayerProfile";
  static const sendVerificationEmailLinkUrl = "/postLogin/sendVerficationEmailLink";
  static const verifyEmailWithOtpUrl        = "/postLogin/verifyEmailWithOtp";
  //https://uat-ram-backend.longagames.com/preLogin/registerPlayerWithOtp
  static const registerPlayerWithScannerUrl = "/preLogin/registerPlayerWithOtp";

  /* WEAVER */
  static const forgotPasswordUrl            = "/Weaver/service/rest/forgotPassword";
  static const resetPasswordUrl             = "/Weaver/service/rest/resetPassword";
  static const changePasswordUrl            = "/Weaver/service/rest/changePassword";
  static const getTicketListUrl             = "/Weaver/service/rest/ticketDetails";
  static const checkAvailabilityUrl         = "/Weaver/service/rest/checkAvailability";
  static const getBalanceUrl                = "/Weaver/service/rest/getBalance";
  static const logoutUrl                    = "/Weaver/service/rest/playerLogout";
  static const uploadAvatar                 = "/Weaver/service/rest/uploadAvatar";
  static const Inbox_URL                    = "/Weaver/service/rest/playerInbox";
  static const INBOX_ACTIVITY_URL           = "/Weaver/service/rest/inboxActivity";
  static const transactionDetailsUrl        = "/Weaver/service/rest/transactionDetails";
  static const versionControlUrl            = "/Weaver/service/rest/versionControl";
  static const inviteFriend                 = "/Weaver/service/rest/inviteFriend";
  static const trackStatus                  = "/Weaver/service/rest/plrTrackReferBonus";

  /* BONUS */
  static const checkBonusStatusUrl          = "/player/checkBonusStatusPlayer";

  /* CASHIER */
  static const paymentOptionsUrl            = "/player/payment/options";
  static const withdrawalRequestUrl         = "/player/payment/withdrawalRequest";
  static const convertToPgCurrencyUrl       = "/player/payment/convertToPgCurrency";
  static const getStatusFromProviderTxnUrl  = "/player/payment/getStatusFromProviderTxn";

}