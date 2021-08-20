using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.Utils
{
    public class DirectoryResolver
    {
        public List<string> namespaces { set; private get; }
        private StringBuilder filePath = new StringBuilder();

        public String RootDir
        {
            set;
            private get;
        }
        public DirectoryResolver()
        {
        }

        public Uri Resolve()
        {
            this.filePath.Clear();
            this.filePath.Append(RootDir);
            if (namespaces != null)
            {
                foreach (string ns in namespaces)
                {
                    filePath.AppendFormat("\\{0}", ns);
                }
            }

            return new Uri(filePath.ToString());
        }
    }
}
