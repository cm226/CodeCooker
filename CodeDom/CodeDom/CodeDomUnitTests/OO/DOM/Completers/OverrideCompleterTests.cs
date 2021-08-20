using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO.Dom.Completeres;
using CodeDom.OO;

namespace CodeDomUnitTests.OO.DOM.Completers
{
    [TestClass]
    public class OverrideCompleterTests
    {

        

        [TestMethod]
        public void MultipulOverride()
        {
            OverrideCompleter completer = new OverrideCompleter();
            GenericClass gClass = new GenericClass("name");
            GenericClass bClass = new GenericClass("base");

            Method m = new Method("one");
            Method m2 = new Method("one");
            Method m3 = new Method("two");
            Method m4 = new Method("two");

            gClass.PublicMethods.Add(m);
            gClass.PublicMethods.Add(m3);
            bClass.PublicMethods.Add(m2);
            bClass.PublicMethods.Add(m4);

            gClass.setBaseClass(bClass);

            completer.Complete(gClass);

            Assert.AreEqual(m2.IsOverriden, true);
            Assert.AreEqual(m.Overriding == m2, true);

            Assert.AreEqual(m4.IsOverriden, true);
            Assert.AreEqual(m3.IsOverriden, false);
            Assert.AreEqual(m3.Overriding, m4);
        }

        [TestMethod]
        public void OneOverride()
        {
            OverrideCompleter completer = new OverrideCompleter();
            GenericClass gClass = new GenericClass("name");
            GenericClass bClass = new GenericClass("base");

            Method m = new Method("one");
            Method m2 = new Method("one");
            Method m3 = new Method("two");

            gClass.PublicMethods.Add(m);
            gClass.PublicMethods.Add(m3);
            bClass.PublicMethods.Add(m2);

            gClass.setBaseClass(bClass);

            completer.Complete(gClass);

            Assert.AreEqual(m2.IsOverriden, true);
            Assert.AreEqual(m.Overriding == m2, true);
            Assert.AreEqual(m3.IsOverriden, false);
            Assert.AreEqual(m3.Overriding, null);

        }

        [TestMethod]
        public void OneProtectedOverride()
        {
            OverrideCompleter completer = new OverrideCompleter();
            GenericClass gClass = new GenericClass("name");
            GenericClass bClass = new GenericClass("base");

            Method m = new Method("one");
            Method m2 = new Method("one");
            Method m3 = new Method("two");

            gClass.ProtectedMethods.Add(m);
            gClass.ProtectedMethods.Add(m3);
            bClass.ProtectedMethods.Add(m2);

            gClass.setBaseClass(bClass);

            completer.Complete(gClass);

            Assert.AreEqual(m2.IsOverriden, true);
            Assert.AreEqual(m.Overriding == m2, true);
            Assert.AreEqual(m3.IsOverriden, false);
            Assert.AreEqual(m3.Overriding, null);

        }

        [TestMethod]
        public void NoBaseClass()
        {
            OverrideCompleter completer = new OverrideCompleter();
            GenericClass gClass = new GenericClass("name");

            Method m = new Method("one");
            gClass.PublicMethods.Add(m);

            completer.Complete(gClass);

            Assert.AreEqual(m.IsOverriden, false);

        }

        [TestMethod]
        public void NoOverrides()
        {
            OverrideCompleter completer = new OverrideCompleter();
            GenericClass gClass = new GenericClass("name");
            GenericClass bClass = new GenericClass("base");

            Method m = new Method("one");
            Method m2 = new Method("two");
            gClass.PublicMethods.Add(m);
            bClass.PublicMethods.Add(m2);

            gClass.setBaseClass(bClass);

            completer.Complete(gClass);

            Assert.AreEqual(m.IsOverriden, false);
            Assert.AreEqual(m2.IsOverriden, false);
            Assert.AreEqual(m.Overriding, null);

        }
    }
}
