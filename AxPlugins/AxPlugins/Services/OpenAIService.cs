using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

namespace AxPlugins
{
    public class OpenAIService
    {
        private readonly HttpClient _httpClient;
        private readonly string _apiKey;

        public OpenAIService(HttpClient httpClient)
        {
            _httpClient = httpClient;
            _apiKey = "Your API key here...";
        }

        public async Task<string> AskChatGPT(string userPrompt)
        {
            var requestBody = new
            {
                model = "gpt-4.1-mini",
                input = userPrompt
            };

            var request = new HttpRequestMessage(
                HttpMethod.Post,
                "https://api.openai.com/v1/responses"
            );

            request.Headers.Authorization =
                new AuthenticationHeaderValue("Bearer", _apiKey);

            request.Content = new StringContent(
                JsonSerializer.Serialize(requestBody),
                Encoding.UTF8,
                "application/json"
            );

            var response = await _httpClient.SendAsync(request);
            response.EnsureSuccessStatusCode();

            var json = await response.Content.ReadAsStringAsync();

            using var doc = JsonDocument.Parse(json);
            var outputText = doc.RootElement
                .GetProperty("output")[0]
                .GetProperty("content")[0]
                .GetProperty("text")
                .GetString();

            return outputText;
        }
    }

}
