using CodeCooker.Models.DiagramGeneric;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.ClassDiagram
{
    public class DiagramModelParser
    {
        public static DocumentModel Parse(string json)
        {
            DocumentModel doc = JsonConvert.DeserializeObject<DocumentModel>(json);
            if(doc == null)
            {
                doc = new DocumentModel();
            }

            return doc;
        }

        public static DocumentModelForSave ParseForSave(string json)
        {
            DocumentModelForSave doc = JsonConvert.DeserializeObject<DocumentModelForSave>(json);
            if (doc == null)
            {
                doc = new DocumentModelForSave();
            }

            return doc;
        }

        public static string Flatten(DocumentModel doc)
        {
            return JsonConvert.SerializeObject(doc);
        }
    }
}