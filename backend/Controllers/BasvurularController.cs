using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;

namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class BasvurularController : ControllerBase
{
    private readonly AppDbContext _context;

    public BasvurularController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/basvurular
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Basvuru>>> GetBasvurular()
    {
        return await _context.Basvurular.ToListAsync();
    }

    // GET: api/basvurular/ilan/5 -> belirli bir ilana gelen tüm başvurular (işveren paneli için)
    [HttpGet("ilan/{ilanId}")]
    public async Task<ActionResult<IEnumerable<Basvuru>>> GetBasvurularByIlan(int ilanId)
    {
        return await _context.Basvurular.Where(b => b.IlanId == ilanId).ToListAsync();
    }

    // GET: api/basvurular/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Basvuru>> GetBasvuru(int id)
    {
        var basvuru = await _context.Basvurular.FindAsync(id);
        if (basvuru == null) return NotFound();
        return basvuru;
    }

    // POST: api/basvurular
    [HttpPost]
    public async Task<ActionResult<Basvuru>> CreateBasvuru(Basvuru basvuru)
    {
        _context.Basvurular.Add(basvuru);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetBasvuru), new { id = basvuru.Id }, basvuru);
    }

    // PUT: api/basvurular/5/durum -> işveren başvuru durumunu günceller
    [HttpPut("{id}/durum")]
    public async Task<IActionResult> UpdateDurum(int id, [FromBody] string yeniDurum)
    {
        var basvuru = await _context.Basvurular.FindAsync(id);
        if (basvuru == null) return NotFound();
        basvuru.Durum = yeniDurum;
        await _context.SaveChangesAsync();
        return NoContent();
    }

    // DELETE: api/basvurular/5
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