using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO.Dom.Completeres;
using CodeDom.OO;

namespace CodeDomUnitTests.OO.DOM.Completers
{
    [TestClass]
    public class ConstructorCompleterTests
    {
        [TestMethod]
        public void NoConstructorSet()
        {
            ConstructorCompleater completer = new ConstructorCompleater();
            GenericClass gclass = new GenericClass("aclass");
            GenericClass gbaseclass = new GenericClass("abaseclass");
            
            Method baseConstructor = new Method("baseConstructor");
            baseConstructor.addArgs(CodeDom.Types.INT, "arg1");
            baseConstructor.addArgs(CodeDom.Types.FLOAT, "arg2");
            gbaseclass.Constructor = baseConstructor;

            gclass.setBaseClass(gbaseclass);

            completer.Complete(gclass);

            Assert.AreEqual(gclass.ConstructorSet, true);
            Assert.AreEqual(gclass.Constructor.Arguments.Count, 2);
            Assert.AreEqual(gclass.Constructor.BaseClassArgs.Count, 2);

            Assert.AreEqual(gclass.Constructor.Arguments[0].t,baseConstructor.Arguments[0].t);
            Assert.AreEqual(gclass.Constructor.Arguments[0].name.CompareTo(baseConstructor.Arguments[0].name),0);

            Assert.AreEqual(gclass.Constructor.Arguments[1].t, baseConstructor.Arguments[1].t);
            Assert.AreEqual(gclass.Constructor.Arguments[1].name.CompareTo(baseConstructor.Arguments[1].name),0);

            Assert.AreEqual(gclass.Constructor.BaseClassArgs[0].t, baseConstructor.Arguments[0].t);
            Assert.AreEqual(gclass.Constructor.BaseClassArgs[0].name.CompareTo(baseConstructor.Arguments[0].name),0);
            Assert.AreEqual(gclass.Constructor.BaseClassArgs[1].t, baseConstructor.Arguments[1].t);
            Assert.AreEqual(gclass.Constructor.BaseClassArgs[1].name.CompareTo(baseConstructor.Arguments[1].name),0);
        }

        [TestMethod]
        public void ConstructorSet()
        {
            ConstructorCompleater completer = new ConstructorCompleater();
            GenericClass gclass = new GenericClass("aclass");
            GenericClass gbaseclass = new GenericClass("abaseclass");

            Method baseConstructor = new Method("baseConstructor");
            baseConstructor.addArgs(CodeDom.Types.INT, "arg1");
            baseConstructor.addArgs(CodeDom.Types.FLOAT, "arg2");
            gbaseclass.Constructor = baseConstructor;

            Method constructor = new Method("const");
            constructor.addArgs(CodeDom.Types.FLOAT, "arg2");
            constructor.addArgs(CodeDom.Types.INT, "arg1");

            gclass.setBaseClass(gbaseclass);

            completer.Complete(gclass);

            Assert.AreEqual(gclass.ConstructorSet, true);
            Assert.AreEqual(gclass.Constructor.Arguments.Count, 2);
            Assert.AreEqual(gclass.Constructor.BaseClassArgs.Count, 2);

            Assert.AreEqual(gclass.Constructor.Arguments[0].t, baseConstructor.Arguments[0].t);
            Assert.AreEqual(gclass.Constructor.Arguments[0].name.CompareTo(baseConstructor.Arguments[0].name), 0);

            Assert.AreEqual(gclass.Constructor.Arguments[1].t, baseConstructor.Arguments[1].t);
            Assert.AreEqual(gclass.Constructor.Arguments[1].name.CompareTo(baseConstructor.Arguments[1].name),0);
        }

        [TestMethod]
        public void ConstructorSetExtraArgs()
        {
            ConstructorCompleater completer = new ConstructorCompleater();
            GenericClass gclass = new GenericClass("aclass");
            GenericClass gbaseclass = new GenericClass("abaseclass");

            Method baseConstructor = new Method("baseConstructor");
            baseConstructor.addArgs(CodeDom.Types.INT, "arg1");
            baseConstructor.addArgs(CodeDom.Types.FLOAT, "arg2");
            gbaseclass.Constructor = baseConstructor;

            Method constructor = new Method("const");
            constructor.addArgs(CodeDom.Types.FLOAT, "arg2");
            constructor.addArgs(CodeDom.Types.INT, "arg1");
            constructor.addArgs(CodeDom.Types.STRING, "strArg");
            constructor.addArgs(CodeDom.Types.INT, "argagain");

            gclass.setBaseClass(gbaseclass);

            completer.Complete(gclass);

            Assert.AreEqual(gclass.ConstructorSet, true);
            Assert.AreEqual(gclass.Constructor.Arguments.Count, 2);
            Assert.AreEqual(gclass.Constructor.BaseClassArgs.Count, 2);

            Assert.AreEqual(gclass.Constructor.Arguments[0].t, baseConstructor.Arguments[0].t);
            Assert.AreEqual(gclass.Constructor.Arguments[0].name.CompareTo(baseConstructor.Arguments[0].name), 0);

            Assert.AreEqual(gclass.Constructor.Arguments[1].t, baseConstructor.Arguments[1].t);
            Assert.AreEqual(gclass.Constructor.Arguments[1].name.CompareTo(baseConstructor.Arguments[1].name), 0);
        }

        [TestMethod]
        public void ConstructorSetNotEnoughArgs()
        {
            ConstructorCompleater completer = new ConstructorCompleater();
            GenericClass gclass = new GenericClass("aclass");
            GenericClass gbaseclass = new GenericClass("abaseclass");

            Method baseConstructor = new Method("baseConstructor");
            baseConstructor.addArgs(CodeDom.Types.INT, "arg1");
            baseConstructor.addArgs(CodeDom.Types.FLOAT, "arg2");
            gbaseclass.Constructor = baseConstructor;

            Method constructor = new Method("const");
            constructor.addArgs(CodeDom.Types.FLOAT, "arg2");

            gclass.setBaseClass(gbaseclass);

            completer.Complete(gclass);

            Assert.AreEqual(gclass.ConstructorSet, true);
            Assert.AreEqual(gclass.Constructor.Arguments.Count, 2);
            Assert.AreEqual(gclass.Constructor.BaseClassArgs.Count, 2);

            Assert.AreEqual(gclass.Constructor.Arguments[0].t, baseConstructor.Arguments[0].t);
            Assert.AreEqual(gclass.Constructor.Arguments[0].name.CompareTo(baseConstructor.Arguments[0].name), 0);

            Assert.AreEqual(gclass.Constructor.Arguments[1].t, baseConstructor.Arguments[1].t);
            Assert.AreEqual(gclass.Constructor.Arguments[1].name.CompareTo(baseConstructor.Arguments[1].name), 0);
        }
    }
}
