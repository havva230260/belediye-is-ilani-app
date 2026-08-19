namespace Backend.Models;

public class Basvuru
{
    public int Id { get; set; }

    public int IlanId { get; set; }
    public Ilan? Ilan { get; set; }

    public int IsArayanId { get; set; }
    public Kullanici? IsArayan { get; set; }

    public DateTime DogumTarihi { get; set; }
    public string Telefon { get; set; } = string.Empty;
    public string EgitimDurumu { get; set; } = string.Empty; // Lise, Ön Lisans, Lisans, Yüksek Lisans
    public string Universite { get; set; } = string.Empty;
    public string Bolum { get; set; } = string.Empty;
    public string MeslekUzmanlik { get; set; } = string.Empty;
    public int TecrubeYili { get; set; }
    public string CvDosyaYolu { get; set; } = string.Empty;

    public DateTime BasvuruTarihi { get; set; } = DateTime.Now;
    public string Durum { get; set; } = "Beklemede"; // Beklemede, İncelendi, Reddedildi, Kabul edildi
}