using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(iWork_Website.Startup))]
namespace iWork_Website
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
