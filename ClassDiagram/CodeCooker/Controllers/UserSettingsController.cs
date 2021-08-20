using CodeCooker.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace CodeCooker.Controllers
{
    public class UserSettingsController : Controller
    {
        UsersContext context = new UsersContext();

        class Theme
        {
            public int themeID { get; set; }
            public string themeName { get; set; }
        }
        //
        // GET: /UserSettings/
        [HttpGet]
        public ActionResult Manage()
        {
            var profile_Query =  from profiles in context.UserProfiles
                                 where profiles.UserName == this.User.Identity.Name
                                 select profiles;
            
            List<UserProfile> profile  = profile_Query.ToList();
            if(profile.Count == 0 )
            {
                return HttpNotFound();
            }

            this.ViewBag.Themes = new SelectList(this.context.Themes, "ThemeID", "Name", profile[0].Theme);

            return View(profile[0]);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Manage(UserProfile profle)
        {
            if (ModelState.IsValid)
            {
                this.context.Entry(profle).State = EntityState.Modified;
                this.context.SaveChanges();

                return this.RedirectToAction("Index","Home");
            }

            this.ViewBag.Themes = new SelectList(this.context.Themes, "ThemeID", "Name", profle.Theme);

            return this.View(profle);
        }

    }
}
