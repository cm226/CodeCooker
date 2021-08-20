using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.Models.ClassDiagram
{
    public enum Visibility { PUBLIC, PRIVATE, PROTECTED};
    public class ConvertVisibilityFromString
    {
        public static Visibility ConvertStringToVis(string str)
        {
            switch (str)
            {
                case "+":
                    return Visibility.PUBLIC;
                case "Public":
                    return Visibility.PUBLIC;
                case "-":
                    return Visibility.PRIVATE;
                case "Private":
                    return Visibility.PRIVATE;
                case "Protected":
                    return Visibility.PROTECTED;
                case "#":
                    return Visibility.PROTECTED;
            }

            return Visibility.PUBLIC;
        }
    }
}