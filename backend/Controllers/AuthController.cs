using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Backend.Data;
using Backend.Models;
using Backend.Models.Dtos;

namespace Backend.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly AppDbContext _context;
    private readonly IConfiguration _configuration;

    public AuthController(AppDbContext context, IConfiguration configuration)
    {
        _context = context;
        _configuration = configuration;
    }

    [HttpPost("kayit")]
    public async Task<ActionResult> Kayit(KayitDto dto)
    {
        var mevcut = await _context.Kullanicilar.FirstOrDefaultAsync(k => k.Email == dto.Email);
        if (mevcut != null)
            return BadRequest("Bu e-posta adresiyle zaten bir hesap var.");

        var kullanici = new Kullanici
        {
            AdSoyad = dto.AdSoyad,
            Email = dto.Email,
            SifreHash = BCrypt.Net.BCrypt.HashPassword(dto.Sifre),
            Rol = dto.Rol
        };

        _context.Kullanicilar.Add(kullanici);
        await _context.SaveChangesAsync();

        return Ok(new { mesaj = "Kayıt başarılı", kullaniciId = kullanici.Id });
    }

    [HttpPost("giris")]
    public async Task<ActionResult> Giris(GirisDto dto)
    {
        var kullanici = await _context.Kullanicilar.FirstOrDefaultAsync(k => k.Email == dto.Email);
        if (kullanici == null || !BCrypt.Net.BCrypt.Verify(dto.Sifre, kullanici.SifreHash))
            return Unauthorized("E-posta veya şifre hatalı.");

        var token = TokenOlustur(kullanici);
        return Ok(new { token, id = kullanici.Id, adSoyad = kullanici.AdSoyad, rol = kullanici.Rol.ToString() });
    }

    private string TokenOlustur(Kullanici kullanici)
    {
        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, kullanici.Id.ToString()),
            new Claim(ClaimTypes.Email, kullanici.Email),
            new Claim(ClaimTypes.Role, kullanici.Rol.ToString())
        };

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]!));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _configuration["Jwt:Issuer"],
            audience: _configuration["Jwt:Audience"],
            claims: claims,
            expires: DateTime.UtcNow.AddDays(7),
            signingCredentials: creds
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }
}