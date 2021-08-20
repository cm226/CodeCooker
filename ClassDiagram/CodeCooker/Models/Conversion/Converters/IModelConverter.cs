using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeCooker.Models.Conversion.Converters
{
    public interface IModelConverter
    {
        Models.ClassDiagram.Version Version { get; }
        String Convert(String model);
    }
}
