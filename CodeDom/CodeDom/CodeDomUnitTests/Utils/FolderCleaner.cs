using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDomUnitTests.Utils
{
    public class FolderCleaner
    {
        public static void cleanFolder()
        {
          
            foreach (FileInfo file in GlobalConstants.testFolder.GetFiles())
            {
                file.Delete();
            }
            foreach (DirectoryInfo dir in GlobalConstants.testFolder.GetDirectories())
            {
                dir.Delete(true);
            }

        }
    }
}
