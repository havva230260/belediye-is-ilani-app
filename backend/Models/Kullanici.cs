namespace Backend.Models;

public class Kullanici
{
    public int Id { get; set; }
    public string AdSoyad { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string SifreHash { get; set; } = string.Empty; // şifreyi asla düz metin saklamayacağız, ileride "hash"leyeceğiz
    public KullaniciRolu Rol { get; set; }
    public DateTime OlusturmaTarihi { get; set; } = DateTime.Now;
}

public enum KullaniciRolu
{
    IsArayan,
    Isveren
}