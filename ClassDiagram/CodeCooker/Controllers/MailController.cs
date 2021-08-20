using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.Mvc;

namespace CodeCooker.Controllers
{
    public class MailController : Controller
    {

        [HttpPost]
        public ActionResult Mail(FormCollection collection)
        {
            MailMessage message = new MailMessage();
            message.From = new MailAddress("codecooker123@gmail.com");
            message.To.Add(new MailAddress("Support@codecooker.net"));

            message.Subject = "Feedback Comment";
            message.Body = collection["CommentText"] + Environment.NewLine + collection["email"];

            SmtpClient client = new SmtpClient();

#if DEBUG
            client.Credentials = new NetworkCredential("codecooker123@gmail.com", "mateac64");
#else
            client.Host = "relay-hosting.secureserver.net";
            client.Port = 25;
            client.EnableSsl = false;
            client.DeliveryMethod = System.Net.Mail.SmtpDeliveryMethod.Network;
            client.Credentials = new NetworkCredential("Support@codecooker.net", "mateac64");
            client.Timeout = 20000;
#endif
            client.Send(message);



            return View();
        }

    }
}
