/*
 * CppCodeGenerator.cpp
 *
 *  Created on: 3 Jan 2013
 *      Author: craig
 */

using CodeDom.OO.C__;
using System.Collections.Generic;
using System;
using System.IO;
using CodeDom.OO.Dom.Completeres;

namespace CodeDom.OO.CPP
{
public class CppCodeGenerator : AbstractOOCodeGenerator
{

    private List<GenericClass> classes = new List<GenericClass>();
    private List<Interface> interfaces = new List<Interface>();

    public CppCodeGenerator(string fileName)
        : base(fileName)
	{
    
	}
	public override void addClass(GenericClass gclass)
	{
		this.classes.Add(gclass);
	}

    public override void addInterface(Interface interfaceModel)
    {
        this.interfaces.Add(interfaceModel);
    }
	public override void save()
	{

        Utils.DirectoryResolver directoryResolver = new Utils.DirectoryResolver();
        directoryResolver.RootDir = this.directory.AbsolutePath;

        EasyComplete allCompleters = new EasyComplete();
		foreach(GenericClass classit in this.classes)
        {
            allCompleters.Complete(classit);
            directoryResolver.namespaces = classit.Namespaces.ToList();
            Uri dir = directoryResolver.Resolve();
            Directory.CreateDirectory(dir.AbsolutePath);

			CppClass classWriter = new CppClass(classit);
			CppHeader headerWriter = new CppHeader(classit);

            classWriter.write(dir.AbsolutePath);
            headerWriter.write(dir.AbsolutePath);
		}

        foreach(Interface interfaceModel in this.interfaces)
        {
            CPPInterface interfaceWritter = new CPPInterface(interfaceModel);
            interfaceWritter.write(this.directory.AbsolutePath);
        }
	}
}
}