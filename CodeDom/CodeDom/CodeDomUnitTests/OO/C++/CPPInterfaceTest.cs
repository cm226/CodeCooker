using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom;
using CodeDom.OO.C__;
using System.IO;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class CPPInterfaceTest
    {
        [TestMethod]
        public void InterfaceSingleMethod()
        {
            Interface gc = new Interface("testInterface");
            Method method = new Method("meth1");
            method.Return = Types.INT;

            gc.PublicMethods.Add(method);

            CPPInterface cppheader = new CPPInterface(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testInterface.h");

            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testInterface.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("class testInterface{ \r\n\tpublic:\r\n\t\tvirtual int meth1() = 0;\r\n};"), true);
            }
        }

        [TestMethod]
        public void InterfaceNoMethod()
        {
            Interface gc = new Interface("testInterface");
            CPPInterface cppheader = new CPPInterface(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testInterface.h");

            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testInterface.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("class testInterface{ \r\n\tpublic:\r\n};"), true);
            }
        }

    }
}
