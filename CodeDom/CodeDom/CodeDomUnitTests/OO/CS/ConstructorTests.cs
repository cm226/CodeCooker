using System;
using System.IO;
using CodeDom;
using CodeDom.OO.Dom.Completeres;
using CodeDom.OO.Utils;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class ConstructorTests
    {
        [TestMethod]
        public void noConstructor()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            CodeDom.OO.CS.CSClass csClass = new CodeDom.OO.CS.CSClass(gclass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gclass.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("member("), false);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }

        [TestMethod]
        public void ConstructorSet()
        {
            Utils.FolderCleaner.cleanFolder();

            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");

            CodeDom.OO.Method ctor = new CodeDom.OO.Method("member");
            gclass.Constructor = ctor;

            CodeDom.OO.CS.CSClass csClass = new CodeDom.OO.CS.CSClass(gclass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gclass.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("public member()"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }


        [TestMethod]
        public void ConstructorSetWithBaseClass()
        {
            Utils.FolderCleaner.cleanFolder();
            CodeDom.OO.GenericClass bClass = new CodeDom.OO.GenericClass("memberBase");
            CodeDom.OO.Method bcCtor = new CodeDom.OO.Method("memberBase");
            bcCtor.Arguments.Add(new CodeDom.OO.Method.typeName(){ name="arg1", t=Types.INT});
            bcCtor.Arguments.Add(new CodeDom.OO.Method.typeName(){ name="arg2", t=Types.FLOAT});
            bClass.Constructor = bcCtor;


            CodeDom.OO.GenericClass gclass = new CodeDom.OO.GenericClass("member");
            gclass.setBaseClass(bClass);

            CodeDom.OO.Method ctor = new CodeDom.OO.Method("member");
            gclass.Constructor = ctor;

            ConstructorCompleater constructorCompleter = new ConstructorCompleater();
            constructorCompleter.Complete(gclass);

            CodeDom.OO.CS.CSClass csClass = new CodeDom.OO.CS.CSClass(gclass);
            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gclass.Name);
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("public member(int arg1,float arg2)\r\n\t\t:base(arg1,arg2)"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);
        }
    }
}
