using System.Collections.Generic;
namespace CodeDom.OO
{
public partial class Member
{
    #region Members
    private Type returnT;
    private string name;
    private Type genericsType;
    private List<string> ctorArgs = new List<string>();
    private bool isStatic;
    #endregion

    #region Properties
    public Type Return
    {
        get { return this.returnT; }
        set { this.returnT = value;}
    }

    public string Name
    {
        get { return this.name; }
        set { this.name = value; }
    }

    public Type GenericsType
    {
        get { return this.genericsType;}
        set { this.genericsType = value; }
    }

    public List<string> CtorArgs
    {
        get { return this.ctorArgs; }
        set { this.ctorArgs = value; }
    }

    public bool IsStatic
    {
        get { return this.isStatic; }
        set { this.isStatic = value; }
    }

    #endregion

    public Member(Type returnT, string name)
	{
		this.returnT = returnT;
        this.Name = name;
        if (string.IsNullOrWhiteSpace(name))
            this.name = "noName";
		this.genericsType = Types.UNSPECIFIED;
        this.isStatic = false;
	}
}
}