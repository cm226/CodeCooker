using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CodeDom.OO.CS;
using System.Collections.Generic;
using System.IO;

namespace CodeDomUnitTests.OO.CS
{
    [TestClass]
    public class CSCodeGenerator_proj_creation
    {
        [TestMethod]
        public void Create_project()
        {
            CSCodeGenerator csCodeGen = new CSCodeGenerator(@"C:\Users\cmate_000\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder", "proj");
            List<string> projectFiles = new List<string>();

            projectFiles.Add(@"C:\Users\cmate_000\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\"+"bla.cs");
            csCodeGen.saveProjectFile(projectFiles, "proj");

            Assert.AreEqual(File.Exists(@"C:\Users\cmate_000\Dropbox\ClassDiagramUML\CodeDom\TempTestFolder\proj.csproj"), true);

        }
    }
}
