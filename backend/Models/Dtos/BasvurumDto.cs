namespace Backend.Models.Dtos;

public class BasvurumDto
{
    public int Id { get; set; }
    public int IlanId { get; set; }
    public string IlanBaslik { get; set; } = string.Empty;
    public string IlanMeslek { get; set; } = string.Empty;
    public string IlanKonum { get; set; } = string.Empty;
    public DateTime BasvuruTarihi { get; set; }
    public string Durum { get; set; } = string.Empty;
}