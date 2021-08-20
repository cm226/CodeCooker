using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.GoogleDrive
{
    public class File
    {
        private String googleDriveID;

        public String Name { get; set; }
        public String Content { get; set; }
        public String GoogleDriveID { get { return googleDriveID; } }

        public File(String googleDriveID)
        {
            this.googleDriveID = googleDriveID;
        }
    }
}