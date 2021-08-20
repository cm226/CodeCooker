/*
 * InvalidArgumanentException.h
 *
 *  Created on: 7 Jan 2013
 *      Author: craig
 */



namespace CodeDom.OO
{

public class ArgumentExeption: CodeDom.Exceptions.CodeDomException
{
  public ArgumentExeption(string message):base(message)
  {

  }
  private string what()
  {
	return "Invalid Argument Exception";
  }
}

} // namespace CodeGenerators