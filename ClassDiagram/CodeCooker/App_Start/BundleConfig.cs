using System.Web;
using System.Web.Optimization;

namespace CodeCooker
{
    public class BundleConfig
    {
        // For more information on Bundling, visit http://go.microsoft.com/fwlink/?LinkId=254725
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.UseCdn = true;

            bundles.Add(new ScriptBundle("~/bundles/jquery").Include(
                        "~/Scripts/jquery-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryui").Include(
                        "~/Scripts/jquery-ui-{version}.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/jquery.unobtrusive*",
                        "~/Scripts/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new StyleBundle("~/Content/style/home").Include(
                        "~/Content/bootstrap/css/bootstrap.css",
                        "~/Content/Style/Logo.css",
                        "~/Content/Style/home.css",
                        "~/Content/Style/belowTheFold.css"
                ));

            bundles.Add(new StyleBundle("~/Content/themes/base/css").Include(
                        "~/Content/themes/base/jquery.ui.core.css",
                        "~/Content/themes/base/jquery.ui.resizable.css",
                        "~/Content/themes/base/jquery.ui.selectable.css",
                        "~/Content/themes/base/jquery.ui.accordion.css",
                        "~/Content/themes/base/jquery.ui.autocomplete.css",
                        "~/Content/themes/base/jquery.ui.button.css",
                        "~/Content/themes/base/jquery.ui.dialog.css",
                        "~/Content/themes/base/jquery.ui.slider.css",
                        "~/Content/themes/base/jquery.ui.tabs.css",
                        "~/Content/themes/base/jquery.ui.datepicker.css",
                        "~/Content/themes/base/jquery.ui.progressbar.css",
                        "~/Content/themes/base/jquery.ui.theme.css"));

            bundles.Add(new StyleBundle("~/content/ClassDiagramStyle/CodeCooker").Include(
                        "~/Content/bootstrap/css/bootstrap.css",
                         "~/Content/Style/CodeCooker/Animations.css",
                        "~/Content/Style/CodeCooker/Arrows.css",
                        "~/Content/Style/CodeCooker/class_diagram.css",
                        "~/Content/Style/CodeCooker/Class.css",
                        "~/Content/Style/CodeCooker/ContextMenu.css",
                        "~/Content/Style/ExpanderButton.css",
                        "~/Content/Style/Logo.css",
                        "~/Content/Style/CodeCooker/ModelDialog.css",
                        "~/Content/Style/CodeCooker/Resizers.css",
                        "~/Content/Style/CodeCooker/Namespaces.css",
                        "~/Content/Style/loadingBar.css",
                        "~/Content/Style/rolloverList.css",
                        "~/Content/Style/GroupActivity.css",
                        "~/Content/Style/feedbackModel.css"
                ));

            bundles.Add(new StyleBundle("~/content/ClassDiagramStyle/Default").Include(
                        "~/Content/bootstrap/css/bootstrap.css",
                         "~/Content/Style/Default/Animations.css",
                        "~/Content/Style/Default/Arrows.css",
                        "~/Content/Style/Default/class_diagram.css",
                        "~/Content/Style/Default/Class.css",
                        "~/Content/Style/Default/Interface.css",
                        "~/Content/Style/Default/ContextMenu.css",
                        "~/Content/Style/ExpanderButton.css",
                        "~/Content/Style/Logo.css",
                        "~/Content/Style/Default/ModelDialog.css",
                        "~/Content/Style/Default/Resizers.css",
                        "~/Content/Style/Default/Namespaces.css",
                        "~/Content/Style/loadingBar.css",
                        "~/Content/Style/rolloverList.css",
                        "~/Content/Style/GroupActivity.css",
                        "~/Content/Style/feedbackModel.css"
                ));

            bundles.Add(new ScriptBundle("~/content/ClassDiagramScript").Include(
                       "~/Content/bootstrap/js/bootstrap.js",
                       "~/Scripts/jquery.svg/jquery.svg.js",
                       "~/Scripts/jquery.svg/jquery.svgdom.js",
                       "~/Scripts/coopHighLatency.js",
                       "~/Scripts/UML.js",
                       "~/Scripts/StatusBar.js",
                       "~/Scripts/UploadFile.js",
                       "~/Scripts/rollover-list.js",
                       "~/Scripts/GroupActivity.js",
                       "~/Scripts/GroupActivityMembers.js",
                       "~/Scripts/GroupActivityRequests.js",
                       "~/Scripts/coopChatt.js",
                       "~/Scripts/coopStartup.js",
                       "~/Scripts/coopModelSinc.js",
                       "~/Scripts/coopMemberManagement.js",
                       "~/Scripts/coopGlobals.js"
               ));

            bundles.Add(new ScriptBundle("~/content/Forms").Include(
                       "~/Scripts/Forms.js"
                ));

            bundles.Add(new ScriptBundle("~/content/JSBasic").Include(
                    "~/Content/bootstrap/js/bootstrap.js",
                    "~/Scripts/ScrollSpy.js"
                ));

#if DEBUG || LAPTOPDEBUG
            BundleTable.EnableOptimizations = false;
#else
            BundleTable.EnableOptimizations = true;
#endif

        }
    }
}