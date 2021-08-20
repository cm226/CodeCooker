using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models
{
    public static class SpecialDirectorys
    {
#if DEBUG || LAPTOPDEBUG
        public const string rootFolder = @"C:\wamp\www\Dropbox\ClassDiagramUML\class-uml-tool";
        public const string ProjectTemplates = rootFolder + @"\ClassDiagram\CodeCooker\ProjectTemplates";
#else
        public const string rootFolder = @"G:\PleskVhosts\codecooker.net\httpdocs";
        public const string ProjectTemplates = rootFolder + @"\ProjectTemplates";
#endif
        public const string tempCodeLocation = rootFolder + @"\UserGeneratedCode";
    }
}