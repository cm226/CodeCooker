using System;
using CodeDom.OO;
using CodeDom.OO.CoffeeScript;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;

namespace CodeDomUnitTests.OO.Coffeescript
{
    [TestClass]
    public class ClassMethods
    {
        [TestMethod]
        public void SinglePublicMethod()
        {
            Utils.FolderCleaner.cleanFolder();
            
            GenericClass gclass = new GenericClass("testClass");
            gclass.PublicMethods.Add(new Method("testMethod"));

            Uri directory = new Uri(Utils.GlobalConstants.testFolder.FullName);
            CoffeeWritter writter = new CoffeeWritter(directory.AbsolutePath);
            writter.addClass(gclass);
            writter.save();

            string filePath = directory.AbsolutePath + "\\" + gclass.Name + ".coffee";
            string coffeescript = File.ReadAllText(filePath);
            Assert.AreEqual(true, coffeescript.Contains("testMethod: ()->"));

            CoffeescriptCompileChecker compileChecker = new CoffeescriptCompileChecker();
            Assert.AreEqual(true, compileChecker.Check(filePath));
        }

        [TestMethod]
        public void SinglePrivateMethod()
        {
            Utils.FolderCleaner.cleanFolder();

            GenericClass gclass = new GenericClass("testClass");
            gclass.PrivateMethods.Add(new Method("testMethod"));

            Uri directory = new Uri(Utils.GlobalConstants.testFolder.FullName);
            CoffeeWritter writter = new CoffeeWritter(directory.AbsolutePath);
            writter.addClass(gclass);
            writter.save();

            string filePath = directory.AbsolutePath + "\\" + gclass.Name + ".coffee";
            string coffeescript = File.ReadAllText(filePath);
            Assert.AreEqual(true, coffeescript.Contains("testMethod= ()->"));

            CoffeescriptCompileChecker compileChecker = new CoffeescriptCompileChecker();
            Assert.AreEqual(true, compileChecker.Check(filePath));

        }

        [TestMethod]
        public void SingleProtectedMethod()
        {
            Utils.FolderCleaner.cleanFolder();

            GenericClass gclass = new GenericClass("testClass");
            gclass.ProtectedMethods.Add(new Method("testMethod"));

            Uri directory = new Uri(Utils.GlobalConstants.testFolder.FullName);
            CoffeeWritter writter = new CoffeeWritter(directory.AbsolutePath);
            writter.addClass(gclass);
            writter.save();

            string filePath = directory.AbsolutePath + "\\" + gclass.Name + ".coffee";
            string coffeescript = File.ReadAllText(filePath);
            Assert.AreEqual(true, coffeescript.Contains("testMethod: ()->"));

            CoffeescriptCompileChecker compileChecker = new CoffeescriptCompileChecker();
            Assert.AreEqual(true, compileChecker.Check(filePath));
        }
    }
}
