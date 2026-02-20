using Microsoft.AspNetCore.Mvc;
using AxExtend.Interface;
using System.Data;

namespace AxPlugins
{
    [ApiController]
    [Route("[controller]")]
    public class AxDBController : ControllerBase
    {   

        private readonly IAxExtend _axExtend;

        public AxDBController(IAxExtend axExtend)
        {
            _axExtend = axExtend;
        }


        [HttpGet("AxDBTest")]
        public string AxDBTest()
        {
            return "AxDB Test Success";
        }

        [HttpPost("ExecuteSQL")]
        public async Task<IActionResult> ExecuteSQL(AxDB sqlInput)
        {

            try
            {
                var sqlType = GetSqlCommandType(sqlInput.SQL);

                var isDBConnected = await _axExtend.OpenDBConnectionAsync(sqlInput.AppName);
                if(isDBConnected) { 
                    var db = await _axExtend.GetDB();
                    if (sqlType == "SELECT")
                    {
                        var result = await db.ExecuteSQLAsync(sqlInput.SQL);
                        if (string.IsNullOrEmpty(result.error))
                        {
                            var table = result.data;

                            var rows = table.AsEnumerable()
                                .Select(row => table.Columns.Cast<DataColumn>()
                                    .ToDictionary(col => col.ColumnName, col => row[col]))
                                .ToList();
                            return Ok(new { Rows = rows });
                        }
                        else
                            return BadRequest(result.error);
                    }
                    else if (sqlType == "INSERT" || sqlType == "UPDATE" || sqlType == "DELETE")
                    {
                        var affectedRows = await db.ExecuteNonQueryAsync(sqlInput.SQL);
                        if (string.IsNullOrEmpty(affectedRows.error))
                        {
                            return Ok(new { AffectedRows = affectedRows.count });
                        }
                        else
                            return BadRequest(affectedRows.error);
                    }
                    else
                    {
                        return BadRequest("Unsupported SQL command type.");
                    }
                }
                else
                {
                    return BadRequest("Unable to connect to DB.");
                }
            }
            catch (Exception ex)
            {
                return BadRequest($"Error: {ex.Message}");
            }
            finally
            {
                _axExtend.CloseDBConnectionAsync().GetAwaiter().GetResult();
            }

        }

        private string GetSqlCommandType(string sql)
        {
            if (string.IsNullOrWhiteSpace(sql))
                return "UNKNOWN";

            string firstWord = sql.TrimStart().Split(new[] { ' ', '\r', '\n', '\t' }, StringSplitOptions.RemoveEmptyEntries).FirstOrDefault()?.ToUpper();

            return firstWord switch
            {
                "SELECT" => "SELECT",
                "INSERT" => "INSERT",
                "UPDATE" => "UPDATE",
                "DELETE" => "DELETE",
                _ => "OTHER"
            };
        }


    }
}