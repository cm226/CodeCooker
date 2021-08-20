using CodeDom;
using CodeDom.OO;
using CodeDom.OO.Utils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDomUnitTests.Utils
{
    class CodeContainsTest
    {
        private List<string> requiredLines = new List<string>();
        public List<string> Lines { get { return this.requiredLines; } }

        public bool Contains(GenericClass gc, IWriteable writeable)
        {
            Utils.FolderCleaner.cleanFolder();
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gc.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                writeable.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();

                foreach(string line in this.requiredLines)
                {
                    if (!filecontents.Contains(line))
                        return false;
                }
                return true;
            }
        }
    }
}
