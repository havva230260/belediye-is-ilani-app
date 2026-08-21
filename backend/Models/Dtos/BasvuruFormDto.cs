namespace Backend.Models.Dtos;

public class BasvuruFormDto
{
    public int IlanId { get; set; }
    public int IsArayanId { get; set; }
    public DateTime DogumTarihi { get; set; }
    public string Telefon { get; set; } = string.Empty;
    public string EgitimDurumu { get; set; } = string.Empty;
    public string Universite { get; set; } = string.Empty;
    public string Bolum { get; set; } = string.Empty;
    public string MeslekUzmanlik { get; set; } = string.Empty;
    public int TecrubeYili { get; set; }
    public bool KvkkOnayi { get; set; }
    public IFormFile? CvDosyasi { get; set; }
}