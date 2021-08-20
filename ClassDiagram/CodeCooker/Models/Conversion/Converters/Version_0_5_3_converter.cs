using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace CodeCooker.Models.Conversion.Converters
{
    public class Version_0_5_3_converter : IModelConverter
    {
        private ClassDiagram.Version version = new ClassDiagram.Version("0.5.3");

        public ClassDiagram.Version Version
        {
            get { return this.version; }
        }

        public string Convert(string model)
        {
            //var json_serializer = new JavaScriptSerializer();
            //var legasy_model = (IDictionary<string, object>)json_serializer.DeserializeObject(model);

            //Console.WriteLine(legasy_model["test"]);
            //TODO implement this
            //var dom = new DocumentModel();
            //dom.VersionModel = new ClassDiagram.Version("0.0.0");
            return model;
        }
    }
}