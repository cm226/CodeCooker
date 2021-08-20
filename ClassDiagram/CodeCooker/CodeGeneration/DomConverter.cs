using CodeCooker.Models;
using CodeCooker.Models.ClassDiagram;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CodeCooker.CodeGeneration
{
    public class DomConverter
    {
        private Models.DocumentModel document;
        private Dictionary<int, int> ClassDependenceys = new Dictionary<int, int>();
        private Dictionary<int, string> ClassIDList = new Dictionary<int, string>();

        private Dictionary<int, List<int>> InterfaceDependenceys = new Dictionary<int, List<int>>();
        private Dictionary<int, string> InterfaceIDList = new Dictionary<int, string>();

        private Dictionary<int, NamespaceModel> NamespaceIDList = new Dictionary<int, NamespaceModel>();

        private Dictionary<int, CodeDom.OO.GenericClass> Classes = new Dictionary<int, CodeDom.OO.GenericClass>();
        private Dictionary<int, CodeDom.OO.Interface> Interfaces = new Dictionary<int, CodeDom.OO.Interface>();


        /*
        * Fix this absolute ballz function TODO
        */
        public void convertDocumentToDom(Models.DocumentModel document,
                                        CodeDom.OO.AbstractOOCodeGenerator codeGen)
        {
            this.document = document;
            foreach (ClassModel cm in this.document.classList)
            {
                this.ClassIDList[cm.id] = cm.Name;
            }

            foreach (InterfaceModel im in this.document.interfaceList)
            {
                this.InterfaceIDList[im.id] = im.Name;
            }

            foreach (NamespaceModel nm in this.document.namespaceList)
            {
                this.NamespaceIDList[nm.id] = nm;
            }

            foreach (ArrowModel arrowItem in this.document.arrowList)
            {
                if (this.ClassDependenceys.ContainsKey(arrowItem.Tail.LockedClass))
                {
                    // decide what to do here TODO (multiple inheritance)
                }
                if (arrowItem.Tail.LockedClass > -1 && arrowItem.Head.LockedClass > -1)
                {
                    if (this.ClassIDList.ContainsKey(arrowItem.Head.LockedClass)) // class derives from another class
                        this.ClassDependenceys[arrowItem.Tail.LockedClass] = arrowItem.Head.LockedClass;
                    else if (this.InterfaceIDList.ContainsKey(arrowItem.Head.LockedClass))
                    {
                        if (!this.InterfaceDependenceys.ContainsKey(arrowItem.Tail.LockedClass))
                            this.InterfaceDependenceys[arrowItem.Tail.LockedClass] = new List<int>();

                        this.InterfaceDependenceys[arrowItem.Tail.LockedClass].Add(arrowItem.Head.LockedClass);
                        
                    }
                }
            }

            foreach (ClassModel classItem in this.document.classList)
            {
                CodeDom.OO.GenericClass gClass = new CodeDom.OO.GenericClass(classItem.Name);
                gClass.Namespaces.Add(this.document.Name);
                gClass.ClassComment = classItem.Comment;
                gClass.IsStatic = classItem.Static;
                switch (classItem.Visibility)
                {
                    case Visibility.PRIVATE:
                        gClass.Visibiltity = CodeDom.OO.Interface.Visibility.PRIVATE;
                        break;
                    case Visibility.PROTECTED:
                        gClass.Visibiltity = CodeDom.OO.Interface.Visibility.PROTECTED;
                        break;
                    default:
                        gClass.Visibiltity = CodeDom.OO.Interface.Visibility.PUBLIC;
                        break;
                }

                foreach (Property classprop in classItem.Properties.Items)
                {
                    CodeDom.OO.Member newMember = new CodeDom.OO.Member(createTypeFromString(classprop.Type), classprop.Name);
                    if (classprop.Static)
                        newMember.IsStatic = true;

                    switch (classprop.Visibility)
                    {
                        case Visibility.PUBLIC:
                            gClass.PublicProperties.Add(newMember);
                            break;
                        case Visibility.PRIVATE:
                            gClass.PrivateProperties.Add(newMember);
                            break;
                        case Visibility.PROTECTED:
                            gClass.ProtectedProperties.Add(newMember);
                            break;
                    }
                }

                foreach (Method classMethod in classItem.Methods.Items)
                {
                    CodeDom.OO.Method method = new CodeDom.OO.Method(classMethod.Name);
                    method.Return = createTypeFromString(classMethod.Return);
                    method.Arguments = convertArgs(classMethod.Args);
                    method.Abstract = classMethod.Abstract;
                    method.Static = classMethod.Static;
                    method.Comment = classMethod.Comment;

                    switch (classMethod.Visibility)
                    {
                        case Visibility.PUBLIC:
                            if (classMethod.Name.CompareTo(classItem.Name) == 0 && !gClass.ConstructorSet)
                                gClass.Constructor = method;
                            else
                                gClass.PublicMethods.Add(method);
                            break;
                        case Visibility.PRIVATE:
                            if (classMethod.Name.CompareTo(classItem.Name) == 0 && !gClass.ConstructorSet)
                                gClass.Constructor = method;
                            else
                                gClass.PrivateMethods.Add(method);
                            break;
                        case Visibility.PROTECTED:
                            if (classMethod.Name.CompareTo(classItem.Name) == 0 && !gClass.ConstructorSet)
                                gClass.Constructor = method;
                            else
                                gClass.ProtectedMethods.Add(method);
                            break;
                    }

                }

                this.Classes[classItem.id] = gClass;
                codeGen.addClass(gClass);
            }

            foreach (InterfaceModel interfaceModel in this.document.interfaceList)
            {
                CodeDom.OO.Interface gInterface = new CodeDom.OO.Interface(interfaceModel.Name);
                gInterface.Namespaces.Add(this.document.Name);
                gInterface.ClassComment = interfaceModel.Comment;
                gInterface.IsStatic = interfaceModel.Static;

                switch (interfaceModel.Visibility)
                {
                    case Visibility.PRIVATE:
                        gInterface.Visibiltity = CodeDom.OO.Interface.Visibility.PRIVATE;
                        break;
                    case Visibility.PROTECTED:
                        gInterface.Visibiltity = CodeDom.OO.Interface.Visibility.PROTECTED;
                        break;
                    default:
                        gInterface.Visibiltity = CodeDom.OO.Interface.Visibility.PUBLIC;
                        break;
                }

                foreach (Method classMethod in interfaceModel.Methods)
                {
                    CodeDom.OO.Method method = new CodeDom.OO.Method(classMethod.Name);
                    method.Return = createTypeFromString(classMethod.Return);
                    method.Arguments = convertArgs(classMethod.Args);
                    classMethod.Abstract = method.Abstract;
                    classMethod.Static = method.Static;
                    classMethod.Comment = method.Comment;
                    gInterface.PublicMethods.Add(method);

                }

                this.Interfaces[interfaceModel.id] = gInterface;
                codeGen.addInterface(gInterface);
            }
            //--------------------------------------------------------------------------------------------------//
            //                                             SECOND PASS                                          //
            //--------------------------------------------------------------------------------------------------//

            foreach (ClassModel classItem in this.document.classList)
            {
                if (this.ClassDependenceys.ContainsKey(classItem.id))
                    this.Classes[classItem.id].setBaseClass(this.Classes[this.ClassDependenceys[classItem.id]]);

                if (this.InterfaceDependenceys.ContainsKey(classItem.id))
                {
                    foreach (int interfaceID in this.InterfaceDependenceys[classItem.id])
                        this.Classes[classItem.id].ImplementInterface(this.Interfaces[interfaceID]);
                }
            }

            foreach (InterfaceModel interfaceModel in this.document.interfaceList)
            {
                if (this.InterfaceDependenceys.ContainsKey(interfaceModel.id))
                {
                    foreach (int interfaceID in this.InterfaceDependenceys[interfaceModel.id])
                        this.Interfaces[interfaceModel.id].ImplementInterface(this.Interfaces[interfaceID]);
                }
            }

            List<CodeDom.OO.Dom.NamespaceGroup> namespaces = buildNamespaceTree();
            foreach (CodeDom.OO.Dom.NamespaceGroup ns in namespaces)
                ns.Apply();


        }

        private List<CodeDom.OO.Method.typeName> convertArgs(string args)
        {
            if (string.IsNullOrEmpty(args))
                return new List<CodeDom.OO.Method.typeName>();

            List<CodeDom.OO.Method.typeName> convertedArgs = new List<CodeDom.OO.Method.typeName>();
            string[] argList = args.Split(',');
            foreach (string arg in argList)
            {
                string[] type_Name = arg.Trim().Split(':');
                if (type_Name.Length != 2)
                    throw new CodeDom.Exceptions.CodeDomException("The Argument: "+arg+" is of an invalid format");

                convertedArgs.Add(new CodeDom.OO.Method.typeName()
                {
                    name = type_Name[0].Trim(),
                    t = createTypeFromString(type_Name[1].Trim())
                });
            }

            return convertedArgs;
        }

        private List<CodeDom.OO.Dom.NamespaceGroup> buildNamespaceTree()
        {
            NamespaceTreeBuilder builder = new NamespaceTreeBuilder();
            int id = 0;
            foreach (NamespaceModel ns in this.document.namespaceList)
            {
                CodeDom.OO.Dom.NamespaceGroup namespaceGroup = builder.createOrGet(ns);
                foreach (ClassItem classItem in ns.classes)
                {
                    id = classItem.classID;
                    if (isNamespaceID(id))
                    {
                        CodeDom.OO.Dom.NamespaceGroup childNS = builder.createOrGet(this.NamespaceIDList[id]);
                        childNS.parent = namespaceGroup;

                        namespaceGroup.Children.Add(childNS);
                    }
                    else
                    {
                        if (InterfaceIDList.ContainsKey(id))
                            namespaceGroup.InterfacesAndClassMembers.Add(this.Interfaces[id]);
                        else
                            namespaceGroup.InterfacesAndClassMembers.Add(this.Classes[id]);
                    }

                }

            }
            return builder.UnFlatten();

        }



        private bool isNamespaceID(int id)
        {
            if (this.ClassIDList.ContainsKey(id) ||
                this.InterfaceIDList.ContainsKey(id))
                return false;
            return true;

        }

        private CodeDom.Type createTypeFromString(string type)
        {
            switch(type)
            {
                case "String":
                    return CodeDom.Types.STRING;
                case "Int":
                    return CodeDom.Types.INT;
                case "Float":
                    return CodeDom.Types.FLOAT;
                case "Boolean":
                    return CodeDom.Types.BOOLEAN;
                case "Time":
                    return CodeDom.Types.TIME;
                case "Date":
                    return CodeDom.Types.DATE;
                case "DateTime":
                    return CodeDom.Types.DATETIME;
                default:
                    return new CodeDom.Type(type);

            }
        }
    }
}