using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO;
using CodeDom.OO.CS;
using System.IO;
using CodeDom.OO.Utils;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class MethodOverride
    {
        [TestMethod]
        public void SinglePublicOverride()
        {
            Utils.FolderCleaner.cleanFolder();

            GenericClass gClass = new GenericClass("test");
            GenericClass bClass = new GenericClass("testBase");

            Method baseM = new Method("one");
            Method supM = new Method("one");

            supM.Overriding = baseM;
            baseM.IsOverriden = true;

            gClass.setBaseClass(bClass);

            gClass.PublicMethods.Add(supM);
            bClass.PublicMethods.Add(baseM);

            CSClass csClass = new CSClass(gClass);
            CSClass csbClass = new CSClass(bClass);


            Uri fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + gClass.Name + ".cs");
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("public override void one"), true);
            }

            fileName = new Uri(Utils.GlobalConstants.testFolder.FullName + "\\" + bClass.Name + ".cs");
            using (FileStream fs = File.Open(fileName.AbsolutePath,
                FileMode.Create))
            {
                CodeWritter writer = new CodeWritter(fs);
                StreamReader reader = new StreamReader(fs);
                csbClass.write(writer);

                writer.Flush();

                fs.Seek(0, SeekOrigin.Begin);

                string filecontents = reader.ReadToEnd();
                Assert.AreEqual(filecontents.Contains("public virtual void one"), true);
            }

            CSCompileChecker compileChecker = new CSCompileChecker();
            Assert.AreEqual(compileChecker.Check(fileName), true);

        }
    }
}
