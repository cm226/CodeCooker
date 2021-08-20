using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.Conversion
{
    public class VerisionInterfaceTable
    {
        /*
         * These converster have all been left static, they have no internal state, 
         * so should be thread safe, leaving them static should also save memory
         */
        private static Conversion.Converters.IModelConverter Version_0_5_3_Converter
            = new Conversion.Converters.Version_0_5_3_converter();

        private static Conversion.Converters.IModelConverter NonConverter
            = new Conversion.Converters.NonConverter();


        /*
         * This table denotes the versions where an interface update 
         * was applied and so a converter is required.
         */
        private static CodeCooker.Models.ClassDiagram.Version[] VersionTable = {
               new CodeCooker.Models.ClassDiagram.Version("0.0.0"),
               new CodeCooker.Models.ClassDiagram.Version("0.5.4") };

        public Conversion.Converters.IModelConverter GetConverterForVerion(
            Models.ClassDiagram.Version version)
        {
            if (version < VersionTable.Last())
                return Version_0_5_3_Converter;
            else
                return NonConverter;
        }
    }
}