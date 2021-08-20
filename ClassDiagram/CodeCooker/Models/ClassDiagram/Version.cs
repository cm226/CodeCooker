using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.ClassDiagram
{
    public class Version
    {
        private int major;
        private int minor;
        private int fix;

        private bool valid = false;

        public int Major { get { return this.major; } }
        public int Minor { get { return this.minor; } }
        public int Fix { get { return this.fix; } }
        public bool Valid { get { return this.valid; } }
        
        public Version(String version)
        {
            if(string.IsNullOrEmpty(version))
            {
                this.valid = false;
                return;
            }
            string[] versionStrings = version.Split('.');
            if (versionStrings.Length == 3)
            {
                bool worked = int.TryParse(versionStrings[0],out this.major);
                worked = worked && int.TryParse(versionStrings[1], out this.minor);
                worked = worked && int.TryParse(versionStrings[2], out this.fix);

                if(worked)
                    this.valid = true;
            }
        }

        #region Opperators
        public static bool operator > (Version version1, Version version2)
        {
            if (!version1.Valid && !version2.Valid)
                return true; // dosent matter what we return in this case nither version string is valid
            else if (!version1.Valid)
                return false;
            else if (!version2.Valid)
                return true;
            else // both versions valid
            {
                if (version1.Major > version2.Major)
                    return true;
                else if (version1.Major == version2.Major)
                {
                    if (version1.Minor > version2.Minor)
                        return true;
                    else if (version1.Minor == version2.Minor)
                    {
                        return version1.Fix > version2.Fix;
                    }
                    else
                        return false;
                }
                else
                    return false;
            }
        }
         public static bool operator < (Version version1, Version version2)
        {
             if(version1 > version2)
             {
                 return false;
             }
             else
             {
                 // versions are either equal or <
                 if (version1.Fix == version2.Fix)
                     return false;
                return true;
             }

        }

        public static bool operator == (Version version1, Version version2)
         {
             return version1.Major == version2.Major &&
                    version1.Minor == version2.Minor &&
                    version1.Fix == version2.Fix;
         }

        public static bool operator !=(Version version1, Version version2)
        {
            return (version1 == version2) == false;
        }
        #endregion

         public override string ToString()
         {
             return this.major.ToString()+"."+this.minor.ToString()+"."+this.fix.ToString();
         }


    }
}