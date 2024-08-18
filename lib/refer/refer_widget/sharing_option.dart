part of "refer_widget.dart";

class SharingOption extends StatelessWidget {

  const SharingOption({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FlutterShareMe flutterShareMe = FlutterShareMe();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SharingWidget(
          path: "assets/icons/gmail.svg",
          title: context.l10n.gmail,
          onShare: () async{
            log("gmail on share is called");
            /*final deviceInfoPlugin = DeviceInfoPlugin();
            final deviceInfo = await deviceInfoPlugin.deviceInfo;
            final allInfo = deviceInfo.data;
            print("allInfo ============> ${allInfo}");*/
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );*/
            // shareViaGmail();
                /*var myBody = """
                <html>
                  <body>
                    <div id=":o0" class="a3s aiL ">
                    <div class="HOEnZb adM">
                       <div class="adm">
                          <div id="q_53" class="ajR h4" data-tooltip="Hide expanded content" aria-label="Hide expanded content" aria-expanded="true">
                             <div class="ajT"></div>
                          </div>
                       </div>
                       <div class="im">
                          <u></u>
                          <div>
                             <table border="0" cellspacing="0" width="100%" cellpadding="0" align="center" style="max-width:700px;color:#011538;font-size:15px;font-family:Helvetica,Arial,sans-serif;background-color:#f6f7f7;line-height:180%;border:none">
                                <tbody>
                                   <tr>
                                      <td style="height:3px;background-color:#cddc39;line-height:0"> </td>
                                   </tr>
                                   <tr>
                                      <td style="border-left:1px solid #e0e0e0;border-right:1px solid #e0e0e0">
                                         <table border="0" cellspacing="0" width="100%" align="center">
                                            <tbody>
                                               <tr>
                                                  <td colspan="2" style="padding:15px;background-color:#011538;text-align:center"><a href="${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/#" rel="noopener noreferrer" target="_blank" data-saferedirecturl="https://www.google.com/url?q=${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/%23&amp;source=gmail&amp;ust=1689057758504000&amp;usg=AOvVaw3GboXP_qy_1DZv0KKu1etW"> <img src="https://ci3.googleusercontent.com/proxy/VEqQshL2DzKLxK08EG2YCux50hAyVkVJqSOYDmG0hJHzkMEFz4Ei98C0xjPI3MnMRq6Oi122DHgFMXVFnw=s0-d-e1-ft#${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/images/logo.png" alt="longagames" style="width:140px" class="CToWUd" data-bit="iit"> </a></td>
                                               </tr>
                                               <tr>
                                                  <td colspan="2" style="padding:15px">
                                                     Hi,<br>
                                                     <p>Your Friend has referred you to experience Online Lottery Gaming on one of the Africa's leading gaming platform, play the most interesting games and win prizes.<br><br>We are pleased to inform you, that you are eligible for the referral bonus. To become a member of <a href="${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}" target="_blank" data-saferedirecturl="https://www.google.com/url?q=${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}&amp;source=gmail&amp;ust=1689057758504000&amp;usg=AOvVaw3mK9_hLrS-RLQB3ibK759o">${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}</a>, click the link below or paste it into the address bar of your browser. <br><br> <a href="${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data=${UserInfo.getReferCode}/" style="text-decoration:underline;color:#f44336" target="_blank" data-saferedirecturl="https://www.google.com/url?q=${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data%3D${UserInfo.getReferCode}/&amp;source=gmail&amp;ust=1689057758504000&amp;usg=AOvVaw1R1RIPfFkb-Q_VXEe5Lk-g">${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/<wbr>refer-friend?data=${UserInfo.getReferCode}/</a> <br><br> Hurry up, you could be the next winner..!!<br><br> Best Wishes,</p>
                                                  </td>
                                               </tr>
                                               <tr>
                                                  <td colspan="2" style="text-align:center;border-bottom:1px solid #e0e0e0;color:#676767">
                                                     <p><span style="font-size:14px">Email sent by <strong style="color:#444444">Longagames</strong> </span> <br> <span style="font-size:12px">Copyright © 2020. All rights reserved.</span></p>
                                                  </td>
                                               </tr>
                                            </tbody>
                                         </table>
                                      </td>
                                   </tr>
                                   <tr>
                                      <td style="height:5px;background-color:#011538;line-height:0"> </td>
                                   </tr>
                                </tbody>
                             </table>
                          </div>
                       </div>
                    </div>
                    </div>  
                  </body>
                </html>
              """;*/
             var myBody = '''
                              <table style="padding: 10px 15px; width: 100%; background-color: #f2f2f2; border: none; text-align: center; color: #011538; font-size: 14px; font-family: Helvetica,Arial,sans-serif; line-height: 140%;">
                          <tbody>
                          <tr>
                              <td>
                                  <table border="0" cellspacing="0" width="100%" cellpadding="0" align="center" style="max-width: 700px; background-color: #ffffff; border: none; text-align: center;">
                                      <tbody>
                                      <!--<tr>
                                          <td style="padding: 0px; background-color: transparent; text-align: center;"><a href="#" target="_blank" rel="noopener noreferrer"> <img src="images/email/longa.jpg" alt="Longa Games" style="width: 100%;" /> </a></td>
                                      </tr>-->
                                      <tr>
                                          <td style="padding: 3px 15px;">
                                              <h2 style="color: #444444;"><span>Bonjour,</span></h2>
                                          </td>
                                      </tr>
                                      <tr>
                                          <td style="padding: 3px 15px;">
                                              <p><span>Votre ami vous a recommandé pour tester l'expérience de la loterie en ligne sur la principale plateforme de jeux du Congo. Vous pourrez jouer aux jeux les plus intéressants et gagner de nombreux prix. </span></p>
                                              <p><span>Pour devenir membre de https://www.longagames.com, cliquez sur le lien ci-dessous ou collez-le dans la barre d'adresse de votre navigateur. </span><br /><br /><a href="${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data=${UserInfo.getReferCode}/" style="text-decoration: underline; color: #f44336;">${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data=${UserInfo.getReferCode}/</a> <br /><br /><span>Dépêchez-vous, vous pourriez être le prochain gagnant !</span></p>
                                              <p><span>Bonne chance.</span></p>
                                          </td>
                                      </tr>
                                      <tr>
                                          <td style="padding: 25px 15px;"><b>LONGA GAMES<br />Chance Eloko Pamba<br /><br /></b></td>
                                      </tr>
                                      <tr>
                                          <td style="text-align: center; font-size: 0.8em;">
                                              <pre class="tw-data-text tw-text-large tw-ta" data-placeholder="Translation" id="tw-target-text" dir="ltr"><span class="Y2IQFc" lang="fr">Vous devez avoir plus de 18 ans pour jouer. Jouons de manière responsable</span></pre>
                                          </td>
                                      </tr>
                                      </tbody>
                                  </table>
                              </td>
                          </tr>
                          </tbody>
                          
                          ''';
                /*var sample1 = """<!DOCTYPE html><html lang="en"><head><link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
                                  <meta charset="UTF-8"><meta name="viewport" content="width=device-width, user-scalable=no"><link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous"><link rel = "icon" href ="/static/my/images/selt1.png" type = "image/x-icon"><title>Smart E -List</title><link rel="stylesheet" href="/static/my/css/sel-h.css"></head><body><div class="wrap"><button  data-bs-container="body" data-bs-toggle="tooltip" data-bs-placement="top" title="" onclick="window.location.href='/home'"  type="button" class="button">Smart E-List</button></div><script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script><script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.min.js" integrity="sha384-Atwg2Pkwv9vp0ygtn1JAojH0nYbwNJLPhwyoVbhoPwBhjQPR5VtM2+xf0Uwh9KtT" crossorigin="anonymous"></script><script>var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {  return new bootstrap.Tooltip(tooltipTriggerEl)})</script><i class="fa fa-cloud"></i></body></html>""";


                var document = parse(sample1);
            String parsedString = parse(document.body!.text).documentElement!.text;*/

            // var parseStr = Bidi.stripHtmlIfNeeded(myBody);
            var email = Email(
                subject: "Parrainage",//https://uat.longagames.com/refer-friend?data=${UserInfo.getReferCode}
                body: myBody,
                isHTML: true
            );

            await FlutterEmailSender.send(email);

            /*FlutterSocialContentShare.shareOnEmail(
              recipients: ["xxxx.xxx@gmail.com"],
              subject: "Refer a friend",//https://uat.longagames.com/refer-friend?data=${UserInfo.getReferCode}
              body: parsedString,
              isHTML: true
            );*/

          },
        ),
        SharingWidget(
          path: "assets/icons/simple_facebook.svg",
          title: context.l10n.facebook,
          onShare: () async{
            log("fb on share is called");
            flutterShareMe.shareToFacebook(msg: "Vous aimez la loterie et les jeux rapides? Inscrivez-vous sur ${AppConstants.domainName} pour vivre une expérience extatique.  #Longa", url: "${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data=${UserInfo.getReferCode}/");
            /*FlutterSocialContentShare.share(
                type: ShareType.facebookWithoutImage,
                url: "Vous aimez la loterie et les jeux rapides? Inscrivez-vous sur ${AppConstants.domainName} pour vivre une expérience extatique. ${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data=${UserInfo.getReferCode}/ #Longa",
                quote: "captions");*/
          },
        ),
        SharingWidget(
          path: "assets/icons/twitter.svg",
          title: context.l10n.twitter,
          onShare: () {
            log("twitter on share is called");
            //Vous aimez la loterie et les jeux rapides? Inscrivez-vous sur www.longagames.com pour vivre une expérience extatique. https://longagames.com/refer-friend?data=8ASAT #Longa
            flutterShareMe.shareToTwitter(msg: "Vous aimez la loterie et les jeux rapides? Inscrivez-vous sur ${AppConstants.domainName} pour vivre une expérience extatique. ${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data=${UserInfo.getReferCode} #Longa");
          },
        ),
      ],
    );
  }

  void shareViaGmail() async {
    String body = '''
        <div id=":o0" class="a3s aiL ">
                    <div class="HOEnZb adM">
                       <div class="adm">
                          <div id="q_53" class="ajR h4" data-tooltip="Hide expanded content" aria-label="Hide expanded content" aria-expanded="true">
                             <div class="ajT"></div>
                          </div>
                       </div>
                       <div class="im">
                          <u></u>
                          <div>
                             <table border="0" cellspacing="0" width="100%" cellpadding="0" align="center" style="max-width:700px;color:#011538;font-size:15px;font-family:Helvetica,Arial,sans-serif;background-color:#f6f7f7;line-height:180%;border:none">
                                <tbody>
                                   <tr>
                                      <td style="height:3px;background-color:#cddc39;line-height:0"> </td>
                                   </tr>
                                   <tr>
                                      <td style="border-left:1px solid #e0e0e0;border-right:1px solid #e0e0e0">
                                         <table border="0" cellspacing="0" width="100%" align="center">
                                            <tbody>
                                               <!--<tr>
                                                  <td colspan="2" style="padding:15px;background-color:#011538;text-align:center"><a href="https://uat.longagames.com/#" rel="noopener noreferrer" target="_blank" data-saferedirecturl="https://www.google.com/url?q=https://uat.longagames.com/%23&amp;source=gmail&amp;ust=1689057758504000&amp;usg=AOvVaw3GboXP_qy_1DZv0KKu1etW">  </a></td>
                                               </tr>-->
                                               <tr>
                                                  <td colspan="2" style="padding:15px">
                                                     Hi,<br>
                                                     <p>${UserInfo.userName} has referred you to experience Online Lottery Gaming on one of the Asia's leading gaming platform, play the most interesting games and win prizes.<br><br>We are pleased to inform you, that you are eligible for the referral bonus. To become a member of <a href="${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}" target="_blank" data-saferedirecturl="https://www.google.com/url?q=${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}&amp;source=gmail&amp;ust=1689057758504000&amp;usg=AOvVaw3mK9_hLrS-RLQB3ibK759o">${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}</a> and to claim a referral bonus, click the link below or paste it into the address bar of your browser. <br><br> <a href="${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data=${UserInfo.getReferCode}/" style="text-decoration:underline;color:#f44336" target="_blank" data-saferedirecturl="https://www.google.com/url?q=${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/refer-friend?data%3D${UserInfo.getReferCode}/&amp;source=gmail&amp;ust=1689057758504000&amp;usg=AOvVaw1R1RIPfFkb-Q_VXEe5Lk-g">${baseUrlMap[BaseUrlEnum.webViewBaseUrl]}/<wbr>refer-friend?data=${UserInfo.getReferCode}/</a> <br><br> Hurry up, you could be the next winner..!!<br><br> Best Wishes,</p>
                                                  </td>
                                               </tr>
                                               <tr>
                                                  <td colspan="2" style="text-align:center;border-bottom:1px solid #e0e0e0;color:#676767">
                                                     <p><span style="font-size:14px">Email sent by <strong style="color:#444444">Longagames</strong> </span> <br> <span style="font-size:12px">Copyright © 2020. All rights reserved.</span></p>
                                                  </td>
                                               </tr>
                                            </tbody>
                                         </table>
                                      </td>
                                   </tr>
                                   <tr>
                                      <td style="height:5px;background-color:#011538;line-height:0"> </td>
                                   </tr>
                                </tbody>
                             </table>
                          </div>
                       </div>
                    </div>
                    <div class="iX"><br><br>[Message clipped]&nbsp;&nbsp;<a href="https://mail.google.com/mail/u/0?ui=2&amp;ik=28c5c2089e&amp;view=lg&amp;permmsgid=msg-f:1771000354924284244" target="_blank">View entire message</a></div>
                 </div>
      ''';
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'xxxx.xxx@gmail.com',
      queryParameters: {
        'subject': 'Refer a friend',
        'body': base64Url.encode(utf8.encode(body)),
      },
    );

    final String emailUri = _emailLaunchUri.toString();
    // await canLaunchUrl(_emailLaunchUri)
    await launchUrl(_emailLaunchUri, mode: LaunchMode.externalApplication);

    if (await canLaunch(emailUri)) {

    } else {
      throw 'Could not launch $emailUri';
    }
  }


}
