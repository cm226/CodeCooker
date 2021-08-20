using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CS;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class AbstractAndVirtual
    {
        [TestMethod]
        public void AbsractAndVirtualmethod()
        {
            GenericClass gc = new GenericClass("class");
            gc.PublicMethods.Add(new Method("meth") { Abstract = true, IsOverriden = true });

            CSClass writter = new CSClass(gc);

            Utils.CodeContainsTest containsTest = new Utils.CodeContainsTest();
            containsTest.Lines.Add("public abstract void meth");

            Assert.AreEqual(containsTest.Contains(gc, writter),true);
        }

        [TestMethod]
        public void AbstractClass()
        {
            GenericClass gc = new GenericClass("class");
            gc.IsAbstract = true;

            CSClass writter = new CSClass(gc);

            Utils.CodeContainsTest containsTest = new Utils.CodeContainsTest();
            containsTest.Lines.Add("public abstract class class");

            Assert.AreEqual(containsTest.Contains(gc, writter), true);
        }
    }
}
