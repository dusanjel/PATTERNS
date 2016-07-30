using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;

[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedType(Format.UserDefined, 
                                               MaxByteSize=24)]

public struct Valuta : INullable, IBinarySerialize
{
    public bool IsNull
    {
        get
        {
            return _null;
        }
    }

    public static Valuta Null
    {
        get
        {
            Valuta h = new Valuta();
            h._null = true;
            return h;
        }
    }
    public override string ToString()
    {
        return _vrednost.ToString() + " " + valuta;
    }

    public static Valuta Parse(SqlString s)
    {
        if (s.IsNull || 
            string.IsNullOrEmpty(s.Value) || 
            s.Value.Length < 2 ||
            string.Equals(s.Value, "NULL", 
                          StringComparison.OrdinalIgnoreCase))
        {
            return Valuta.Null;
        }
        Valuta u = new Valuta();
        u.valuta = s.Value;
        u._vrednost = Decimal.Parse(s.Value.Substring(1));
        return u;
    }
    public string Simbol
    {
        get
        {
            return valuta;
        }
    }

    [SqlMethod(IsMutator=true)]
    public void IzmeniSimbol(string novaVrednost)
    {
        valuta = novaVrednost;
    }

    public static Valuta KreirajValutu(string symbol, Decimal vrednost)
    {
        Valuta c = new Valuta();
        c.valuta = symbol;
        c._vrednost = vrednost;
        return c;
    }
    private string valuta;
    private Decimal _vrednost;
    private bool _null;

    public void Read(BinaryReader r)
    {
        _null = r.ReadBoolean();
        valuta = r.ReadString();
        _vrednost = r.ReadDecimal();
    }

    public void Write(BinaryWriter w)
    {
        w.Write(_null);
        w.Write(valuta);
        w.Write(_vrednost);
    }
}
