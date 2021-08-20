using CodeDom.OO.Dom;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDom.OO
{
    public class Interface
    {
        public enum Visibility { PUBLIC, PRIVATE, PROTECTED };
         #region Properties
        public Visibility Visibiltity {get; set; }
        public string ClassComment { get; set; }
        public bool IsStatic { get; set; }
        public Namespaces Namespaces { get { return this.namespaces; } }
        public IConstList<Interface> InterfacesImplemented
        {
            get { return this.implementedInterfaces; }
        }
        public bool GenericTypeSet
        {
            get { return this.genericType != Types.UNSPECIFIED; }
        }
        public CodeDom.Type GenericType
        {
            get { return this.genericType; }
        }
 
 
        public List<Method> PublicMethods
        {
            get { return this.publicMethods; }
        }

        public DependancyList Dependancys 
        {
            get { return this.dependanceys; }
        }

        public string Name { get { return this.name; } }
        public string PostClassModStr
        {
            get { return postClassModStr; }
            set { postClassModStr = value; }
        }
        public string PreClassModStr
        {
            get { return this.preClassModString; }
            set { this.preClassModString = value; }
        }
        #endregion

         #region Members
        protected string name = "";
        protected Namespaces namespaces = new Namespaces();
        protected List<Method> publicMethods = new List<Method>();
        protected InterfaceList implementedInterfaces = new InterfaceList();
        protected DependancyList dependanceys = new DependancyList();
        protected string postClassModStr = "";
        protected string preClassModString = "";
        protected CodeDom.Type genericType = Types.UNSPECIFIED;
        #endregion

        #region Public Methods
        public void ImplementInterface(Interface interfaceToImplement)
        {
            this.Dependancys.Add(new Dependancy() { ProjectTypeDependancy = interfaceToImplement });
            this.implementedInterfaces.Add(interfaceToImplement);
        }
        #endregion

        public Interface(string name)
	{
        if (string.IsNullOrWhiteSpace(name)) name = "unNamedClass";
		this.name = name;
	}
    }
}
