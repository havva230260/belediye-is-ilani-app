namespace Backend.Models.Dtos;

public class BasvuruIsverenDto
{
    public int Id { get; set; }
    public int IlanId { get; set; }
    public int IsArayanId { get; set; }
    public string BasvuranAdSoyad { get; set; } = string.Empty;
    public string BasvuranEmail { get; set; } = string.Empty;
    public DateTime DogumTarihi { get; set; }
    public string Telefon { get; set; } = string.Empty;
    public string EgitimDurumu { get; set; } = string.Empty;
    public string Universite { get; set; } = string.Empty;
    public string Bolum { get; set; } = string.Empty;
    public string MeslekUzmanlik { get; set; } = string.Empty;
    public int TecrubeYili { get; set; }
    public string CvDosyaYolu { get; set; } = string.Empty;
    public DateTime BasvuruTarihi { get; set; }
    public string Durum { get; set; } = string.Empty;
    public int? UygunlukPuani { get; set; }
    public string? YapayZekaOzeti { get; set; }
}