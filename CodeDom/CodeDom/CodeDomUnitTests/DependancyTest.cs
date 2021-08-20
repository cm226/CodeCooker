using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom;

namespace CodeDomUnitTests
{
    [TestClass]
    public class DependancyTest
    {
        [TestMethod]
        public void FileAssignment()
        {
            Dependancy dependancy = new Dependancy();
            Uri location = new Uri(@"C:\hello\helloAgain.txt");
            dependancy.File = location;

            Assert.AreEqual(dependancy.File.AbsolutePath, location.AbsolutePath);
        }

        [TestMethod]
        public void NameAssignment()
        {
            Dependancy dependancy = new Dependancy();
            string name = "Bannans";
            dependancy.Name = name;

            Assert.AreEqual(dependancy.Name.CompareTo(name), 0);
        }

        [TestMethod]
        public void StandardLibAssignment()
        {
            Dependancy dependancy = new Dependancy();
            string standardLib = "Monkeys";
            dependancy.StandardLibName = standardLib;

            Assert.AreEqual(dependancy.StandardLibName.CompareTo(standardLib), 0);

        }
    }
}
