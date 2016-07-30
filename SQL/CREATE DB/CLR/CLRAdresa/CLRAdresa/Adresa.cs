using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;
[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined,
MaxByteSize = 800)]
public struct Adresa : INullable, IBinarySerialize
{
public bool IsNull
{
get
{
// Put your code here
return m_Null;
}
}
public static Adresa Null
{
get
{
Adresa h = new Adresa();
h.m_Null = true;
return h;
}
}
private string nazivUlice;
private int broj;
private string dodatakBroju;
private bool m_Null;
public Adresa(string nazivUlice, int broj, string dodatakBroju)
{
this.nazivUlice = nazivUlice;
this.broj = broj;
this.dodatakBroju = dodatakBroju;
m_Null = false;
}
public override string ToString()
{
if (this.IsNull)
return "null";
else
{
string delim = new string((new char[] { ';' }));
return(this.nazivUlice + delim + this.broj + delim +
this.dodatakBroju);
}
}
public static Adresa Parse(SqlString s)
{
if (s.IsNull)
return Null;
else
{
Adresa addr = new Adresa();
string str = Convert.ToString(s);
string[] a = null;
a = str.Split(new char[] { ';' });
addr.nazivUlice = a[0] == null ? string.Empty :
a[0];
int broj = Convert.ToInt32(a[1]);
ValidateBroj(broj);
addr.broj = broj;
if (a.Length == 3)
{
addr.dodatakBroju = a[2];
}
else
{
addr.dodatakBroju = string.Empty;
}
addr.m_Null = false;
return (addr);
}
}
private static void ValidateBroj(int broj)
{
if (broj < 0)
{
throw new ArgumentOutOfRangeException("Broj ne može biti manji od 0");
}
}
public string NazivUlice
{
get
{
return (this.nazivUlice);
}
set
{
this.nazivUlice = value;
this.m_Null = false;
}
}
public int Broj
{
get
{
return (this.broj);
}
set
{
this.broj = value;
this.m_Null = false;
}
}
public string DodatakBroju
{
get
{
return (this.dodatakBroju);
}
set
{
if (!string.IsNullOrEmpty(value))
{
this.dodatakBroju = value;
this.m_Null = false;
}
}
}
public override bool Equals(object other)
{
return this.CompareTo(other) == 0;
}
public override int GetHashCode()
{
if (this.IsNull)
return 0;
return this.ToString().GetHashCode();
}
public int CompareTo(object other)
{
if (other == null)
return 1; //by definition
Adresa addr = (Adresa)other;
if (addr.Equals(null))
throw new ArgumentException("the argument to compare is not a adresa");
if (this.IsNull)
{
if (addr.IsNull)
return 0;
return -1;
}
if (addr.IsNull)
return 1;
return this.ToString().CompareTo(addr.ToString());
}
public void Write(System.IO.BinaryWriter w)
{
byte header = (byte)(this.IsNull ? 1 : 0);
w.Write(header);
if (header == 1)
{
return;
}
w.Write(this.NazivUlice);
ValidateBroj(this.Broj);
w.Write(this.Broj);
w.Write(this.DodatakBroju);
}
public void Read(System.IO.BinaryReader r)
{
byte header = r.ReadByte();
if (header == 1)
{
this.m_Null = true;
return;
}
this.m_Null = false;
this.nazivUlice = r.ReadString();
int broj = r.ReadInt32();
ValidateBroj(broj);
this.broj = broj;
this.dodatakBroju = r.ReadString();
}
}