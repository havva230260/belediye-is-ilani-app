using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Backend.Data;
using Backend.Models;

namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class IlanlarController : ControllerBase
{
    private readonly AppDbContext _context;

    public IlanlarController(AppDbContext context)
    {
        _context = context;
    }

    // GET: api/ilanlar
    [HttpGet]
    public async Task<ActionResult<IEnumerable<Ilan>>> GetIlanlar()
    {
        return await _context.Ilanlar.ToListAsync();
    }

    // GET: api/ilanlar/isveren/5
    [HttpGet("isveren/{isverenId}")]
    public async Task<ActionResult<IEnumerable<Ilan>>> GetIlanlarByIsveren(int isverenId)
    {
        return await _context.Ilanlar
            .Where(i => i.IsverenId == isverenId)
            .OrderByDescending(i => i.OlusturmaTarihi)
            .ToListAsync();
    }

    // GET: api/ilanlar/5
    [HttpGet("{id}")]
    public async Task<ActionResult<Ilan>> GetIlan(int id)
    {
        var ilan = await _context.Ilanlar.FindAsync(id);
        if (ilan == null) return NotFound();
        return ilan;
    }

    // POST: api/ilanlar
    [HttpPost]
    public async Task<ActionResult<Ilan>> CreateIlan(Ilan ilan)
    {
        _context.Ilanlar.Add(ilan);
        await _context.SaveChangesAsync();
        return CreatedAtAction(nameof(GetIlan), new { id = ilan.Id }, ilan);
    }

    // PUT: api/ilanlar/5
    [HttpPut("{id}")]
    public async Task<IActionResult> UpdateIlan(int id, Ilan ilan)
    {
        if (id != ilan.Id) return BadRequest();
        _context.Entry(ilan).State = EntityState.Modified;
        await _context.SaveChangesAsync();
        return NoContent();
    }

    // DELETE: api/ilanlar/5
    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteIlan(int id)
    {
        var ilan = await _context.Ilanlar.FindAsync(id);
        if (ilan == null) return NotFound();
        _context.Ilanlar.Remove(ilan);
        await _context.SaveChangesAsync();
        return NoContent();
    }
}
