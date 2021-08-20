using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;

namespace CodeDomUnitTests.OO.CS.Extreem
{
    [TestClass]
    public class CodeGenerator
    {
        [TestMethod]
        public void MultipulClassesSameName()
        {
            Utils.FolderCleaner.cleanFolder();
            string dir = @"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder";
           
            CodeDom.OO.GenericClass class1 = new CodeDom.OO.GenericClass("class");
            CodeDom.OO.GenericClass class2 = new CodeDom.OO.GenericClass("class");

            CodeDom.OO.CS.CSCodeGenerator codeGenerator = new CodeDom.OO.CS.CSCodeGenerator(dir, "");
            codeGenerator.addClass(class1);
            codeGenerator.addClass(class2);

            codeGenerator.save();

            Assert.AreEqual(File.Exists(dir + "\\class.cs"), true);
            Assert.AreEqual(File.Exists(dir + "\\class1.cs"), true);
        }

        [TestMethod]
        public void NoClasses()
        {
            Utils.FolderCleaner.cleanFolder();
            CodeDom.OO.CS.CSCodeGenerator codeGenerator = new CodeDom.OO.CS.CSCodeGenerator(Utils.GlobalConstants.testFolder.FullName, "");
            codeGenerator.save();
            Assert.AreEqual(Utils.GlobalConstants.testFolder.GetFiles().Length, 0);
        }


    }
}
