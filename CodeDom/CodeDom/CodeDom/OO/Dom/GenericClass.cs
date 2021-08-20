/*
 * GenericClass.cpp
 *
 *  Created on: 3 Jan 2013
 *      Author: craig
 */


using System.Collections.Generic;
namespace CodeDom.OO
{
public partial class GenericClass : Interface
{
    #region Properties

    public bool ConstructorSet
    {
        get
        {
            return this.constructor != null;
        }
    }
    public Method Constructor
    {
        get
        {
                if (!ConstructorSet)
                    this.constructor = new Method(this.name);
               
                return this.constructor;
        }
        set 
        {
            this.constructor = value;
        }
    }

    public bool DestructorSet
    {
        get { return this.destructor != null; }
    }
    public Method Destructor
    {
        get
        {
            if (!this.DestructorSet)
                this.destructor = new Method(this.name);

            return this.destructor;
        }
    }
    public List<Method> PrivateMethods 
    {
        get { return this.privateMethods; }
    }
    public List<Method> ProtectedMethods 
    {
        get { return this.protectedMethods; }
    }
    public List<Member> PrivateProperties 
    {
        get { return this.privateProperties; }
    }
    public List<Member> ProtectedProperties
    {
        get { return this.protectedProperties; }
    }
    public List<Member> PublicProperties
    {
        get { return this.publicProperties; }
    }

    public bool BaseClassSet
    {
        get { return this.baseClassValid; }
    }
    public bool IsAbstract { get; set; }

    public GenericClass BaseClass 
    {
        get { return this.baseClass; }
    }

    #endregion

    #region Members
    private GenericClass baseClass;
    private bool baseClassValid;

    protected Method constructor = null;
    protected Method destructor = null;
    private List<Method> privateMethods = new List<Method>();
    private List<Method> protectedMethods = new List<Method>();
    private List<Member> publicProperties = new List<Member>();
    private List<Member> privateProperties = new List<Member>();
    private List<Member> protectedProperties = new List<Member>();
    #endregion

    public GenericClass(string name) : base(name)
	{
        this.baseClass = null;
        if (string.IsNullOrWhiteSpace(name)) name = "unNamedClass";
		this.name = name;
    
		this.baseClassValid = false;
        this.IsAbstract = false;
	}

    public void setBaseClass(GenericClass @base)
    {
        this.baseClassValid = true;
        this.baseClass = @base;
        this.dependanceys.Add(new Dependancy(){ProjectTypeDependancy= @base});
    }
    public bool getBaseClass(out GenericClass baseClass)
    {
        if (!this.baseClassValid)
        {
            baseClass = null;
            return false;
        }

        baseClass = this.baseClass;
        return true;
    }
}
}