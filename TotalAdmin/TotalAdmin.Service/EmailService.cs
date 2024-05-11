using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using TotalAdmin.Model.DTO;

namespace TotalAdmin.Service
{
    public class EmailService
    {
        public void Send(EmailDTO info)
        {
            var smtpClient = new SmtpClient("localhost")
            {
                Port = 25,
            };

            smtpClient.Send(info.From, info.To, info.Subject, info.Body);
        }
    }
}
