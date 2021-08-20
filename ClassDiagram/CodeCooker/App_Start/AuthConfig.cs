using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using CodeCooker.Models;
using Microsoft.Web.WebPages.OAuth;
using GooglePlusOAuthLogin;

namespace CodeCooker
{
    public static class AuthConfig
    {
        public static void RegisterAuth()
        {
            // To let users of this site log in using their accounts from other sites such as Microsoft, Facebook, and Twitter,
            // you must update this site. For more information visit http://go.microsoft.com/fwlink/?LinkID=252166

            //OAuthWebSecurity.RegisterMicrosoftClient(
            //    clientId: "",
            //    clientSecret: "");

            //OAuthWebSecurity.RegisterTwitterClient(
            //    consumerKey: "",
            //    consumerSecret: "");

            //OAuthWebSecurity.RegisterFacebookClient(
            //    appId: "",
            //    appSecret: "");

            //OAuthWebSecurity.RegisterGoogleClient(); 

#if DEBUG || LAPTOPDEBUG
            OAuthWebSecurity.RegisterClient(new GooglePlusClient("169836514215-5metp9kheuv5d3omt7fibj1o8eb9h4ih.apps.googleusercontent.com",
                                                                 "BzNn0TiLPG91_Oi4WuHaQvc3"), "Google+", null);
#else
            OAuthWebSecurity.RegisterClient(new GooglePlusClient("169836514215-sfm4rlc0ivvh1k8pjv3v86vivufs4bv0.apps.googleusercontent.com",
                                                                 "GTwFsA6TxwfAjSpAJW0MAMi8"), "Google+", null);
#endif

        }
    }
}
