using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CodeDom.OO.Utils;
using CodeDom.OO.Dom.Completeres;
using Microsoft.Build.Evaluation;

namespace CodeDom.OO.CS
{
    public class CSCodeGenerator : AbstractOOCodeGenerator
    {
        private List<GenericClass> classList = new List<GenericClass>();
        private List<Interface> interfaces = new List<Interface>();
        private string projectName = ""; 

        public CSCodeGenerator(string directory, string projectName)
            : base(directory)
        {
            this.projectName = projectName;
        }

        public override void addClass(GenericClass gclass)
        {
            this.classList.Add(gclass);
        }

        public override void addInterface(Interface interfaceModel)
        {
            this.interfaces.Add(interfaceModel);
        }

        public void saveProjectFile(List<string> all_projectFiles, string projectName)
        {

            Project projectFileBuilder = new Project();
            

            projectFileBuilder.Xml.AddImport("$(MSBuildExtensionsPath)\\$(MSBuildToolsVersion)\\Microsoft.Common.props");
            projectFileBuilder.Xml.Imports.Last().Condition = "Exists('$(MSBuildExtensionsPath)\\$(MSBuildToolsVersion)\\Microsoft.Common.props')";

            projectFileBuilder.Xml.AddImport("$(MSBuildToolsPath)\\Microsoft.CSharp.targets");
            projectFileBuilder.Xml.DefaultTargets = "Build";


            var propertyGroupElememt = projectFileBuilder.Xml.AddPropertyGroup();
            propertyGroupElememt.AddProperty("Configuration", "Debug");
            propertyGroupElememt.Properties.Last().Condition = " '$(Configuration)' == '' ";
            propertyGroupElememt.AddProperty("Platform", "AnyCPU");
            propertyGroupElememt.Properties.Last().Condition = " '$(Platform)' == '' ";
            propertyGroupElememt.AddProperty("ProjectGuid", string.Format("{{{0}}}",Guid.NewGuid().ToString()));
            propertyGroupElememt.AddProperty("OutputType", "Library");
            propertyGroupElememt.AddProperty("AppDesignerFolder", "Properties");
            propertyGroupElememt.AddProperty("RootNamespace", projectName);
            propertyGroupElememt.AddProperty("AssemblyName", projectName);
            propertyGroupElememt.AddProperty("TargetFrameworkVersion", "v4.5");
            propertyGroupElememt.AddProperty("FileAlignment", "512");


            propertyGroupElememt = projectFileBuilder.Xml.AddPropertyGroup();
            propertyGroupElememt.Condition = " '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ";
            propertyGroupElememt.AddProperty("DebugSymbols", "true");
            propertyGroupElememt.AddProperty("DebugType", "full");
            propertyGroupElememt.AddProperty("Optimize", "false");
            propertyGroupElememt.AddProperty("OutputPath", "bin\\Debug\\");
            propertyGroupElememt.AddProperty("DefineConstants", "DEBUG;TRACE");
            propertyGroupElememt.AddProperty("ErrorReport", "prompt");
            propertyGroupElememt.AddProperty("AssWarningLevelemblyName", "4");



            propertyGroupElememt = projectFileBuilder.Xml.AddPropertyGroup();
            propertyGroupElememt.Condition = " '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ";
            propertyGroupElememt.AddProperty("DebugType", "pdbonly");
            propertyGroupElememt.AddProperty("Optimize", "true");
            propertyGroupElememt.AddProperty("OutputPath", "bin\\Release\\");
            propertyGroupElememt.AddProperty("DefineConstants", "TRACE");
            propertyGroupElememt.AddProperty("ErrorReport", "prompt");
            propertyGroupElememt.AddProperty("AssWarningLevelemblyName", "4");


            var itemGroup = projectFileBuilder.Xml.AddItemGroup();
            itemGroup.AddItem("Reference", "System.Core");
            itemGroup.AddItem("Reference", "System.Xml.Linq");
            itemGroup.AddItem("Reference", "System.Data.DataSetExtensions");
            itemGroup.AddItem("Reference", "Microsoft.CSharp");
            itemGroup.AddItem("Reference", "System.Data");
            itemGroup.AddItem("Reference", "System.Xml");


            foreach (string projectFile in all_projectFiles)
            {
                // all paths to files are relative
                projectFileBuilder.AddItem("Compile", projectFile.Remove(0,this.directory.AbsolutePath.Count()+1));
            }

            projectFileBuilder.Save(this.directory.AbsolutePath + string.Format("\\{0}.csproj",this.projectName));
        }

        public override void save()
        {
            EasyComplete allCompleters = new EasyComplete();
            allCompleters.baseCompleter = new DomCompleters.DuplicateUsingRemover(
                                          new DomCompleters.AbstractMethodDetector(
                                              allCompleters.baseCompleter));
            List<String> all_project_files = new List<string>();

            string classLocation;
            foreach(GenericClass gclass in this.classList)
            {
                allCompleters.Complete(gclass);
                classLocation = createDirectoryForClass(gclass);
                if (!Directory.Exists(classLocation))
                    Directory.CreateDirectory(classLocation);

                all_project_files.Add(String.Format("{0}\\{1}.cs", classLocation, gclass.Name));
                using (FileStream fs = File.Open(all_project_files.Last()
                    ,FileMode.Create))
                {
                    CodeWritter writer = new CodeWritter(fs);
                    CSClass csClass = new CSClass(gclass);
                    csClass.write(writer);
                    writer.Flush();
                }
            }

            foreach(Interface interfaceModel in this.interfaces)
            {
                classLocation = createDirectoryForClass(interfaceModel);
                if (!Directory.Exists(classLocation))
                    Directory.CreateDirectory(classLocation);

                all_project_files.Add(String.Format("{0}\\{1}.cs", classLocation, interfaceModel.Name));
                using (FileStream fs = File.Open(all_project_files.Last()
                    , FileMode.Create))
                {
                    CodeWritter writer = new CodeWritter(fs);
                    CSInterface csClass = new CSInterface(interfaceModel);
                    csClass.write(writer);
                    writer.Flush();
                }
            }

            this.saveProjectFile(all_project_files, this.projectName);
        }

        private string createDirectoryForClass(Interface gClass)
        {
            StringBuilder location = new StringBuilder();
            location.Append(this.directory.AbsolutePath);
            foreach(string namespaceName in gClass.Namespaces)
            {
                location.AppendFormat("\\{0}",namespaceName);
            }
            return location.ToString();
        }
    }
}
