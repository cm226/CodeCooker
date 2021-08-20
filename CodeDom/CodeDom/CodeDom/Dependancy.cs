using System;
namespace CodeDom
{
public class Dependancy
{
    public enum StandardDependancyValue {NOT_SET,LIST, STRING, DATE_TIME};

    #region Members
    private Uri file;
    private String name;
    private String standardLibraryDependancy;
    private StandardDependancyValue standardDependancy = StandardDependancyValue.NOT_SET;
    private CodeDom.OO.Interface projectTypeDependancy;
    #endregion

    #region Properties
    public Uri File
    {
        get { return this.file; }
        set { this.file = value; }
    }

    public String Name
    {
        get { return this.name; }
        set { this.name = value; }
    }

    public String StandardLibName
    {
        get { return this.standardLibraryDependancy; }
        set { this.standardLibraryDependancy = value; }
    }

    public StandardDependancyValue StandardDependancy
    {
        get { return this.standardDependancy; }
        set { this.standardDependancy = value; }
    }

    public CodeDom.OO.Interface ProjectTypeDependancy
    {
        get { return this.projectTypeDependancy;  }
        set { this.projectTypeDependancy = value; }
    }
    #endregion

    public Dependancy()
	{
    
	}
}
}