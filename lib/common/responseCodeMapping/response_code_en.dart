class ResponseCodeMappingInEnglish {
  static final ResponseCodeMappingInEnglish _instant = ResponseCodeMappingInEnglish._ctor();

  factory ResponseCodeMappingInEnglish(){
    return _instant;
  }

  ResponseCodeMappingInEnglish._ctor();

  static const responseCodeMsg = {
    //CASHIER
    "CASHIER_107": "Device type not supplied.",
    "CASHIER_108": "User agent type not supplied",
    "CASHIER_601": "Invalid domain",
    "CASHIER_508": "Player info not found",
    "CASHIER_316": "Invalid Currency Code",
    "CASHIER_1101": "invalid country",
    "CASHIER_1502": "Country Not Mapped With Any Currency.",
    "CASHIER_1121": "Payment Option Not Found",
    "CASHIER_201": "Invalid request",
    "CASHIER_1117": "Please Provide Valid Merchant Code",
    "CASHIER_1105": "invalid transaction type",
    "CASHIER_962": "Merchant not found",
    "CASHIER_308": "No payment options available.",
    "CASHIER_123": "Processing Charge Not Found For Requested Amount",
    "CASHIER_121": "exchange rate not found",
    "CASHIER_318": "Redeem Account Not Exist",
    "CASHIER_2008": "Anon limit exceed",
    "CASHIER_1213": "Provider Implementation Not Found.",
    "CASHIER_1214": "Provider Parameter Data Not Found.",
    "CASHIER_1215": "Provider Deposit Config Not Found.",
    "CASHIER_1216": "Provider Withdrawal Config Not Found.",
    "CASHIER_12015": "Some Error Occurred While Doing Transaction",
    "CASHIER_1102": "Wallet update failed",
    "CASHIER_309" : "Your payment has been failed.Please try again.",
    "CASHIER_530" : "OTP Code is not valid.",
    "CASHIER_532" : "Maximum OTP Resend Count Exceed",
    "CASHIER_310" : "Account Number Must Be Same In Resend Otp",
    "CASHIER_1034": "Please Provide Valid Mobile No",
    "CASHIER_1035": "Please Provide Valid Email",
    "CASHIER_12001": "Withdrawal Transaction Error From Weaver",
    "CASHIER_12006": "Withdrawal Request Failed.",
    "CASHIER_1002": "Some Internal Error !",
    "CASHIER_1109": "Player validation failed.",
    "CASHIER_1001": "User not found",
    "CASHIER_1134": "Payment Option Not Found For Requested Currency",
    "CASHIER_1201": "Data Not Found.",
    "CASHIER_2004": "RMS Token Not Found",
    "CASHIER_2005": "Rms User Id Not Found",
    "CASHIER_1111": "Requested Url Not Found",
    "CASHIER_1127": "Please Provide Valid Token.",
    "CASHIER_2006": "Invalid Client token",
    "CASHIER_206" : "Invalid Merchant / Alias / Domain Found.",
    "CASHIER_4003": "Withdrawal Request Not Found",
    "CASHIER_2009": "Please Provide Withdrawal Pin",
    "CASHIER_2010": "Invalid Withdrawal Pin",
    "CASHIER_1404": "Request Already Approved",
    "CASHIER_302" : "Invalid Amount",
    "CASHIER_1209": "Provider Transaction Not Found.",
    "CASHIER_1208": "User Transaction Not Found.",
    "CASHIER_1022": "Invalid json provided.",
    "CASHIER_4004": "DB Transaction Eroor",
    "CASHIER_2003": "Error in RMS API Calling",
    "CASHIER_1106": "User transaction not found",
    "CASHIER_-1": "Failed",

    //WEAVER
    "WEAVER_606": "Invalid Alias Name",
    "WEAVER_112": "Operation not supported",
    "WEAVER_601": "Invalid domain",
    "WEAVER_101": "Hibernate exception",
    "WEAVER_543": "Please provide valid Details",
    "WEAVER_542": "Details is not provided.",
    "WEAVER_553": "Some Error during Validation Check",
    "WEAVER_102": "Some internal error",
    "WEAVER_514": "Player status is inactive.",
    "WEAVER_617": "Player is not bound with an affiliate system.",
    "WEAVER_621": "Affiliate Id not provided",
    "WEAVER_619": "Player is not bound with provided AffiliateId",
    "WEAVER_620": "Mobile Number is already linked to your account",
    "WEAVER_533": "RSA Id for particular player not exists",
    "WEAVER_508": "Player info not found.",
    "WEAVER_526": "Required parameter are missing",
    "WEAVER_103": "Invalid request",
    "WEAVER_802": "Player Not Found",
    "WEAVER_577": "Player maximum limit exceed",
    "WEAVER_408": "Old Password Incorrect",
    "WEAVER_409": "Current and New Password can not be same.",
    "WEAVER_410": "New Password Can'tbeFromLastPassword's",
    "WEAVER_609": "Invalid password! Please try again!",
    "WEAVER_203": "Player not logged In",
    "WEAVER_507": "Too much data. Please select more filters",
    "WEAVER_801": "Domain Name Not Vaild",
    "WEAVER_522": "Registration declined. Please input a valid RSA ID number.",
    "WEAVER_527": "Invalid age - must be at least 18 years",
    "WEAVER_501": "User name already exist.",
    "WEAVER_503": "Mobile number already exist.",
    "WEAVER_564": "Mobile Number and User Name already exist.",
    "WEAVER_502": "E-mail ID already exist.",
    "WEAVER_565": "Email Id and User Name already exits.",
    "WEAVER_510": "Email Id and Mobile Number already exist.",
    "WEAVER_566": "Email Id, Mobile Number and User Name already exist.",
    "WEAVER_528": "RSA Id already exist.",
    "WEAVER_567": "Rsa Id and User Name already exist.",
    "WEAVER_534": "RsaId and mobileNo exist",
    "WEAVER_568": "Rsa Id, Mobile Number and User Name already exist.",
    "WEAVER_535": "RsaId and emailId exist",
    "WEAVER_569": "Rsa Id, Email Id and User Name already exist.",
    "WEAVER_536": "RsaId, mobileNo and emailId exist",
    "WEAVER_570": "Rsa Id, Email Id, Mobile Number and User Name already exist.",
    "WEAVER_505": "Player already exist with same information.",
    "WEAVER_121": "Invalid currency",
    "WEAVER_2001": "Some Internal Error in Communication Module, No vendor or vendor-alias mapping exists!",
    "WEAVER_2015": "Hibernate Exception occurred in communication module",
    "WEAVER_106": "Invalid file upload request.Only multipart content allowed.",
    "WEAVER_415": "Message has been deleted.",
    "WEAVER_417": "No Message Found On Inbox Id  1234 For This Player",
    "WEAVER_110": "Invalid Request parameter(s).",
    "WEAVER_100": "Site Under maintenance",
    "WEAVER_111": "No proper app version detail exist.",

    //BONUS
    "BONUS_12204": "No Active Alias Found.",
    "BONUS_12101": "Invalid Domain Found.",
    "BONUS_12411": "Please Provide Valid Communication",
    "BONUS_12433": "Anon Deposit Limit Exceed",
    "BONUS_12413": "Please Provide Valid Player Id",
    "BONUS_12303": "Please Provide Valid Provider.",
    "BONUS_12301": "Please Provide Valid Service.",
    "BONUS_12302": "Please Provide Valid Game.",
    "BONUS_12051": "Data Not Found.",
    "BONUS_12052": "Invalid Merchant Found.",
    "BONUS_12008": "Invalid JSON Found.",
    "BONUS_12432": "Error in retailer sale",
    "BONUS_12423": "Error From Ram Api Calling",
    "BONUS_12151": "Invalid User Found.",
    "BONUS_12434": "Error In get Qr Code",
    "BONUS_12428": "ERROR at weaver wallet credit",
    "BONUS_12414": "Total usage Count Exceeds Max Usage Count",
    "BONUS_12426": "RMS Token Missing",
    "BONUS_12431": "Rms User Id Not Found",
    "BONUS_12009": "Requested Url Not Found",
    "BONUS_12010": "Please Provide Valid Token",
    "BONUS_12430": "Invalid Client token",
    "BONUS_12429": "Invalid Response Found From RMS",
    "BONUS_-1"   : "Failed",
    "BONUS_1"    : "Unknown Error Occurred, Please Try Again.",

    //IGE
    "IGE_401": "Not a valid request.",
    "IGE_402": "Background is not available for the given screen resolution.",
    "IGE_403": "Assets are not available for the given screen resolution.",
    "IGE_404": "Panel Assets are not available for the given screen resolution.",
    "IGE_405": "Something went wrong, please try again.",
    "IGE_406": "No Game available.",
    "IGE_407": "Some Internal error",
    "IGE_408": "Please provide apporpriate parameter value.",
    "IGE_409": "Please request for valid game",
    "IGE_410": "The game does not exist for mobile. Please play game over PC.",
    "IGE_411": "Please provide apporpriate parameter value.",
    "IGE_412": "Ticket information does not exist",
    "IGE_02": "Something went wrong, please try again.",
    "IGE_03": "Something went wrong, please try again.",
    "IGE_04": "Your request has been timed out.",
    "IGE_06": "Invalid file upload request.Only multipart content allowed.",
    "IGE_07": "Device type not supplied.",
    "IGE_08": "User agent type not supplied.",
    "IGE_10": "Invalid Request parameter(s).",
    "IGE_11": "No record found",
    "IGE_12": "Something went wrong, please try again.",
    "IGE_201": "Something went wrong, please try again.",
    "IGE_202": "Invalid session id",
    "IGE_203": "Player not logged In",
    "IGE_204": "Invalid service code",
    "IGE_205": "Invalid amount",
    "IGE_206": "Invalid player",
    "IGE_207": "Unauthentic vendor",
    "IGE_208": "Invalid vendor credentials",
    "IGE_209": "Insufficient player balance",
    "IGE_210": "Your transaction has been temporary blocked",
    "IGE_211": "Inconsistency in user balance.",
    "IGE_212": "Invalid wallet type.",
    "IGE_213": "Invalid subwallet",
    "IGE_214": "Invalid balance type.",
    "IGE_215": "Insufficient balance to debit player account.",
    "IGE_216": "Duplicate transaction",
    "IGE_217": "Withdrawal has been already cancelled.",
    "IGE_218": "Withdrawal can't be cancelled,already processed",
    "IGE_219": "Insufficient tickets.",
    "IGE_220": "No Device found Mapped with the Given Mac Address",
    "IGE_221": "Invalid Transaction Id",
    "IGE_222": "This transaction has already been processed",
    "IGE_100": "Error in Game purchase, Please try again.",
    "IGE_1" : "Unexpected problem",
    "IGE_2" : "Duplicated transaction id",
    "IGE_3" : "Insufficient funds",
    "IGE_4" : "Invalid input parameters",
    "IGE_5" : "Invalid token",
    "IGE_6" : "Rollback amount different than initial amount (when refund)",
    "IGE_7" : "Token expired",
    "IGE_8" : "User not found",
    "IGE_9" : "Invalid credentials",
    "IGE_7332": "Insufficient Balance",
    "IGE_7333": "Please connect to internet and try again!",
    "IGE_7335": "Sorry for inconvenience, Please try again",
    "IGE_7530": "Incomplete Data",
    "IGE_-1": "Some Error Occured",
    "IGE_7338": "Something went wrong, please try again!",
    "IGE_8205": "Coming Soon...",
    "IGE_7444": "Server error,please try again later",
    "IGE_645": "All tickets are exhausted",
    "IGE_876": "We have detected slow network, this may take longer time than usual.",
    "IGE_226": "Transaction has already processed with this refTxnNo",
    "IGE_111": "Game is Already Finished",
    "IGE_1002": "Invalid Currency Code",
    "IGE_1003": "No Data Found",
    "IGE_1004": "Invalid Language Code",
    "IGE_500":  "Internal Server Error",
    "IGE_1005": "The transaction is still in progress, kindly check after some time",
    "IGE_115" : "Connection Error",

    //DGE
    "DGE_0": "Success",
    "DGE_1": "wrong signature",
    "DGE_602": "Unauthentic service user",
    "DGE_102": "Some internal error",
    "DGE_704": "Signature not found in request",
    "DGE_606": "Invalid Alias Name",
    "DGE_220": "This device is not registered",
    "DGE_101": "Hibernate exception",
    "DGE_203": "Player not logged in",
    "DGE_206": "Invalid player",
    "DGE_210": "Your transaction has been temporary blocked",
    "DGE_609": "Invalid password! Please try again!",
    "DGE_405": "User Is Not Valid !",
    "DGE_205": "Invalid amount",
    "DGE_216": "Duplicate transaction",
    "DGE_212": "Invalid wallet type",
    "DGE_214": "Invalid balance type",
    "DGE_121": "Invalid currency",
    "DGE_201": "Invalid request",
    "DGE_514": "Player status is inactive",
    "DGE_420": "Invalid Player ID",
    "DGE_209": "Insufficient player balance!!",
    "DGE_1001": "Internal system error!!",
    "DGE_1002": "Sale of these many draws not allowed",
    "DGE_1003": "Draws data and number of draws not equal",
    "DGE_1004": "Max Draws Selection Limit Reached",
    "DGE_1005": "Invalid Panel Data provided!",
    "DGE_1006": "Invalid Bet Type selected!",
    "DGE_1007": "Invalid Pick Type selected!",
    "DGE_1008": "Invalid Pick Config selected!",
    "DGE_1009": "Total number of picked values are not correct!",
    "DGE_1010": "Number of panels selected more than the max panel limit",
    "DGE_1011": "Invalid Game Code provided",
    "DGE_1012": "Picked values exceeding the range",
    "DGE_1013": "Merchant Does Not Exists !",
    "DGE_1014": "Incorrect Password !",
    "DGE_1015": "Invalid Bet Amount Multiple provided",
    "DGE_1016": "Draw not available!",
    "DGE_1017": "Invalid Picked Values selected!",
    "DGE_1018": "Invalid JSON data provided",
    "DGE_1019": "Player daily purchase limit reached",
    "DGE_1020": "Invalid Alias name provided",
    "DGE_1021": "Invalid Mac address provided",
    "DGE_1022": "Invalid user id provided",
    "DGE_1023": "Invalid currency code provided",
    "DGE_1024": "No Ticket in this Draw",
    "DGE_1025": "Unable to fetch player data !",
    "DGE_1026": "Transaction Failed !",
    "DGE_1027": "Unable to push Winning To merchant !",
    "DGE_1028": "Wager Confirmation Failed !",
    "DGE_1029": "Wager Refund Failed !",
    "DGE_1030": "Draw for this game not found",
    "DGE_1031": "Prize distribution cannot be performed!",
    "DGE_1032": "Error in Fetch Winning tickets",
    "DGE_1033": "Invalid Draw Data !",
    "DGE_1034": "No Transaction Found !",
    "DGE_1035": "wrong ticket number !",
    "DGE_1036": "contact to sales team !",
    "DGE_1037": "System does not support currency",
    "DGE_1038": "Currency error : Please connect to admin !",
    "DGE_1039": "No Carried Forward Amount in previous Draw !",
    "DGE_1040": "No Carried Over RSR in previous Draw !",
    "DGE_1043": "Draw Cannot be perfomed !",
    "DGE_1049": "Invalid user name provided",
    "DGE_1050": "Unable to fetch retailer data !",
    "DGE_1051": "Winning Number format Invalid !",
    "DGE_1053": "This ticket can't be claimed at this Retailer!",
    "DGE_1054": "Error in Encrypting Ticket",
    "DGE_1055": "Invalid Merchant Game !",
    "DGE_1056": "Unable to claim as wallet in auto push type !",
    "DGE_1057": "Invalid Number of lines !",
    "DGE_1058": "Invalid Number picked !",
    "DGE_1059": "Cannot perform PayPwt !",
    "DGE_1060": "Already Claimed Ticket !",
    "DGE_1061": "Invalid Purchase Channel",
    "DGE_1062": "Reprint Limit Exceeded",
    "DGE_1063": "Request Cannot be Authenticated !",
    "DGE_1064": "Cannot cancel ticket",
    "DGE_1065": "ticket already cancelled !",
    "DGE_1066": "Invalid QPMode",
    "DGE_1067": "Invalid QP Parameter",
    "DGE_1068": "Reconcialation Refund Failed !",
    "DGE_1069": "Error in generating validation code",
    "DGE_1070": "total numbers is not correct",
    "DGE_1071": "Invalid merchant transaction id",
    "DGE_1072": "can not freeze",
    "DGE_1073": "Error in deleting scheduler.",
    "DGE_1074": "Invalid combination of player id and merchant transaction for merchant code",
    "DGE_1075": "Picked value does not have proper input value format/length",
    "DGE_1076": "Invalid Purchase Device Type !!",
    "DGE_1077": "Invalid draw!",
    "DGE_1078": "Unauthorized retailer for this ticket !",
    "DGE_1079": "Ticket has Reprint !",
    "DGE_1080": "Excess ticket sold by retailer !",
    "DGE_1081": "Draw Performed Reprint Failed",
    "DGE_1082": "Wrong PWT Status",
    "DGE_1083": "B2C Ticket Cannot be Cancelled",
    "DGE_1084": "Sale is currently stopped by admin!",
    "DGE_1085": "Username or session ID cannot be null",
    "DGE_1086": "Unable to request third party api!",
    "DGE_1087": "Claim Party type cannot be null",
    "DGE_1088": "Interface type cannot be null",
    "DGE_1089": "Sale Merchant cannot be null",
    "DGE_1090": "Verification code cannot be null",
    "DGE_1091": "User Name cannot be null",
    "DGE_1092": "Session id cannot be null",
    "DGE_1093": "Claim Party id cannot be null",
    "DGE_1094": "Invalid Draw Status",
    "DGE_1095": "Invalid day of week requested",
    "DGE_1096": "Invalid Channel Index",
    "DGE_1097": "Invalid Format Status Index",
    "DGE_1098": "Invalid Party Type Index",
    "DGE_1099": "Invalid Party Type Name",
    "DGE_1100": "Invalid Property Editable Index",
    "DGE_1101": "Invalid Property Status Index",
    "DGE_1102": "Invalid Ticket Verify Code",
    "DGE_1103": "Draw cannot be Cancelled",
    "DGE_1107": "Draw not Available",
    "DGE_1108": "Submiting invalid result for the game",
    "DGE_1104": "promo/raffel ticket cannot be Cancelled",
    "DGE_1105": "Invalid date",
    "DGE_1106": "Merchant is not authorized for the sale !!",
    "DGE_1109": "Invalid bet amount multiple provided.",
    "DGE_1110": "promo/raffel ticket cannot be reprint directly",
    "DGE_1111": "Invalid Ticket Number",
    "DGE_1112": "Invalid Game ID",
    "DGE_1113": "Invalid start date !",
    "DGE_1114": "Invalid end date !",
    "DGE_1115": "Start date can not be greater than end date !",
    "DGE_1116": "Invalid Family Code",
    "DGE_1117": "Invalid Win Mode",
    "DGE_1118": "can not change freeze time",
    "DGE_1119": "can not change sale stop time",
    "DGE_1120": "can not change sale perform time",
    "DGE_1121": "QP not allowed !",
    "DGE_1122": "Invalid Cancel Channel !",
    "DGE_1123": "Invalid Auto Cancel Type !",
    "DGE_1124": "Invalid operation",
    "DGE_1125": "Draw Prize multiplier event failed.",
    "DGE_1126": "Invalid AutoCancel Request Parameter",
    "DGE_1127": "Database operation error in purchase ticket",
    "DGE_1128": "can not change verification time",
    "DGE_1129": "can not change claim end time",
    "DGE_1130": "can not change claim start time",
    "DGE_1215": "Sale is not started yet. Please wait for some more time !",
    "DGE_12345": "Server Timeout",
    "DGE_1201": "Limit Reached",
    "DGE_596": "Wager Not Allowed for Game",
    "DGE_2013": "Max slab has been reached!",

    //RAM
    "RAM_0" : "Success",
    "RAM_10353": " InvalidAlias Found.",
    "RAM_10106": " Please Provide Valid Mobile No",
    "RAM_10107": " Please Provide Valid Email",
    "RAM_10006": " Invalid Format Found For ##@@##",
    "RAM_10008": " Invalid JSON Found.",
    "RAM_10009": " Requested Url Not Found",
    "RAM_10012": " Invalid Response Found From Communication",
    "RAM_10302": " Email Already Exist.",
    "RAM_10575": " Please Provide Valid Type For Email Or SMS.",
    "RAM_10514": " You Are Not Allowed To Perform This Action.",
    "RAM_10549": "Registration not allowed for given RSA ID.",
    "RAM_10004": " Please Provide Valid ##@@##",
    "RAM_10454": " Entered OTP is Expired. Please Try Again.",
    "RAM_10455": " Please Provide Valid Date.",
    "RAM_10453": " Otp Verification Failed.",
    "RAM_10452": " Player Already Exist.",
    "RAM_10457": " Please Provide Valid Player Register Url.",
    "RAM_10459": " Something went wrong please try again later.",
    "RAM_10571": " Please Provide Valid Player RSA Id.",
    "RAM_10523": " Please Provide Valid Player Primary Id.",
    "RAM_10308": " Please enter valid Mobile/Email",
    "RAM_406": " Either username or password is invalid",
    "RAM_10567": " Player is blocked. Please contact The Administrator.",
    "RAM_10201": " Invalid Domain Found.",
    "RAM_10531": " Only Provide Either DomainId or MerchantDoaminId",
    "RAM_10536": " Profile Update Request Count Reached.",
    "RAM_10491": " Invalid Player Found.",
    "RAM_10526": " Player Profile Status Already Same As Requested",
    "RAM_10540": " Please update Rsa Id first.",
    "RAM_10538": " Player Profile Has To Be Active For Inactivating Its Profile.",
    "RAM_10518": " Verification Pending For Player Email Mobile Name or Security Question.",
    "RAM_10519": " Some Player Documents Are Not Verified Yet",
    "RAM_10520": " Player Does Not Have a Active Document For All Active Doctypes",
    "RAM_10539": " Player Needs To Upload Documents For Profile Activation.",
    "RAM_10495": "Player Basic Information Not Found.",
    "RAM_10585": " Your mobile no is found as duplicate with some player.\\nPlease contact customer support to change your mobile no.",
    "RAM_10310": " Invalid Bank Detail Fields.",
    "RAM_10497": " Please Provide Valid Document",
    "RAM_10546": " No Expiry Days Present For Requested Change Type.",
    "RAM_10496": " Invalid Status Found In Configurations.",
    "RAM_10492": " Already Updated"
  };

}