using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CodeDom.OO.Dom.Completeres;
using CodeDom.OO.Utils;
using CodeDomUnitTests.OO.Exceptions;

namespace CodeDom.OO.CoffeeScript
{
    public class CoffeeWritter : AbstractOOCodeGenerator
    {
        private List<GenericClass> classList = new List<GenericClass>();
        private List<Interface> interfaces = new List<Interface>();

        bool includeModuleMixin = false;

        public CoffeeWritter(string directory) : base(directory)
        {

        }

        public override void addClass(GenericClass gclass)
        {
            classList.Add(gclass);
        }

        public override void addInterface(Interface interfaceModel)
        {
            interfaces.Add(interfaceModel);
        }

        public override void save()
        {
            Directory.CreateDirectory(this.directory.AbsolutePath);
            writeGlobal();
            writeClasses();
            writeInterfaces();
            if (includeModuleMixin)
                includeModule();
        }

        private void writeGlobal()
        {
            List<Interface> AllClassesandInterfaces = new List<Interface>(this.classList);
            AllClassesandInterfaces.AddRange(this.interfaces);
            CoffeescriptGlobals globals = new CoffeescriptGlobals(AllClassesandInterfaces);
            
            string  filename = string.Format("{0}\\{1}.coffee", this.directory.AbsolutePath, "globals");
            using (ICodeWritter writter = new CodeWritter(filename))
            {
                globals.Write(writter);
            }
        }

        private void writeClasses()
        {
            string filename = "";
            EasyComplete allCompleters = new EasyComplete();
            foreach (GenericClass gclass in this.classList)
            {
                allCompleters.Complete(gclass);
                filename = createDirectoryForClass(gclass);
                if (!Directory.Exists(filename))
                    Directory.CreateDirectory(filename);
                filename = string.Format("{0}\\{1}.coffee",filename , gclass.Name);
                if (gclass.InterfacesImplemented.Count > 0 || gclass.BaseClassSet)
                    includeModuleMixin = true;
                using (ICodeWritter writter = new CodeWritter(filename))
                {
                    CoffeeClass coffeeClass = new CoffeeClass(gclass);
                    coffeeClass.Write(writter);
                }
            }
        }

        private void writeInterfaces()
        {
            string filename = "";
            foreach (Interface gInterface in this.interfaces)
            {
                filename = createDirectoryForClass(gInterface);
                if (!Directory.Exists(filename))
                    Directory.CreateDirectory(filename);
                filename = string.Format("{0}\\{1}.coffee", filename, gInterface.Name);
                if (gInterface.InterfacesImplemented.Count > 0)
                    includeModuleMixin = true;
                using (ICodeWritter writter = new CodeWritter(filename))
                {
                    CoffeeInterface coffeeClass = new CoffeeInterface(gInterface);
                    coffeeClass.Write(writter);
                }
            }
        }

        private string createDirectoryForClass(Interface gClass)
        {
            StringBuilder location = new StringBuilder();
            location.Append(this.directory.AbsolutePath);
            foreach (string namespaceName in gClass.Namespaces)
            {
                location.AppendFormat("\\{0}", namespaceName);
            }
            return location.ToString();
        }

        private void includeModule()
        {
            string filename = "";
            filename = string.Format("{0}\\Module.coffee", this.directory.AbsolutePath);
            if (File.Exists(filename))
            {
                throw new InvalidNameException("The class name 'Module' is reserved for coffee script.");
            }

            using (StreamWriter module = File.CreateText(filename))
            {
                module.Write(
@"moduleKeywords = ['extended', 'included']

class Module
  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value

    obj.extended?.apply(@)
    this

  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      # Assign properties to the prototype
      @::[key] = value

    obj.included?.apply(@)
    this"
);
            }
        }
    }
}
