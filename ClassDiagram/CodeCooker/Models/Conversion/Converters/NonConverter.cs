using CodeCooker.Models.ClassDiagram;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.Conversion.Converters
{
    public class NonConverter : IModelConverter
    {
        public NonConverter()
        {

        }

        public ClassDiagram.Version Version
        {
            get { return CodeCooker.Configuration.Configuration.FrontendVersion; }
        }

        public string Convert(string model)
        {
            model = Converter.SetModelVersion(model, Configuration.Configuration.FrontendVersion);
            return model;
        }
    }
}