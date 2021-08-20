using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using System.IO;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class OverrideMethod
    {
        [TestMethod]
        public void SinglePublicOverride()
        {
            Utils.FolderCleaner.cleanFolder();

            GenericClass gClass = new GenericClass("test");
            GenericClass bClass = new GenericClass("testBase");

            Method baseM = new Method("one");
            Method supM = new Method("one");

            supM.Overriding = baseM;
            baseM.IsOverriden = true;

            gClass.setBaseClass(bClass);

            gClass.PublicMethods.Add(supM);
            bClass.PublicMethods.Add(baseM);

            CodeDom.OO.CPP.CppHeader cppHeader = new CodeDom.OO.CPP.CppHeader(gClass);
            CodeDom.OO.CPP.CppClass cppClass = new CodeDom.OO.CPP.CppClass(gClass);
            CodeDom.OO.CPP.CppHeader cppbaseHeader = new CodeDom.OO.CPP.CppHeader(bClass);

            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder");
            cppHeader.write(Path.GetDirectoryName(location.AbsolutePath));
            cppbaseHeader.write(Path.GetDirectoryName(location.AbsolutePath));
            cppClass.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\test.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("void one();"), true);
            }

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testBase.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("virtual void one();"), true);
            }

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\test.cpp"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("testBase::one();"), true);
            }
 
        }
    }
}
