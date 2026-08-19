namespace Backend.Models;

public class Ilan
{
    public int Id { get; set; }
    public string Baslik { get; set; } = string.Empty;
    public string Aciklama { get; set; } = string.Empty;
    public string Meslek { get; set; } = string.Empty;
    public string Konum { get; set; } = string.Empty;
    public DateTime SonBasvuruTarihi { get; set; }
    public DateTime OlusturmaTarihi { get; set; } = DateTime.Now;

    public int IsverenId { get; set; }
    public Kullanici? Isveren { get; set; }

    public List<Basvuru> Basvurular { get; set; } = new();
}