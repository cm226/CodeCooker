using CodeDom.OO.Utils;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO.JSON
{
    public class JSONWritter : AbstractOOCodeGenerator
    {
         private List<GenericClass> classes = new List<GenericClass>();

        public JSONWritter(string rootDir): base(rootDir)
        {

        }

        public override void addClass(GenericClass gclass)
        {
            this.classes.Add(gclass);
        }

        public override void addInterface(Interface interfaceModel)
        {
            // JSON files ignore interfaces because JSON uses memers only
        }

        public override void save()
        {
            string fileName;
            foreach(GenericClass gClass in this.classes)
            {
                fileName = createDirectoryForClass(gClass);
                if (!Directory.Exists(fileName))
                    Directory.CreateDirectory(fileName);
                fileName = string.Format("{0}\\{1}.json",fileName , gClass.Name);

                using (ICodeWritter codeWritter = new CodeWritter(fileName))
                {
                    JSONClass jsonClass = new JSONClass(gClass);
                    jsonClass.write(codeWritter);
                }
            }
        }

        private string createDirectoryForClass(Interface gClass)
        {
            DirectoryResolver resolver = new DirectoryResolver();
            resolver.namespaces = gClass.Namespaces.ToList();
            resolver.RootDir = this.directory.AbsolutePath;
            return resolver.Resolve().AbsolutePath;
        }
    }
    
}
