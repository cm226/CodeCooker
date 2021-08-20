using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CPP;
using System.IO;

namespace CodeDomUnitTests.OO.C__
{
    [TestClass]
    public class CPPClassComment
    {
        [TestMethod]
        public void SingleLineComment()
        {
            GenericClass gc = new GenericClass("testClass");
            gc.ClassComment = "This is a single line";

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("/**********************************************/\r\n\t/*  This is a single line                     */\r\n\t/**********************************************/"), true);
            }
        }


        [TestMethod]
        public void MultiLineComment()
        {
            GenericClass gc = new GenericClass("testClass");
            gc.ClassComment = "This is a single line and this comment should exceed the default character limit for the class comment";

            CppClass cppClass = new CppClass(gc);
            CppHeader cppheader = new CppHeader(gc);
            Uri location = new Uri(@"C:\wamp\www\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\testClass.cpp");

            cppheader.write(Path.GetDirectoryName(location.AbsolutePath));

            using (StreamReader header = File.OpenText(Path.GetDirectoryName(location.AbsolutePath) + "\\testClass.h"))
            {
                string headerContent = header.ReadToEnd();
                Assert.AreEqual(headerContent.Contains("/**********************************************/\r\n\t/*  This is a single line and this comment    */\r\n\t/*  should exceed the default character       */\r\n\t/*  limit for the class comment               */\r\n\t/**********************************************/"), true);
            }
        }
    }
}
