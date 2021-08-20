using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO.Utils;
using System.Collections.Generic;

namespace CodeDomUnitTests.OO
{
    [TestClass]
    public class DirectoryResolverTests
    {
        [TestMethod]
        public void NoNamespaces()
        {
            DirectoryResolver resolver = new DirectoryResolver();
            resolver.RootDir = @"C:\blargh";

            Uri location = resolver.Resolve();
            Assert.AreEqual(true, location.AbsolutePath.CompareTo(@"C:/blargh")==0);

            // do it again 
            location = resolver.Resolve();
            Assert.AreEqual(true, location.AbsolutePath.CompareTo(@"C:/blargh")==0);

        }

        [TestMethod]
        public void NoNamespacesWrongSlash()
        {
            DirectoryResolver resolver = new DirectoryResolver();
            resolver.RootDir = @"C:/blargh";

            Uri location = resolver.Resolve();
            Assert.AreEqual(true, location.AbsolutePath.CompareTo(@"C:/blargh") == 0);

            // do it again 
            location = resolver.Resolve();
            Assert.AreEqual(true, location.AbsolutePath.CompareTo(@"C:/blargh") == 0);

        }

        [TestMethod]
        public void ResolverWithNamespaces()
        {
            DirectoryResolver resolver = new DirectoryResolver();
            resolver.RootDir = @"C:\blargh";
            List<string> namespaces = new List<string>();
            namespaces.Add("one");
            namespaces.Add("two");
            resolver.namespaces = namespaces;

            Uri location = resolver.Resolve();
            Assert.AreEqual(true, location.AbsolutePath.CompareTo(@"C:/blargh/one/two")==0);

            // do it again 
            location = resolver.Resolve();
            Assert.AreEqual(true, location.AbsolutePath.CompareTo(@"C:/blargh/one/two")==0);

            namespaces.Add("three");
            resolver.namespaces = namespaces;

            // do it again 
            location = resolver.Resolve();
            Assert.AreEqual(true, location.AbsolutePath.CompareTo(@"C:/blargh/one/two/three")==0);
        }
    }
}
