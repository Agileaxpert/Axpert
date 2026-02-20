using Microsoft.AspNetCore.Mvc;
using AxExtend.Interface;
using Microsoft.AspNetCore.Authorization;

namespace AxPlugins
{
    [ApiController]
    [Route("[controller]")]
    public class AxRedisController : ControllerBase
    {

        private readonly ILogger<AxRedisController> _logger;

        private readonly IAxExtend _axExtend;

        public AxRedisController(ILogger<AxRedisController> logger, IAxExtend axExtend)
        {
            _logger = logger;
            _axExtend = axExtend;
        }

        [HttpGet("AxRedisTest")]
        public string AxRedisTest()
        {
            return "AxRedis Test Success";
        }

        [HttpPost("StringGet")]
        public async Task<IActionResult> StringGetWithNoAuth(AxRedis redis)
        {
            try
            {
                var redisConnected = await _axExtend.OpenRedisConnectionAsync(redis.AppName);
                if (redisConnected)
                {
                    var redisCache = await _axExtend.GetRedis();
                    var keyExists = await redisCache.KeyExistsAsync(redis.Key);
                    if (!keyExists)
                    {
                        return NotFound($"Key '{redis.Key}' not found in Redis.");
                    }
                    var value = await redisCache.StringGetAsync(redis.Key);

                    return Ok(value?.ToString() ?? "");
                }
                else
                {
                    return BadRequest("Unable to connect to Redis.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Error: {ex.Message}");
            }
            finally
            {
                _axExtend.CloseRedisConnectionAsync().GetAwaiter().GetResult();
            }

        }

        [HttpPost("StringSet")]
        public async Task<IActionResult> StringSetWithNoAuth(AxRedis redis)
        {
            try
            {
                var redisConnected = await _axExtend.OpenRedisConnectionAsync(redis.AppName);
                if (redisConnected)
                {
                    var redisCache = await _axExtend.GetRedis();
                    var value = await redisCache.StringSetAsync(redis.Key, redis.Value, redis.ExpiryInSeconds);
                    return Ok(value);
                }
                else
                {
                    return BadRequest("Unable to connect to Redis.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Error: {ex.Message}");
            }
            finally
            {
                _axExtend.CloseRedisConnectionAsync().GetAwaiter().GetResult();
            }

        }

        [Authorize]
        [HttpPost("Auth/StringGet")]
        public async Task<IActionResult> StringGetWithAuth(AxRedis redis)
        {
            try
            {
                var redisConnected = await _axExtend.OpenRedisConnectionAsync(redis.ARMSessionId);
                if (redisConnected)
                {
                    var redisCache = await _axExtend.GetRedis();
                    var keyExists = await redisCache.KeyExistsAsync(redis.Key);
                    if (!keyExists)
                    {
                        return NotFound($"Key '{redis.Key}' not found in Redis.");
                    }
                    var value = await redisCache.StringGetAsync(redis.Key);

                    return Ok(value?.ToString() ?? "");
                }
                else
                {
                    return BadRequest("Unable to connect to Redis.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Error: {ex.Message}");
            }
            finally
            {
                _axExtend.CloseRedisConnectionAsync().GetAwaiter().GetResult();
            }

        }

        [Authorize]
        [HttpPost("Auth/StringSet")]
        public async Task<IActionResult> StringSetWithAuth(AxRedis redis)
        {
            try
            {
                var redisConnected = await _axExtend.OpenRedisConnectionAsync(redis.ARMSessionId);
                if (redisConnected)
                {
                    var redisCache = await _axExtend.GetRedis();
                    var value = await redisCache.StringSetAsync(redis.Key, redis.Value, redis.ExpiryInSeconds);
                    return Ok(value);
                }
                else
                {
                    return BadRequest("Unable to connect to Redis.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Error: {ex.Message}");
            }
            finally
            {
                _axExtend.CloseRedisConnectionAsync().GetAwaiter().GetResult();
            }

        }

    }

}