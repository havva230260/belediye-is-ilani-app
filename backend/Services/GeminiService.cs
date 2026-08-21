using System.Net.Http.Json;
using System.Text.Json;

namespace Backend.Services;

public class GeminiService
{
    private readonly HttpClient _httpClient;
    private readonly string _apiKey;

    public GeminiService(HttpClient httpClient, IConfiguration configuration)
    {
        _httpClient = httpClient;
        _apiKey = configuration["Gemini:ApiKey"] ?? string.Empty;
    }

    public async Task<(int puan, string ozet)> CvUygunlugunuDegerlendir(
        string cvMetni, string ilanBaslik, string ilanAciklama, string ilanMeslek)
    {
        if (string.IsNullOrWhiteSpace(_apiKey))
        {
            return (0, "Yapay zeka anahtarı yapılandırılmamış.");
        }
        if (string.IsNullOrWhiteSpace(cvMetni))
        {
            return (0, "CV metni okunamadığı için değerlendirilemedi.");
        }

        var prompt =
            "Sen bir işe alım asistanısın. Aşağıdaki iş ilanı ile adayın CV'sini karşılaştır.\n\n" +
            $"İlan Başlığı: {ilanBaslik}\n" +
            $"İlan Mesleği: {ilanMeslek}\n" +
            $"İlan Açıklaması: {ilanAciklama}\n\n" +
            $"Adayın CV Metni:\n{cvMetni}\n\n" +
            "Bu adayın bu ilana uygunluğunu 0 ile 100 arasında bir puanla değerlendir (100 = mükemmel uyum). " +
            "Ayrıca 1-2 cümlelik kısa bir Türkçe gerekçe yaz.\n\n" +
            "SADECE şu JSON formatında cevap ver, başka hiçbir şey yazma:\n" +
            "{\"puan\": <sayı>, \"ozet\": \"<gerekçe>\"}";

        var istekGovdesi = new
        {
            contents = new[]
            {
                new { parts = new[] { new { text = prompt } } }
            }
        };

        var url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash-lite:generateContent?key={_apiKey}";

        try
        {
            var yanit = await _httpClient.PostAsJsonAsync(url, istekGovdesi);
            if (!yanit.IsSuccessStatusCode)
            {
                return (0, $"Yapay zeka servisi hata döndü (kod: {(int)yanit.StatusCode}).");
            }

            var json = await yanit.Content.ReadFromJsonAsync<JsonElement>();
            var metin = json
                .GetProperty("candidates")[0]
                .GetProperty("content")
                .GetProperty("parts")[0]
                .GetProperty("text")
                .GetString() ?? string.Empty;

            metin = metin.Trim();
            if (metin.StartsWith("```"))
            {
                var ilkSatirSonu = metin.IndexOf('\n');
                var sonBlok = metin.LastIndexOf("```");
                if (ilkSatirSonu >= 0 && sonBlok > ilkSatirSonu)
                {
                    metin = metin.Substring(ilkSatirSonu + 1, sonBlok - ilkSatirSonu - 1).Trim();
                }
            }

            var sonucJson = JsonDocument.Parse(metin);
            var puan = sonucJson.RootElement.GetProperty("puan").GetInt32();
            var ozet = sonucJson.RootElement.GetProperty("ozet").GetString() ?? string.Empty;

            return (puan, ozet);
        }
        catch (Exception ex)
        {
            return (0, $"Değerlendirme sırasında bir hata oluştu: {ex.Message}");
        }
    }
}