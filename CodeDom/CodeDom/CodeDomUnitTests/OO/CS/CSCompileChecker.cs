using CodeDomUnitTests.Utils;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDomUnitTests.OO.CS
{
    class CSCompileChecker
    {
        public bool Check(Uri fileLocation)
        {
// there is prob a better way of finding the compiler, registry?
            string clLocation = @"C:\Program Files (x86)\MSBuild\12.0\Bin\";
            if(!File.Exists(clLocation+"csc.exe"))
                clLocation = @"C:\Windows\Microsoft.NET\Framework64\v4.0.30319\";

            string compileCommand = String.Format("\"{1}csc.exe\" /target:library /recurse:\"{0}\\*.cs\"", 
                                    GlobalConstants.buildFolder,
                                    clLocation);
            StringBuilder compileLog = new StringBuilder();

            ProcessStartInfo startInfo = new ProcessStartInfo()
            {
                FileName = compileCommand,
                WindowStyle = ProcessWindowStyle.Hidden,
                UseShellExecute = false,
                RedirectStandardOutput = true,
                CreateNoWindow = true
            };


            using (Process process = Process.Start(startInfo))
            {
                //
                // Read in all the text from the process with the StreamReader.
                //
                process.WaitForExit();
                using (StreamReader reader = process.StandardOutput)
                {
                    string result = reader.ReadToEnd();
                    compileLog.Append(result);
                }
            }

            string logStr = compileLog.ToString();
            if(logStr.Contains("error"))
                return false;

            return true;
        }
        
    }
}
