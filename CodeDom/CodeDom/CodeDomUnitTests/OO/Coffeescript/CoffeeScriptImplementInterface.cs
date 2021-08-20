using System;
using System.IO;
using CodeDom.OO;
using CodeDom.OO.CoffeeScript;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CodeDomUnitTests.OO.Coffeescript
{
    [TestClass]
    public class CoffeeScriptImplementInterface
    {
        [TestMethod]
        public void SingleInterface()
        {
            Utils.FolderCleaner.cleanFolder();

            GenericClass gclass = new GenericClass("testClass");
            Interface gInterface = new Interface("testInterface");

            gclass.PublicMethods.Add(new Method("testMethod"));
            gclass.ImplementInterface(gInterface);

            Uri directory = new Uri(Utils.GlobalConstants.testFolder.FullName);
            CoffeeWritter writter = new CoffeeWritter(directory.AbsolutePath);
            writter.addClass(gclass);
            writter.save();

            string filePath = directory.AbsolutePath + "\\" + gclass.Name + ".coffee";
            string coffeescript = File.ReadAllText(filePath);
            Assert.AreEqual(true, coffeescript.Contains("@include testInterface"));
            Assert.AreEqual(true, coffeescript.Contains("class testClass extends Module"));

            CoffeescriptCompileChecker compileChecker = new CoffeescriptCompileChecker();
            Assert.AreEqual(true, compileChecker.Check(filePath));
            Assert.AreEqual(true, File.Exists(directory.AbsolutePath + "\\Module.coffee"));
        }

        [TestMethod]
        public void MultiulInterface()
        {
            Utils.FolderCleaner.cleanFolder();

            GenericClass gclass = new GenericClass("testClass");
            Interface gInterface = new Interface("testInterface");
            Interface gInterface2 = new Interface("testInterface2");

            gclass.PublicMethods.Add(new Method("testMethod"));
            gclass.ImplementInterface(gInterface);
            gclass.ImplementInterface(gInterface2);

            Uri directory = new Uri(Utils.GlobalConstants.testFolder.FullName);
            CoffeeWritter writter = new CoffeeWritter(directory.AbsolutePath);
            writter.addClass(gclass);
            writter.save();

            string filePath = directory.AbsolutePath + "\\" + gclass.Name + ".coffee";
            string coffeescript = File.ReadAllText(filePath);
            Assert.AreEqual(true, coffeescript.Contains("@include testInterface"));
            Assert.AreEqual(true, coffeescript.Contains("@include testInterface2"));
            Assert.AreEqual(true, coffeescript.Contains("class testClass extends Module"));

            CoffeescriptCompileChecker compileChecker = new CoffeescriptCompileChecker();
            Assert.AreEqual(true, compileChecker.Check(filePath));
            Assert.AreEqual(true, File.Exists(directory.AbsolutePath + "\\Module.coffee"));
        }
    }
}
