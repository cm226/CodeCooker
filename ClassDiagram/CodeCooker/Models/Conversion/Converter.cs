using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.Conversion
{
    public static class Converter
    {
        public static VerisionInterfaceTable InterfaceTable = new VerisionInterfaceTable();

        /*
         * This function extracts the version from the model file
         * (its abit of a hack) TODO
         */
        public static CodeCooker.Models.ClassDiagram.Version ExtractVersion(String model)
        {
            string versionString = "\"Version\"";
            int curIndex = model.IndexOf(versionString);
            // add 1 so that we dont get the " in the substr
            int versionStartIndex = model.IndexOf('"', curIndex + versionString.Length +1) +1;
            int versionEndIndex = model.IndexOf('"', versionStartIndex+1);

            return new ClassDiagram.Version(model.Substring(
                versionStartIndex, versionEndIndex - versionStartIndex));
        }

        public static string SetModelVersion(string model, CodeCooker.Models.ClassDiagram.Version version)
        {
            string versionString = "\"Version\"";
            int curIndex = model.IndexOf(versionString);
            // add 1 so that we dont get the " in the substr
            int versionStartIndex = model.IndexOf('"', curIndex + versionString.Length +1) +1;
            int versionEndIndex = model.IndexOf('"', versionStartIndex+1);

            string updatedModel = model.Substring(0, versionStartIndex) +
                                    version.ToString() +
                                        model.Substring(versionEndIndex);

            return updatedModel;
        }

        public static Tuple<string,CodeCooker.Models.ClassDiagram.Version> convertModelToLatestVersion(String model)
        {
            CodeCooker.Models.ClassDiagram.Version modelVersion = ExtractVersion(model);
            Converters.IModelConverter converter = InterfaceTable.GetConverterForVerion(modelVersion);
            string convertedModel = converter.Convert(model);
            modelVersion = ExtractVersion(convertedModel);

            return new Tuple<string, ClassDiagram.Version>(convertedModel, modelVersion);
        }
    }
}