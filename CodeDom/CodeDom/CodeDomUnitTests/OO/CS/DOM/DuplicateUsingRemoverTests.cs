using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom;
using System.Collections.Generic;
using CodeDom.OO;
using CodeDom.OO.CS.DomCompleters;

namespace CodeDomUnitTests.OO.CS.DOM
{
    [TestClass]
    public class DuplicateUsingRemoverTests
    {
        [TestMethod]
        public void SingleDuplicate()
        {
            Interface dep1 = new Interface("dep1");
            Interface dep2 = new Interface("dep2");

            dep1.Namespaces.Add("one");
            dep1.Namespaces.Add("two");

            dep2.Namespaces.Add("one");
            dep2.Namespaces.Add("two");

            GenericClass gClass = new GenericClass("class");
            Dependancy depItem1 = new Dependancy() { ProjectTypeDependancy = dep1};
            Dependancy depItem2 = new Dependancy() { ProjectTypeDependancy = dep2};

            gClass.Dependancys.Add(depItem1);
            gClass.Dependancys.Add(depItem2);

            DuplicateUsingRemover usingCompleter = new DuplicateUsingRemover();
            usingCompleter.Complete(gClass);

            Assert.AreEqual(gClass.Dependancys.Count, 1);
            Assert.AreEqual(gClass.Dependancys.Contains(depItem1),true);

        }

        [TestMethod]
        public void NoDuplicate()
        {
            Interface dep1 = new Interface("dep1");
            Interface dep2 = new Interface("dep2");

            dep1.Namespaces.Add("one");
            dep1.Namespaces.Add("two");

            dep2.Namespaces.Add("one");
            dep2.Namespaces.Add("three");

            GenericClass gClass = new GenericClass("class");
            Dependancy depItem1 = new Dependancy() { ProjectTypeDependancy = dep1 };
            Dependancy depItem2 = new Dependancy() { ProjectTypeDependancy = dep2 };

            gClass.Dependancys.Add(depItem1);
            gClass.Dependancys.Add(depItem2);

            DuplicateUsingRemover usingCompleter = new DuplicateUsingRemover();
            usingCompleter.Complete(gClass);

            Assert.AreEqual(gClass.Dependancys.Count, 2);
            Assert.AreEqual(gClass.Dependancys.Contains(depItem1), true);
            Assert.AreEqual(gClass.Dependancys.Contains(depItem2), true);

        }

        [TestMethod]
        public void TwoDuplicate()
        {
            Interface dep1 = new Interface("dep1");
            Interface dep2 = new Interface("dep2");
            Interface dep3 = new Interface("dep3");


            dep1.Namespaces.Add("one");
            dep1.Namespaces.Add("two");

            dep2.Namespaces.Add("one");
            dep2.Namespaces.Add("two");

            dep3.Namespaces.Add("one");
            dep3.Namespaces.Add("two");

            GenericClass gClass = new GenericClass("class");
            Dependancy depItem1 = new Dependancy() { ProjectTypeDependancy = dep1 };
            Dependancy depItem2 = new Dependancy() { ProjectTypeDependancy = dep2 };
            Dependancy depItem3 = new Dependancy() { ProjectTypeDependancy = dep3 };

            gClass.Dependancys.Add(depItem1);
            gClass.Dependancys.Add(depItem2);
            gClass.Dependancys.Add(depItem3);

            DuplicateUsingRemover usingCompleter = new DuplicateUsingRemover();
            usingCompleter.Complete(gClass);

            Assert.AreEqual(gClass.Dependancys.Count, 1);
            Assert.AreEqual(gClass.Dependancys.Contains(depItem1), true);

        }

        [TestMethod]
        public void TwoOneSpareDuplicate()
        {
            Interface dep1 = new Interface("dep1");
            Interface dep2 = new Interface("dep2");
            Interface dep3 = new Interface("dep3");
            Interface dep4 = new Interface("dep4");


            dep1.Namespaces.Add("one");
            dep1.Namespaces.Add("two");

            dep2.Namespaces.Add("one");
            dep2.Namespaces.Add("two");

            dep3.Namespaces.Add("one");
            dep3.Namespaces.Add("two");

            dep4.Namespaces.Add("one");
            dep4.Namespaces.Add("three");


            GenericClass gClass = new GenericClass("class");
            Dependancy depItem1 = new Dependancy() { ProjectTypeDependancy = dep1 };
            Dependancy depItem2 = new Dependancy() { ProjectTypeDependancy = dep2 };
            Dependancy depItem3 = new Dependancy() { ProjectTypeDependancy = dep3 };
            Dependancy depItem4 = new Dependancy() { ProjectTypeDependancy = dep4 };

            gClass.Dependancys.Add(depItem1);
            gClass.Dependancys.Add(depItem2);
            gClass.Dependancys.Add(depItem3);
            gClass.Dependancys.Add(depItem4);

            DuplicateUsingRemover usingCompleter = new DuplicateUsingRemover();
            usingCompleter.Complete(gClass);

            Assert.AreEqual(gClass.Dependancys.Count, 2);

        }


    }
}
