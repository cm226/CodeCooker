using CodeCooker.Models;
using CodeCooker.Models.ClassDiagram;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.CodeGeneration
{
    public class CodeGenerator
    {
        public enum Language
        {
            CS,CPP,COS,JSON
        }

        private Models.DocumentModel document;
        private CodeDom.OO.AbstractOOCodeGenerator codeGen;

        public CodeGenerator(Models.DocumentModel document)
        {
            this.document = document;
        }

        public void GenerateCode(Language lang, string userID, Packager packager)
        {
            string codeLocation = String.Format("{0}\\{1}", SpecialDirectorys.tempCodeLocation,userID);
            switch(lang)
            {
                case Language.CPP:
                    codeGen = new CodeDom.OO.CPP.CppCodeGenerator(codeLocation);
                    break;
                case Language.CS:
                    codeGen = new CodeDom.OO.CS.CSCodeGenerator(codeLocation, this.document.Name);
                    break;
                case Language.COS:
                    codeGen = new CodeDom.OO.CoffeeScript.CoffeeWritter(codeLocation);
                    break;
                case Language.JSON:
                    codeGen = new CodeDom.OO.JSON.JSONWritter(codeLocation);
                    break;
                default:
                    throw new Exception("the supplied language is not supported");
            }

            DomConverter domComverter = new DomConverter();
            domComverter.convertDocumentToDom(this.document,this.codeGen);

            packager.SourceDirectory = codeLocation;
            packager.cleanPackageLocation();
            this.codeGen.save();
            packager.Package();
        }

       
    }
}