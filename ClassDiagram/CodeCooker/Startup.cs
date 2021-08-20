using Microsoft.Owin;
using Owin;
using Microsoft.Owin.Security.Google;
using CodeCooker;

[assembly: OwinStartup(typeof(SignalRChat.Startup))]
namespace SignalRChat
{

    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            app.MapSignalR();
        }
    }
}