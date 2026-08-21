using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;
using Backend.Models.Dtos;

namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BasvurularController : ControllerBase
{
    private readonly AppDbContext _context;
    public BasvurularController(AppDbContext context) { _context = context; }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<Basvuru>>> GetBasvurular() =>
        await _context.Basvurular.ToListAsync();

    [HttpGet("ilan/{ilanId}")]
    public async Task<ActionResult<IEnumerable<Basvuru>>> GetBasvurularByIlan(int ilanId) =>
        await _context.Basvurular.Where(b => b.IlanId == ilanId).ToListAsync();

    [HttpGet("kontrol")]
    public async Task<ActionResult<bool>> BasvuruKontrol([FromQuery] int ilanId, [FromQuery] int isArayanId)
    {
        var basvurmusMu = await _context.Basvurular
            .AnyAsync(b => b.IlanId == ilanId && b.IsArayanId == isArayanId);
        return basvurmusMu;
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<Basvuru>> GetBasvuru(int id)
    {
        var basvuru = await _context.Basvurular.FindAsync(id);
        if (basvuru == null) return NotFound();
        return basvuru;
    }

    [HttpPost]
    [Consumes("multipart/form-data")]
    public async Task<ActionResult<Basvuru>> CreateBasvuru([FromForm] BasvuruFormDto dto)
    {
        var zatenBasvurmus = await _context.Basvurular
            .AnyAsync(b => b.IlanId == dto.IlanId && b.IsArayanId == dto.IsArayanId);
        if (zatenBasvurmus)
            return Conflict("Bu ilana zaten başvurdunuz.");

        string cvDosyaYolu = string.Empty;
        if (dto.CvDosyasi != null && dto.CvDosyasi.Length > 0)
        {
            if (dto.CvDosyasi.ContentType != "application/pdf")
                return BadRequest("Sadece PDF dosyaları kabul edilir.");
            if (dto.CvDosyasi.Length > 5 * 1024 * 1024)
                return BadRequest("Dosya boyutu 5MB'ı geçemez.");

            var uploadsKlasoru = Path.Combine(Directory.GetCurrentDirectory(), "wwwroot", "uploads", "cv");
            Directory.CreateDirectory(uploadsKlasoru);
            var dosyaAdi = $"{Guid.NewGuid()}_{dto.CvDosyasi.FileName}";
            var tamYol = Path.Combine(uploadsKlasoru, dosyaAdi);
            using (var stream = new FileStream(tamYol, FileMode.Create))
            {
                await dto.CvDosyasi.CopyToAsync(stream);
            }
            cvDosyaYolu = $"/uploads/cv/{dosyaAdi}";
        }
        else
        {
            return BadRequest("CV dosyası zorunludur.");
        }

        var basvuru = new Basvuru
        {
            IlanId = dto.IlanId, IsArayanId = dto.IsArayanId, DogumTarihi = dto.DogumTarihi,
            Telefon = dto.Telefon, EgitimDurumu = dto.EgitimDurumu, Universite = dto.Universite,
            Bolum = dto.Bolum, MeslekUzmanlik = dto.MeslekUzmanlik, TecrubeYili = dto.TecrubeYili,
            CvDosyaYolu = cvDosyaYolu
        };
        _context.Basvurular.Add(basvuru);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetBasvuru), new { id = basvuru.Id }, basvuru);
    }

    [HttpPut("{id}/durum")]
    public async Task<IActionResult> UpdateDurum(int id, [FromBody] string yeniDurum)
    {
        var basvuru = await _context.Basvurular.FindAsync(id);
        if (basvuru == null) return NotFound();
        basvuru.Durum = yeniDurum;
        await _context.SaveChangesAsync();
        return NoContent();
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteBasvuru(int id)
    {
        var basvuru = await _context.Basvurular.FindAsync(id);
        if (basvuru == null) return NotFound();
        _context.Basvurular.Remove(basvuru);
        await _context.SaveChangesAsync();
        return NoContent();
    }
}