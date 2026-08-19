namespace Backend.Models.Dtos;

public class KayitDto
{
    public string AdSoyad { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public string Sifre { get; set; } = string.Empty;
    public KullaniciRolu Rol { get; set; }
}