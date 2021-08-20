using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CoffeeScript;
using System.IO;

namespace CodeDomUnitTests.OO.Coffeescript
{
    [TestClass]
    public class ClassMembers
    {
        [TestMethod]
        public void SinglePublicMember()
        {
            Utils.FolderCleaner.cleanFolder();

            GenericClass gclass = new GenericClass("testClass");
            Member gmember = new Member(CodeDom.Types.DOUBLE, "dmember");

            gclass.PublicProperties.Add(gmember);
           

            Uri directory = new Uri(Utils.GlobalConstants.testFolder.FullName);
            CoffeeWritter writter = new CoffeeWritter(directory.AbsolutePath);
            writter.addClass(gclass);
            writter.save();

            string filePath = directory.AbsolutePath + "\\" + gclass.Name + ".coffee";
            string coffeescript = File.ReadAllText(filePath);
            Assert.AreEqual(true, coffeescript.Contains("@dmember = null"));

            CoffeescriptCompileChecker compileChecker = new CoffeescriptCompileChecker();
            Assert.AreEqual(true, compileChecker.Check(filePath));
        }

        [TestMethod]
        public void SingleProtectedMember()
        {
            Utils.FolderCleaner.cleanFolder();

            GenericClass gclass = new GenericClass("testClass");
            Member gmember = new Member(CodeDom.Types.DOUBLE, "dmember");

            gclass.ProtectedProperties.Add(gmember);


            Uri directory = new Uri(Utils.GlobalConstants.testFolder.FullName);
            CoffeeWritter writter = new CoffeeWritter(directory.AbsolutePath);
            writter.addClass(gclass);
            writter.save();

            string filePath = directory.AbsolutePath + "\\" + gclass.Name + ".coffee";
            string coffeescript = File.ReadAllText(filePath);
            Assert.AreEqual(true, coffeescript.Contains("@dmember = null"));

            CoffeescriptCompileChecker compileChecker = new CoffeescriptCompileChecker();
            Assert.AreEqual(true, compileChecker.Check(filePath));
        }

        [TestMethod]
        public void SinglePrivateMember()
        {
            Utils.FolderCleaner.cleanFolder();

            GenericClass gclass = new GenericClass("testClass");
            Member gmember = new Member(CodeDom.Types.DOUBLE, "dmember");

            gclass.PrivateProperties.Add(gmember);


            Uri directory = new Uri(Utils.GlobalConstants.testFolder.FullName);
            CoffeeWritter writter = new CoffeeWritter(directory.AbsolutePath);
            writter.addClass(gclass);
            writter.save();

            string filePath = directory.AbsolutePath + "\\" + gclass.Name + ".coffee";
            string coffeescript = File.ReadAllText(filePath);
            Assert.AreEqual(true, coffeescript.Contains("\tdmember = null"));

            CoffeescriptCompileChecker compileChecker = new CoffeescriptCompileChecker();
            Assert.AreEqual(true, compileChecker.Check(filePath));
        }
    }
}
